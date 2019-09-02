//
//  TFY_DataBaseManager.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/25.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_DataBaseManager.h"

typedef NS_ENUM(NSInteger, DBGetDateOption) {
    DBGetDateOptionAllCacheData = 0,      // 所有缓存数据
    DBGetDateOptionAllDownloadingData,    // 所有正在下载的数据
    DBGetDateOptionAllDownloadedData,     // 所有下载完成的数据
    DBGetDateOptionAllUnDownloadedData,   // 所有未下载完成的数据
    DBGetDateOptionAllWaitingData,        // 所有等待下载的数据
    DBGetDateOptionModelWithUrl,          // 通过url获取单条数据
    DBGetDateOptionWaitingModel,          // 第一条等待的数据
    DBGetDateOptionLastDownloadingModel,  // 最后一条正在下载的数据
};

@implementation TFY_DataBaseManager

+ (instancetype)shareManager
{
    static TFY_DataBaseManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}
// 插入数据
- (void)insertModel:(TFY_DownloadModel *)model{
 
    [TFY_ModelSqlite insert:model];
}

// 根据url获取数据
- (TFY_DownloadModel *)getModelWithUrl:(NSString *)url{
    return [self getModelWithOption:DBGetDateOptionModelWithUrl url:url];
}
// 获取第一条等待的数据
- (TFY_DownloadModel *)getWaitingModel{
    return [self getModelWithOption:DBGetDateOptionWaitingModel url:nil];
}
// 获取最后一条正在下载的数据
- (TFY_DownloadModel *)getLastDownloadingModel{
    return [self getModelWithOption:DBGetDateOptionLastDownloadingModel url:nil];
}
 // 获取所有数据
- (NSArray<TFY_DownloadModel *> *)getAllCacheData{
    return [self getDateWithOption:DBGetDateOptionAllCacheData];
}
// 根据lastStateTime倒叙获取所有正在下载的数据
- (NSArray<TFY_DownloadModel *> *)getAllDownloadingData{
    return [self getDateWithOption:DBGetDateOptionAllDownloadingData];
}
// 获取所有下载完成的数据
- (NSArray<TFY_DownloadModel *> *)getAllDownloadedData{
    return [self getDateWithOption:DBGetDateOptionAllDownloadedData];
}
 // 获取所有未下载完成的数据（包含正在下载、等待、暂停、错误）
- (NSArray<TFY_DownloadModel *> *)getAllUnDownloadedData{
    return [self getDateWithOption:DBGetDateOptionAllUnDownloadedData];
}
// 获取所有等待下载的数据
- (NSArray<TFY_DownloadModel *> *)getAllWaitingData{
   return [self getDateWithOption:DBGetDateOptionAllWaitingData];
}

// 删除数据
- (void)deleteModelWithUrl:(NSString *)url{
    
    BOOL result =[TFY_ModelSqlite deletes:[TFY_DownloadModel class] where:[NSString stringWithFormat:@"url=%@",url]];
    if (!result) {
        [TFY_ProgressHUD showErrorWithStatus:@"删除失败!"];
    }
}

// 获取单条数据
- (TFY_DownloadModel *)getModelWithOption:(DBGetDateOption)option url:(NSString *)url
{
    NSArray *resultSet;
    switch (option) {
        case DBGetDateOptionModelWithUrl:
            resultSet = [TFY_ModelSqlite query:[TFY_DownloadModel class] where:[NSString stringWithFormat:@"url=%@",url]];
            break;
            
        case DBGetDateOptionWaitingModel:
            resultSet = [TFY_ModelSqlite query:[TFY_DownloadModel class] where:@"state=" order:@"by lastStateTime asc" limit:@"0,1"];
            break;
            
        case DBGetDateOptionLastDownloadingModel:
            resultSet = [TFY_ModelSqlite query:[TFY_DownloadModel class] where:@"state=" order:@"by lastStateTime desc" limit:@"0,1"];
            break;
            
        default:
            break;
    }
    return [[TFY_DownloadModel alloc] initWithModelSqliteSet:resultSet];
}

