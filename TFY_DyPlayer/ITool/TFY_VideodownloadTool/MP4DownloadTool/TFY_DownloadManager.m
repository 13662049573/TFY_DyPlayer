//
//  TFY_DownloadManager.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/25.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_DownloadManager.h"
#import "NSURLSession+TFY_CorrectedResumeData.h"
#import "TFY_DataBaseManager.h"
#import "AppDelegate.h"


@interface TFY_DownloadManager ()<NSURLSessionDelegate, NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSession *session;                 // NSURLSession
@property (nonatomic, strong) NSMutableDictionary *dataTaskDic;      // 同时下载多个文件，需要创建多个NSURLSessionDownloadTask，用该字典来存储
@property (nonatomic, strong) NSMutableDictionary *downloadTaskDic;  // 记录任务调用startDownloadTask:方法时间，禁止同一任务极短时间重复调用，防止状态显示错误
@property (nonatomic, assign) NSInteger currentCount;                // 当前正在下载的个数
@property (nonatomic, assign) NSInteger maxConcurrentCount;          // 最大同时下载数量
@property (nonatomic, assign) BOOL allowsCellularAccess;             // 是否允许蜂窝网络下载

@end

@implementation TFY_DownloadManager

+ (instancetype)shareManager
{
    static TFY_DownloadManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        // 初始化
        _currentCount = 0;
        _maxConcurrentCount = [[NSUserDefaults standardUserDefaults] integerForKey:DownloadMaxConcurrentCountKey];
        _allowsCellularAccess = [[NSUserDefaults standardUserDefaults] boolForKey:DownloadAllowsCellularAccessKey];
        _dataTaskDic = [NSMutableDictionary dictionary];
        _downloadTaskDic = [NSMutableDictionary dictionary];
        
        // 单线程代理队列
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 1;
        
        // 后台下载标识
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"DownloadBackgroundSessionIdentifier"];
        // 允许蜂窝网络下载，默认为YES，这里开启，我们添加了一个变量去控制用户切换选择
        configuration.allowsCellularAccess = YES;
        
        // 创建NSURLSession，配置信息、代理、代理线程
        _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:queue];
        
        // 最大下载并发数变更通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadMaxConcurrentCountChange:) name:DownloadMaxConcurrentCountChangeNotification object:nil];
        // 是否允许蜂窝网络下载改变通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadAllowsCellularAccessChange:) name:DownloadAllowsCellularAccessChangeNotification object:nil];
        // 网路改变通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkingReachabilityDidChange:) name:NetworkingReachabilityDidChangeNotification object:nil];
    }
    
    return self;
}
// 加入准备下载任务
- (void)startDownloadTask:(TFY_DownloadModel *)model
{
    // 同一任务，1.0s内禁止重复调用
    if ([[NSDate date] timeIntervalSinceDate:[_downloadTaskDic valueForKey:model.url]] < 1.0f) return;
    [_downloadTaskDic setValue:[NSDate date] forKey:model.url];
    
    // 取出数据库中模型数据，如果不存在，添加到数据库中（注意：需要保证url唯一，若多条目同一url，则要另做处理）
    TFY_DownloadModel *downloadModel = [[TFY_DataBaseManager shareManager] getModelWithUrl:model.url];
    if (!downloadModel) {
        downloadModel = model;
        [[TFY_DataBaseManager shareManager] insertModel:downloadModel];
    }
    
    // 更新状态为等待下载
    downloadModel.state = DownloadStateWaiting;
    [[TFY_DataBaseManager shareManager] updateWithModel:downloadModel option:DBUpdateOptionState | DBUpdateOptionLastStateTime];
    
    // 下载（给定一个等待时间，保证currentCount更新）
    [NSThread sleepForTimeInterval:0.1f];
    if (_currentCount < _maxConcurrentCount && [self networkingAllowsDownloadTask]) [self downloadwithModel:downloadModel];
}

#pragma mark - HWDownloadMaxConcurrentCountChangeNotification
- (void)downloadMaxConcurrentCountChange:(NSNotification *)notification
{
    _maxConcurrentCount = [notification.object integerValue];
    
    if (_currentCount < _maxConcurrentCount) {
        // 当前下载数小于并发数，开启等待下载任务
        [self startDownloadWaitingTask];
        
    }else if (_currentCount > _maxConcurrentCount) {
        // 变更正在下载任务为等待下载
        [self pauseDownloadingTaskWithAll:NO];
    }
}
// 停止正在下载任务为等待状态
- (void)pauseDownloadingTaskWithAll:(BOOL)all
{
    // 获取正在下载的数据
    NSArray *downloadingData = [[TFY_DataBaseManager shareManager] getAllDownloadingData];
    NSInteger count = all ? downloadingData.count : downloadingData.count - _maxConcurrentCount;
    for (NSInteger i = 0; i < count; i++) {
        // 取消任务
        TFY_DownloadModel *model = downloadingData[i];
        [self cancelTaskWithModel:model delete:NO];
        
        // 更新状态为等待
        model.state = DownloadStateWaiting;
        [[TFY_DataBaseManager shareManager] updateWithModel:model option:DBUpdateOptionState];
    }
}
// 取消任务
- (void)cancelTaskWithModel:(TFY_DownloadModel *)model delete:(BOOL)delete
{
    if (model.state == DownloadStateDownloading) {
        // 获取NSURLSessionDownloadTask
        NSURLSessionDownloadTask *downloadTask = [_dataTaskDic valueForKey:model.url];
        
        // 取消任务
        [downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            // 更新下载数据
            model.resumeData = resumeData;
            [[TFY_DataBaseManager shareManager] updateWithModel:model option:DBUpdateOptionResumeData];
            
            // 更新当前正在下载的个数
            if (self->_currentCount > 0) self->_currentCount--;
            
            // 开启等待下载任务
            [self startDownloadWaitingTask];
        }];
        
        // 移除字典存储的对象
        if (delete) {
            [_dataTaskDic removeObjectForKey:model.url];
            [_downloadTaskDic removeObjectForKey:model.url];
        }
    }
}

// 开启等待下载任务
- (void)startDownloadWaitingTask
{
    if (_currentCount < _maxConcurrentCount && [self networkingAllowsDownloadTask]) {
        // 获取下一条等待的数据
        TFY_DownloadModel *model = [[TFY_DataBaseManager shareManager] getWaitingModel];
        if (model) {
            // 下载
            [self downloadwithModel:model];
            
            // 递归，开启下一个等待任务
            [self startDownloadWaitingTask];
        }
    }
}
// 删除下载任务及本地缓存
- (void)deleteTaskAndCache:(TFY_DownloadModel *)model
{
    // 如果正在下载，取消任务
    [self cancelTaskWithModel:model delete:YES];
    
    // 删除本地缓存、数据库数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[NSFileManager defaultManager] removeItemAtPath:model.localPath error:nil];
        [[TFY_DataBaseManager shareManager] deleteModelWithUrl:model.url];
    });
}
// 开始下载
- (void)downloadwithModel:(TFY_DownloadModel *)model
{
    _currentCount++;
    
    // cancelByProducingResumeData:回调有延时，给定一个等待时间，重新获取模型，保证获取到resumeData
    [NSThread sleepForTimeInterval:0.3f];
    TFY_DownloadModel *downloadModel = [[TFY_DataBaseManager shareManager] getModelWithUrl:model.url];
    
    // 更新状态为开始
    downloadModel.state = DownloadStateDownloading;
    [[TFY_DataBaseManager shareManager] updateWithModel:downloadModel option:DBUpdateOptionState];
    
    // 创建NSURLSessionDownloadTask
    NSURLSessionDownloadTask *downloadTask;
    if (downloadModel.resumeData) {
        CGFloat version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version >= 10.0 && version < 10.2) {
            downloadTask = [_session downloadTaskWithCorrectResumeData:downloadModel.resumeData];
        }else {
            downloadTask = [_session downloadTaskWithResumeData:downloadModel.resumeData];
        }
        
    }else {
        downloadTask = [_session downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:downloadModel.url]]];
    }
    
    // 添加描述标签
    downloadTask.taskDescription = downloadModel.url;
    
    // 更新存储的NSURLSessionDownloadTask对象
    [_dataTaskDic setValue:downloadTask forKey:downloadModel.url];
    
    // 启动（继续下载）
    [downloadTask resume];
}
// 暂停下载
- (void)pauseDownloadTask:(TFY_DownloadModel *)model
{
    // 取最新数据
    TFY_DownloadModel *downloadModel = [[TFY_DataBaseManager shareManager] getModelWithUrl:model.url];
    
    // 取消任务
    [self cancelTaskWithModel:downloadModel delete:NO];
    
    // 更新数据库状态为暂停
    downloadModel.state = DownloadStatePaused;
    [[TFY_DataBaseManager shareManager] updateWithModel:downloadModel option:DBUpdateOptionState];
}