// 获取数据集合
- (NSArray<TFY_DownloadModel *> *)getDateWithOption:(DBGetDateOption)option
{
    NSArray *resultSet;
    switch (option) {
        case DBGetDateOptionAllCacheData:
            resultSet = [TFY_ModelSqlite query:[TFY_DownloadModel class]];
            break;
            
        case DBGetDateOptionAllDownloadingData:
            resultSet = [TFY_ModelSqlite query:[TFY_DownloadModel class] where:[NSString stringWithFormat:@"state=%@",[NSNumber numberWithInteger:DownloadStateDownloading]] order:@"by lastStateTime desc"];
        
            break;
            
        case DBGetDateOptionAllDownloadedData:
            resultSet = [TFY_ModelSqlite query:[TFY_DownloadModel class] where:[NSString stringWithFormat:@"state=%@",[NSNumber numberWithInteger:DownloadStateFinish]]];
            break;
            
        case DBGetDateOptionAllUnDownloadedData:
            resultSet = [TFY_ModelSqlite query:[TFY_DownloadModel class] where:[NSString stringWithFormat:@"state != %@",[NSNumber numberWithInteger:DownloadStateFinish]]];
            break;
            
        case DBGetDateOptionAllWaitingData:
            resultSet = [TFY_ModelSqlite query:[TFY_DownloadModel class] where:[NSString stringWithFormat:@"state=%@",[NSNumber numberWithInteger:DownloadStateWaiting]]];
            break;
            
        default:
            break;
    }
    
    NSMutableArray *tmpArr = [NSMutableArray array];
    [tmpArr addObject:[[TFY_DownloadModel alloc] initWithModelSqliteSet:resultSet]];
    resultSet = tmpArr;
    return resultSet;
}

// 更新数据
- (void)updateWithModel:(TFY_DownloadModel *)model option:(DBUpdateOption)option{
    
    if (option & DBUpdateOptionState) {
        [self postStateChangeNotificationWithmodel:model];
        [TFY_ModelSqlite update:model where:[NSString stringWithFormat:@"state=%ld,url=%@",(long)model.state,model.url]];
    }
    if (option & DBUpdateOptionLastStateTime) {
        [TFY_ModelSqlite update:model where:[NSString stringWithFormat:@"lastStateTime=%ld,url=%@",(long)[self getTimeStampWithDate:[NSDate date]],model.url]];
    }
    if (option & DBUpdateOptionResumeData) {
        [TFY_ModelSqlite update:model where:[NSString stringWithFormat:@"resumeData=%@,url=%@",model.resumeData,model.url]];
    }
    if (option & DBUpdateOptionProgressData) {
        [TFY_ModelSqlite update:model where:[NSString stringWithFormat:@"tmpFileSize=%@,totalFileSize=%@,progress=%@,lastSpeedTime=%@,intervalFileSize=%@,url=%@",[NSNumber numberWithInteger:model.tmpFileSize],[NSNumber numberWithFloat:model.totalFileSize],[NSNumber numberWithFloat:model.progress],[NSNumber numberWithDouble:model.lastSpeedTime],[NSNumber numberWithInteger:model.intervalFileSize],model.url]];
    }
    if (option & DBUpdateOptionAllParam) {
        [self postStateChangeNotificationWithmodel:model];
        [TFY_ModelSqlite update:model where:[NSString stringWithFormat:@"resumeData=%@,totalFileSize=%@,tmpFileSize=%@,progress=%@,state=%@,lastSpeedTime=%@,intervalFileSize=%@,lastStateTime=%@,url=%@",model.resumeData, [NSNumber numberWithInteger:model.totalFileSize], [NSNumber numberWithInteger:model.tmpFileSize], [NSNumber numberWithFloat:model.progress], [NSNumber numberWithInteger:model.state], [NSNumber numberWithDouble:model.lastSpeedTime], [NSNumber numberWithInteger:model.intervalFileSize],[NSNumber numberWithInteger:[self getTimeStampWithDate:[NSDate date]]], model.url]];
    }
    
}

// 时间转换为时间戳，精确到微秒
-(NSInteger)getTimeStampWithDate:(NSDate *)date
{
    return [[NSNumber numberWithDouble:[date timeIntervalSince1970] * 1000 * 1000] integerValue];
}
// 状态变更通知
- (void)postStateChangeNotificationWithmodel:(TFY_DownloadModel *)model
{
    // 原状态
    __block NSInteger oldState;
    NSArray *arr= [TFY_ModelSqlite query:[TFY_DownloadModel class] where:[NSString stringWithFormat:@"url=%@",model.url]];
    [arr enumerateObjectsUsingBlock:^(TFY_DownloadModel  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        oldState = obj.state;
        
    }];
    if (oldState != model.state && oldState != DownloadStateFinish) {
        // 状态变更通知
        [[NSNotificationCenter defaultCenter] postNotificationName:DownloadStateChangeNotification object:model];
    }
}

@end