#pragma mark - HWDownloadAllowsCellularAccessChangeNotification
- (void)downloadAllowsCellularAccessChange:(NSNotification *)notification
{
    _allowsCellularAccess = [notification.object boolValue];
    
    [self allowsCellularAccessOrNetworkingReachabilityDidChangeAction];
}

#pragma mark - HWNetworkingReachabilityDidChangeNotification
- (void)networkingReachabilityDidChange:(NSNotification *)notification
{
    [self allowsCellularAccessOrNetworkingReachabilityDidChangeAction];
}

// 是否允许蜂窝网络下载或网络状态变更事件
- (void)allowsCellularAccessOrNetworkingReachabilityDidChangeAction
{
    NSString  *reachable = [TFY_CommonUtils getNetconnType];//检测网络
    if ([reachable isEqualToString:@"network"]) {
        // 无网络，暂停正在下载任务
        [self pauseDownloadingTaskWithAll:YES];
        
    }else {
        if ([self networkingAllowsDownloadTask]) {
            // 开启等待任务
            [self startDownloadWaitingTask];
            
        }else {
            // 增加一个友善的提示，蜂窝网络情况下如果有正在下载，提示已暂停
            if ([[TFY_DataBaseManager shareManager] getLastDownloadingModel]) {
                [TFY_ProgressHUD showErrorWithStatus:@"当前为蜂窝网络，已停止下载任务，可在设置中开启" duration:4];
            }
            
            // 当前为蜂窝网络，不允许下载，暂停正在下载任务
            [self pauseDownloadingTaskWithAll:YES];
        }
    }
}

// 是否允许下载任务
- (BOOL)networkingAllowsDownloadTask{
    
    NSString  *reachable = [TFY_CommonUtils getNetconnType];//检测网络
    // 无网络 或 （当前为蜂窝网络，且不允许蜂窝网络下载）
    if (![reachable isEqualToString:@"Wifi"]) {
        return NO;
    }
    return YES;
}

- (void)dealloc{
    
    [_session invalidateAndCancel];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - NSURLSessionDownloadDelegate
// 接收到服务器返回数据，会被调用多次
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    // 获取模型
    TFY_DownloadModel *model = [[TFY_DataBaseManager shareManager] getModelWithUrl:downloadTask.taskDescription];
    
    // 更新当前下载大小
    model.tmpFileSize = (NSUInteger)totalBytesWritten;
    model.totalFileSize = (NSUInteger)totalBytesExpectedToWrite;
    
    // 计算速度时间内下载文件的大小
    model.intervalFileSize += (NSUInteger)bytesWritten;
    
    // 获取上次计算时间与当前时间间隔
    NSInteger intervals = [self getIntervalsWithTimeStamp:model.lastSpeedTime];
    if (intervals >= 1) {
        // 计算速度
        model.speed = model.intervalFileSize / intervals;
        
        // 重置变量
        model.intervalFileSize = 0;
        model.lastSpeedTime = [self getTimeStampWithDate:[NSDate date]];
    }
    
    // 计算进度
    model.progress = 1.0 * model.tmpFileSize / model.totalFileSize;
    
    // 更新数据库中数据
    [[TFY_DataBaseManager shareManager] updateWithModel:model option:DBUpdateOptionProgressData];
    
    // 进度通知
    [[NSNotificationCenter defaultCenter] postNotificationName:DownloadProgressNotification object:model];
}

// 下载完成
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    // 获取模型
    TFY_DownloadModel *model = [[TFY_DataBaseManager shareManager] getModelWithUrl:downloadTask.taskDescription];
    
    // 移动文件，原路径文件由系统自动删除
    NSError *error = nil;
    [[NSFileManager defaultManager] moveItemAtPath:[location path] toPath:model.localPath error:&error];
    if (error) NSLog(@"下载完成，移动文件发生错误：%@", error);
}

#pragma mark - NSURLSessionTaskDelegate
// 请求完成
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    // 调用cancel方法直接返回，在相应操作是直接进行处理
    if (error && [error.localizedDescription isEqualToString:@"cancelled"]) return;
    
    // 获取模型
    TFY_DownloadModel *model = [[TFY_DataBaseManager shareManager] getModelWithUrl:task.taskDescription];
    
    // 下载时进程杀死，重新启动时回调错误
    if (error && [error.userInfo objectForKey:NSURLErrorBackgroundTaskCancelledReasonKey]) {
        model.state = DownloadStateWaiting;
        model.resumeData = [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData];
        [[TFY_DataBaseManager shareManager] updateWithModel:model option:DBUpdateOptionState | DBUpdateOptionResumeData];
        return;
    }
    
    // 更新下载数据、任务状态
    if (error) {
        model.state = DownloadStateError;
        model.resumeData = [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData];
        [[TFY_DataBaseManager shareManager] updateWithModel:model option:DBUpdateOptionResumeData];
        
    }else {
        model.state = DownloadStateFinish;
    }
    
    // 更新数据
    if (_currentCount > 0) _currentCount--;
    [_dataTaskDic removeObjectForKey:model.url];
    [_downloadTaskDic removeObjectForKey:model.url];
    
    // 更新数据库状态
    [[TFY_DataBaseManager shareManager] updateWithModel:model option:DBUpdateOptionState];
    
    // 开启等待下载任务
    [self startDownloadWaitingTask];
    NSLog(@"\n    文件：%@，didCompleteWithError\n    本地路径：%@ \n    错误：%@ \n", model.fileName, model.localPath, error);
}

#pragma mark - NSURLSessionDelegate
// 应用处于后台，所有下载任务完成及NSURLSession协议调用之后调用
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (appDelegate.backgroundSessionCompletionHandler) {
            void (^completionHandler)(void) = appDelegate.backgroundSessionCompletionHandler;
            appDelegate.backgroundSessionCompletionHandler = nil;
            
            // 执行block，系统后台生成快照，释放阻止应用挂起的断言
            completionHandler();
        }
    });
}

// 时间戳转换为时间
- (NSDate *)getDateWithTimeStamp:(NSTimeInterval)timeStamp
{
    return [NSDate dateWithTimeIntervalSince1970:timeStamp * 0.001 * 0.001];
}

// 一个时间戳与当前时间的间隔（s）
- (NSInteger)getIntervalsWithTimeStamp:(NSTimeInterval)timeStamp
{
    return [[NSDate date] timeIntervalSinceDate:[self getDateWithTimeStamp:timeStamp]];
}
// 时间转换为时间戳，精确到微秒
- (NSTimeInterval)getTimeStampWithDate:(NSDate *)date
{
    return [[NSNumber numberWithDouble:[date timeIntervalSince1970] * 1000 * 1000] longLongValue];
}
@end
