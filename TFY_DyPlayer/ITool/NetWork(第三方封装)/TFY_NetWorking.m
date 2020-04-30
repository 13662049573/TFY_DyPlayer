//
//  TFY_NetWorking.m
//  daerOA
//
//  Created by 田风有 on 2017/3/30.
//  Copyright © 2017年 田风有. All rights reserved.
//
#import <AFNetworkActivityIndicatorManager.h>
#import "TFY_NetWorking.h"
#import "TFY_AppDotNetAPIClient.h"
#import "TFY_ServerConfig.h"
/**
 *  基础URL
 */
static NSString *privateNetworkBaseUrl = nil;
/**
 *  是否开启接口打印信息
 */
static BOOL isEnableInterfaceDebug = YES;
/**
 *  是否开启自动转换URL里的中文
 */
static BOOL shouldAutoEncode = NO;
/**
 *  设置请求头，默认为空
 */
static NSDictionary *httpHeaders = nil;
/**
 *  设置的返回数据类型
 */
static TFY_ResponseType responseType = TFY_ResponseTypeData;
/**
 *  设置的请求数据类型
 */
static TFY_RequestType  requestType  = TFY_RequestTypePlainText;
/**
 *  保存所有网络请求的task
 */
static NSMutableArray *requestTasks;
/**
 *  GET请求设置不缓存，Post请求不缓存
 */
static BOOL cacheGet  = NO;
static BOOL cachePost = NO;
/**
 *  是否开启取消请求
 */
static BOOL shouldCallbackOnCancelRequest = YES;
/**
 *  请求的超时时间
 */
static NSTimeInterval timeout = 15.0f;
/**
 *  是否从从本地提取数据
 */
static BOOL shoulObtainLocalWhenUnconnected = NO;
/**
 *  基础url是否更改，默认为yes
 */
static BOOL isBaseURLChanged = YES;
/**
 *  请求管理者
 */
static TFY_AppDotNetAPIClient *sharedManager = nil;


@implementation TFY_NetWorking

+ (void)cacheGetRequest:(BOOL)isCacheGet shoulCachePost:(BOOL)shouldCachePost {
    cacheGet = isCacheGet;
    cachePost = shouldCachePost;
}

+ (void)updateBaseUrl:(NSString *)baseUrl {
    if ([baseUrl isEqualToString:privateNetworkBaseUrl] && baseUrl && baseUrl.length) {
        isBaseURLChanged = YES;
    } else {
        isBaseURLChanged = NO;
    }
    privateNetworkBaseUrl = baseUrl;
}

+ (NSString *)baseUrl {
    return privateNetworkBaseUrl;
}

+ (void)setTimeout:(NSTimeInterval)timeout {
    timeout = timeout;
}

+ (void)obtainDataFromLocalWhenNetworkUnconnected:(BOOL)shouldObtain {
    shoulObtainLocalWhenUnconnected = shouldObtain;
}

+ (void)enableInterfaceDebug:(BOOL)isDebug {
    isEnableInterfaceDebug = isDebug;
}

+ (BOOL)isDebug {
    return isEnableInterfaceDebug;
}

static inline NSString *cachePath() {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/TFY_NetworkingCaches"];
}

+ (void)clearCaches {
    NSString *directoryPath = cachePath();
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:directoryPath error:&error];
        
        if (error) {
            NSLog(@"TFY_Networking clear caches error: %@", error);
        } else {
            NSLog(@"TFY_Networking clear caches ok");
        }
    }
}

+ (unsigned long long)totalCacheSize {
    NSString *directoryPath = cachePath();
    BOOL isDir = NO;
    unsigned long long total = 0;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDir]) {
        if (isDir) {
            NSError *error = nil;
            NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:&error];
            
            if (error == nil) {
                for (NSString *subpath in array) {
                    NSString *path = [directoryPath stringByAppendingPathComponent:subpath];
                    NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
                    if (!error) {
                        total += [dict[NSFileSize] unsignedIntegerValue];
                    }
                }
            }
        }
    }
    
    return total;
}

+ (NSMutableArray *)allTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (requestTasks == nil) {
            requestTasks = @[].mutableCopy;
        }
    });
    
    return requestTasks;
}

+ (void)cancelAllRequest {
    @synchronized(self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(TFY_URLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[TFY_URLSessionTask class]]) {
                [task cancel];
            }
        }];
        
        [[self allTasks] removeAllObjects];
    };
}

+ (void)cancelRequestWithURL:(NSString *)url {
    if (url == nil) {
        return;
    }
    @synchronized(self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(TFY_URLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[TFY_URLSessionTask class]]
                && [task.currentRequest.URL.absoluteString hasSuffix:url]) {
                [task cancel];
                [[self allTasks] removeObject:task];
                return;
            }
        }];
    };
}

+ (void)configRequestType:(TFY_RequestType)requestType responseType:(TFY_ResponseType)responseType shouldAutoEncodeUrl:(BOOL)shouldAutoEncode callbackOnCancelRequest:(BOOL)shouldCallbackOnCancelRequest {
    requestType = requestType;
    responseType = responseType;
    shouldAutoEncode = shouldAutoEncode;
    shouldCallbackOnCancelRequest = shouldCallbackOnCancelRequest;
}

+ (BOOL)shouldEncode {
    return shouldAutoEncode;
}

+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders {
    httpHeaders=httpHeaders;
}

// 无进度回调 无提示框
+ (TFY_URLSessionTask *)getWithUrl:(NSString *)url refreshCache:(BOOL)refreshCache success:(TFY_ResponseSuccess)success fail:(TFY_ResponseFail)fail{
    return [self tfy_requestWithUrl:url refreshCache:refreshCache isShowHUD:NO showHUD:nil httpMedth:1 params:nil progress:nil success:success fail:fail];
}

// 无进度回调 有提示框
+ (TFY_URLSessionTask *)getWithUrl:(NSString *)url refreshCache:(BOOL)refreshCache showHUD:(NSString *)statusText success:(TFY_ResponseSuccess)success fail:(TFY_ResponseFail)fail{
    
    return [self tfy_requestWithUrl:url refreshCache:refreshCache isShowHUD:YES showHUD:statusText httpMedth:1 params:nil progress:nil success:success fail:fail];
    
}
// 无进度回调 无提示框
+ (TFY_URLSessionTask *)getWithUrl:(NSString *)url refreshCache:(BOOL)refreshCache params:(NSDictionary *)params success:(TFY_ResponseSuccess)success fail:(TFY_ResponseFail)fail{
    
    return [self tfy_requestWithUrl:url refreshCache:refreshCache isShowHUD:NO showHUD:nil httpMedth:1 params:params progress:nil success:success fail:fail];
    
}
// 无进度回调 有提示框
+ (TFY_URLSessionTask *)getWithUrl:(NSString *)url refreshCache:(BOOL)refreshCache showHUD:(NSString *)statusText params:(NSDictionary *)params success:(TFY_ResponseSuccess)success fail:(TFY_ResponseFail)fail{
    
    return [self tfy_requestWithUrl:url refreshCache:refreshCache isShowHUD:YES showHUD:statusText httpMedth:1 params:params progress:nil success:success fail:fail];
    
}
// 有进度回调 无提示框
+ (TFY_URLSessionTask *)getWithUrl:(NSString *)url refreshCache:(BOOL)refreshCache params:(NSDictionary *)params progress:(GetProgress)progress success:(TFY_ResponseSuccess)success fail:(TFY_ResponseFail)fail {
    
    return [self tfy_requestWithUrl:url refreshCache:refreshCache isShowHUD:NO showHUD:nil httpMedth:1 params:params progress:progress success:success fail:fail];
    
}
// 有进度回调 有提示框
+ (TFY_URLSessionTask *)getWithUrl:(NSString *)url refreshCache:(BOOL)refreshCache showHUD:(NSString *)statusText params:(NSDictionary *)params progress:(GetProgress)progress success:(TFY_ResponseSuccess)success fail:(TFY_ResponseFail)fail{
    
    return [self tfy_requestWithUrl:url refreshCache:refreshCache isShowHUD:YES showHUD:statusText httpMedth:1 params:params progress:progress success:success fail:fail];
    
}
/**
 *  无进度回调 无提示框
 */

+ (TFY_URLSessionTask *)postWithUrl:(NSString *)url refreshCache:(BOOL)refreshCache params:(NSDictionary *)params success:(TFY_ResponseSuccess)success fail:(TFY_ResponseFail)fail{
    
    return [self tfy_requestWithUrl:url refreshCache:refreshCache isShowHUD:NO showHUD:nil httpMedth:2 params:params progress:nil success:success fail:fail];
}

/**
 *  无进度回调 有提示框
 *
 */
+ (TFY_URLSessionTask *)postWithUrl:(NSString *)url refreshCache:(BOOL)refreshCache showHUD:(NSString *)statusText params:(NSDictionary *)params success:(TFY_ResponseSuccess)success fail:(TFY_ResponseFail)fail{
    
    return [self tfy_requestWithUrl:url refreshCache:refreshCache isShowHUD:YES showHUD:statusText httpMedth:2 params:params progress:nil success:success fail:fail];
    
}
// 有进度回调 无提示框
+ (TFY_URLSessionTask *)postWithUrl:(NSString *)url refreshCache:(BOOL)refreshCache params:(NSDictionary *)params progress:(PostProgress)progress success:(TFY_ResponseSuccess)success fail:(TFY_ResponseFail)fail {
    
    return [self tfy_requestWithUrl:url refreshCache:refreshCache isShowHUD:NO showHUD:nil httpMedth:2 params:params progress:progress success:success fail:fail];
    
}
// 有进度回调 有提示框
+ (TFY_URLSessionTask *)postWithUrl:(NSString *)url refreshCache:(BOOL)refreshCache showHUD:(NSString *)statusText params:(NSDictionary *)params progress:(PostProgress)progress success:(TFY_ResponseSuccess)success fail:(TFY_ResponseFail)fail{
    
    return [self tfy_requestWithUrl:url refreshCache:refreshCache isShowHUD:YES showHUD:statusText httpMedth:2 params:params progress:progress success:success fail:fail];
    
}

+ (TFY_URLSessionTask *)tfy_requestWithUrl:(NSString *)url refreshCache:(BOOL)refreshCache isShowHUD:(BOOL)isShowHUD showHUD:(NSString *)statusText httpMedth:(NSUInteger)httpMethod params:(NSDictionary *)params progress:(TFY_DownloadProgress)progress success:(TFY_ResponseSuccess)success fail:(TFY_ResponseFail)fail {
    
    if ([[TFY_CommonUtils getNetconnType] isEqualToString:@"network"]) {
        
        [self NetworkStatesNone];
        return nil;
    }
    if (url==nil) {
        url = [TFY_ServerConfig getTFY_ServerAddr];
    }
    else{
        if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
            
        }else{
            NSString *serverAddress = [TFY_ServerConfig getTFY_ServerAddr];
            url = [serverAddress stringByAppendingString:url];
        }
    }

    if ([self shouldEncode]) {
        url = [self encodeUrl:url];
    }
    
    TFY_AppDotNetAPIClient *manager = [self manager];
    NSString *absolute = [self absoluteUrlWithPath:url];
    
    TFY_URLSessionTask *session = nil;
    // 显示提示框
    if (isShowHUD) {
        [TFY_NetWorking showHUD:statusText];
    }
    if (httpMethod == 1) {
        if (cacheGet) {
            if (shoulObtainLocalWhenUnconnected) {
                if ([[TFY_CommonUtils getNetconnType] isEqualToString:@"network"]) {
                    id response = [TFY_NetWorking cahceResponseWithURL:absolute parameters:params];
                    
                    if (response) {
                        if (success) {
                            [self successResponse:response callback:success];
                            
                            if ([self isDebug]) {
                                [self logWithSuccessResponse:response url:absolute params:params];
                            }
                        }
                        return nil;
                    }
                }
            }
            if (!refreshCache) {
                id response = [TFY_NetWorking cahceResponseWithURL:absolute parameters:params];
                
                if (response) {
                    if (success) {
                        [self successResponse:response callback:success];
                        
                        if ([self isDebug]) {
                            [self logWithSuccessResponse:response url:absolute params:params];
                        }
                    }
                    return nil;
                }
            }
        }
        
        session = [manager GET:url parameters:params headers:httpHeaders progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            // 移除提示框
            if (isShowHUD) {
                [TFY_NetWorking dismissSuccessHUD];
            }
            
            [[self allTasks] removeObject:task];
            
            [self successResponse:responseObject callback:success];
            // 获取并保存cookie
            [self getAndSaveCookie:task andUrl:url];
            
            if (cacheGet) {
                [self cacheResponseObject:responseObject request:task.currentRequest parameters:params];
            }
            
            if ([self isDebug]) {
                [self logWithSuccessResponse:responseObject url:absolute params:params];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 移除提示框
            if (isShowHUD) {
                [TFY_NetWorking dismissErrorHUD];
            }
            [[self allTasks] removeObject:task];
            
            // 删除cookie
            [self deleteCookieWithLoginOut];
            
            if ([error code] < 0 && cacheGet) {// 获取缓存
                id response = [TFY_NetWorking cahceResponseWithURL:absolute parameters:params];
                if (response) {
                    if (success) {
                        [self successResponse:response callback:success];
                        
                        if ([self isDebug]) {
                            [self logWithSuccessResponse:response url:absolute params:params];
                        }
                    }
                } else {
                    [self handleCallbackWithError:error fail:fail];
                    
                    if ([self isDebug]) {
                        [self logWithFailError:error url:absolute params:params];
                    }
                }
            } else {
                [self handleCallbackWithError:error fail:fail];
                
                if ([self isDebug]) {
                    [self logWithFailError:error url:absolute params:params];
                }
            }
        }];
    }
    else if (httpMethod == 2) {
        if (cachePost ) {// 获取缓存
            if (shoulObtainLocalWhenUnconnected) {
                if ([[TFY_CommonUtils getNetconnType] isEqualToString:@"network"]) {
                    id response = [TFY_NetWorking cahceResponseWithURL:absolute parameters:params];
                    if (response) {
                        if (success) {
                            [self successResponse:response callback:success];
                            
                            if ([self isDebug]) {
                                [self logWithSuccessResponse:response url:absolute params:params];
                            }
                        }
                        return nil;
                    }
                }
            }
            if (!refreshCache) {
                id response = [TFY_NetWorking cahceResponseWithURL:absolute parameters:params];
                if (response) {
                    if (success) {
                        [self successResponse:response callback:success];
                        
                        if ([self isDebug]) {
                            [self logWithSuccessResponse:response url:absolute params:params];
                        }
                    }
                    return nil;
                }
            }
        }
        
        
        session = [manager POST:url parameters:params headers:httpHeaders progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            // 移除提示框
            if (isShowHUD) {
                [TFY_NetWorking dismissSuccessHUD];
            }
            
            [[self allTasks] removeObject:task];
            
            [self successResponse:responseObject callback:success];
            // 获取并保存cookie
            [self getAndSaveCookie:task andUrl:url];
            
            if (cachePost) {
                [self cacheResponseObject:responseObject request:task.currentRequest  parameters:params];
            }
            
            if ([self isDebug]) {
                [self logWithSuccessResponse:responseObject url:absolute params:params];
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 移除提示框
            if (isShowHUD) {
                [TFY_NetWorking dismissErrorHUD];
            }
            [[self allTasks] removeObject:task];
            // 删除cookie
            [self deleteCookieWithLoginOut];
            
            if ([error code] < 0 && cachePost) {// 获取缓存
                id response = [TFY_NetWorking cahceResponseWithURL:absolute parameters:params];
                
                if (response) {
                    if (success) {
                        [self successResponse:response callback:success];
                        
                        if ([self isDebug]) {
                            [self logWithSuccessResponse:response url:absolute params:params];
                        }
                    }
                } else {
                    [self handleCallbackWithError:error fail:fail];
                    
                    if ([self isDebug]) {
                        [self logWithFailError:error url:absolute params:params];
                    }
                }
            } else {
                [self handleCallbackWithError:error fail:fail];
                
                if ([self isDebug]) {
                    [self logWithFailError:error url:absolute params:params];
                }
            }
        }];
    }
    
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

+ (TFY_URLSessionTask *)uploadFileWithUrl:(NSString *)url uploadingFile:(NSString *)uploadingFile progress:(TFY_UploadProgress)progress success:(TFY_ResponseSuccess)success fail:(TFY_ResponseFail)fail {
    
    if ([NSURL URLWithString:uploadingFile] == nil) {
        
        return nil;
    }
    
    NSURL *uploadURL = nil;
    if ([self baseUrl] == nil) {
        uploadURL = [NSURL URLWithString:url];
    } else {
        uploadURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], url]];
    }
    
    if (uploadURL == nil) {
        
        return nil;
    }
    
    TFY_AppDotNetAPIClient *manager = [self manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:uploadURL];
    TFY_URLSessionTask *session = nil;
    
    [manager uploadTaskWithRequest:request fromFile:[NSURL URLWithString:uploadingFile] progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [[self allTasks] removeObject:session];
        
        [self successResponse:responseObject callback:success];
        
        if (error) {
            [self handleCallbackWithError:error fail:fail];
            
            if ([self isDebug]) {
                [self logWithFailError:error url:response.URL.absoluteString params:nil];
            }
        } else {
            if ([self isDebug]) {
                [self logWithSuccessResponse:responseObject url:response.URL.absoluteString params:nil];
            }
        }
    }];
    
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

+ (TFY_URLSessionTask *)uploadWithImage:(UIImage *)image url:(NSString *)url filename:(NSString *)filename name:(NSString *)name mimeType:(NSString *)mimeType parameters:(NSDictionary *)parameters progress:(TFY_UploadProgress)progress success:(TFY_ResponseSuccess)success fail:(TFY_ResponseFail)fail {
    
    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            
            return nil;
        }
    } else {
        if ([NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], url]] == nil) {
            
            return nil;
        }
    }
    
    if ([self shouldEncode]) {
        url = [self encodeUrl:url];
    }
    
    NSString *absolute = [self absoluteUrlWithPath:url];
    
    TFY_AppDotNetAPIClient *manager = [self manager];
    TFY_URLSessionTask *session = [manager POST:url parameters:parameters headers:httpHeaders constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        
        NSString *imageFileName = filename;
        if (filename == nil || ![filename isKindOfClass:[NSString class]] || filename.length == 0) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            imageFileName = [NSString stringWithFormat:@"%@.png", str];
        }
        
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:name fileName:imageFileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[self allTasks] removeObject:task];
        [self successResponse:responseObject callback:success];
        
        if ([self isDebug]) {
            [self logWithSuccessResponse:responseObject url:absolute params:parameters];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self allTasks] removeObject:task];
        
        [self handleCallbackWithError:error fail:fail];
        
        if ([self isDebug]) {
            [self logWithFailError:error url:absolute params:nil];
        }
    }];
    
    
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

+ (TFY_URLSessionTask *)downloadWithUrl:(NSString *)url saveToPath:(NSString *)saveToPath progress:(TFY_DownloadProgress)progressBlock success:(TFY_ResponseSuccess)success failure:(TFY_ResponseFail)failure {
    
    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            
            return nil;
        }
    } else {
        if ([NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], url]] == nil) {
            
            return nil;
        }
    }
    
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    TFY_AppDotNetAPIClient *manager = [self manager];
    
    TFY_URLSessionTask *session = nil;
    
    session = [manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) {
            progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return [NSURL fileURLWithPath:saveToPath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [[self allTasks] removeObject:session];
        
        if (error == nil) {
            if (success) {
                success(filePath.absoluteString);
            }
            
            if ([self isDebug]) {
                NSLog(@"Download success for url %@",
                      [self absoluteUrlWithPath:url]);
            }
        } else {
            [self handleCallbackWithError:error fail:failure];
            
            if ([self isDebug]) {
                NSLog(@"Download fail for url %@, reason : %@",
                      [self absoluteUrlWithPath:url],
                      [error description]);
            }
        }
    }];
    
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

#pragma mark - Private
+ (TFY_AppDotNetAPIClient *)manager {
    
    @synchronized (self) {
        
        if (sharedManager == nil || isBaseURLChanged) {
            // 开启转圈圈
            [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
            
            TFY_AppDotNetAPIClient *manager = nil;;
            if ([self baseUrl] != nil) {
                manager = [[TFY_AppDotNetAPIClient sharedClient] initWithBaseURL:[NSURL URLWithString:[self baseUrl]]];
            } else {
                manager = [TFY_AppDotNetAPIClient sharedClient];
            }
            
            switch (requestType) {
                case TFY_RequestTypeJSON: {
                    manager.requestSerializer = [AFJSONRequestSerializer serializer];
                    break;
                }
                case TFY_RequestTypePlainText: {
                    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                    break;
                }
                default: {
                    break;
                }
            }
            
            switch (responseType) {
                case TFY_ResponseTypeJSON: {
                    manager.responseSerializer = [AFJSONResponseSerializer serializer];
                    break;
                }
                case TFY_ResponseTypeXML: {
                    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
                    break;
                }
                case TFY_ResponseTypeData: {
                    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                    break;
                }
                default: {
                    break;
                }
            }
            
            manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
            
            
            for (NSString *key in httpHeaders.allKeys) {
                if (httpHeaders[key] != nil) {
                    [manager.requestSerializer setValue:httpHeaders[key] forHTTPHeaderField:key];
                }
            }
            
            //设置cookie
            [self setUpCoookie];
            
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",@"text/html",@"text/json",@"text/plain",@"text/javascript",@"text/xml",@"image/*"]];
            
            manager.requestSerializer.timeoutInterval = timeout;
            
            manager.operationQueue.maxConcurrentOperationCount = 3;
            sharedManager = manager;
        }
    }
    return sharedManager;
}


+ (void)logWithSuccessResponse:(id)response url:(NSString *)url params:(NSDictionary *)params {
    NSLog(@"\n");
    NSLog(@"\n成功获取数据, URL: %@\n 数据字典:%@\n 数据结果:%@\n\n",
          [self generateGETAbsoluteURL:url params:params],
          params,[[self tryToParseData:response] tfy_jsonString]);
    
    [self Response:response];
}

+ (void)logWithFailError:(NSError *)error url:(NSString *)url params:(id)params {
    NSString *format = @" params: ";
    if (params == nil || ![params isKindOfClass:[NSDictionary class]]) {
        format =nil;
        params = nil;
    }
    
    NSLog(@"\n");
    if ([error code] == NSURLErrorCancelled) {
        NSLog(@"\n请求被mannully取消, URL: %@ %@%@\n\n",
              [self generateGETAbsoluteURL:url params:params],
              format,
              params);
    } else {
        NSLog(@"\n请求错误, URL: %@ %@%@\n 错误信息:%@\n\n",
              [self generateGETAbsoluteURL:url params:params],
              format,
              params,
              [error localizedDescription]);
    }
}

+ (NSString *)generateGETAbsoluteURL:(NSString *)url params:(NSDictionary *)params {
    if (params == nil || ![params isKindOfClass:[NSDictionary class]] || [params count] == 0) {
        return url;
    }
    
    NSString *queries = @"";
    for (NSString *key in params) {
        id value = [params objectForKey:key];
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            continue;
        } else if ([value isKindOfClass:[NSArray class]]) {
            continue;
        } else if ([value isKindOfClass:[NSSet class]]) {
            continue;
        } else {
            queries = [NSString stringWithFormat:@"%@%@=%@&",
                       (queries.length == 0 ? @"&" : queries),
                       key,
                       value];
        }
    }
    
    if (queries.length > 1) {
        queries = [queries substringToIndex:queries.length - 1];
    }
    
    if (([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) && queries.length > 1) {
        if ([url rangeOfString:@"?"].location != NSNotFound
            || [url rangeOfString:@"#"].location != NSNotFound) {
            url = [NSString stringWithFormat:@"%@%@", url, queries];
        } else {
            queries = [queries substringFromIndex:1];
            url = [NSString stringWithFormat:@"%@?%@", url, queries];
        }
    }
    
    return url.length == 0 ? queries : url;
}


+ (NSString *)encodeUrl:(NSString *)url {
    return [self HT_URLEncode:url];
}
// 解析json数据
+ (id)tryToParseData:(id)json {
    if (!json || json == (id)kCFNull) return nil;
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {//1.isKindOfClass用来判断某个对象是否属于某个类，或者是属于某个派生类。2.isMemberOfClass用来判断某个对象是否为当前类的实例。
        dic = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    if (jsonData) {
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if (![dic isKindOfClass:[NSDictionary class]]) dic = nil;
    }
    return dic;
}

+ (void)successResponse:(id)responseData callback:(TFY_ResponseSuccess)success {
    if (success) {
        success([self tryToParseData:responseData]);
        [self successdata:[self tryToParseData:responseData]];
    }
}

+ (void)handleCallbackWithError:(NSError *)error fail:(TFY_ResponseFail)fail {
    if ([error code] == NSURLErrorCancelled) {
        if (shouldCallbackOnCancelRequest) {
            if (fail) {
                fail(error);
            }
        }
    } else {
        if (fail) {
            fail(error);
        }
    }
    [self errorfail:error];
}

#pragma makc---下面这个四种方法可以按照自己的接口数据和要求更改
//没有网络情况下做的事情
+(void)NetworkStatesNone{
    [self showHUD:@"请打开网络再试,谢谢!"];
    
}

//请求成功做一些额外数据处理
+(void)successdata:(NSDictionary *)dcit{
   
}
////请求失败，或者数据返回有误的时候处理额外事情
+(void)errorfail:(NSError *)error{
    if (error) {
        [self showHUD:@"获取数据失败,请稍后再试!"];
        
    }
}
//打印对应的字典数据
+(void)Response:(id)responseData{
    
}
#pragma makc---上面这个四种方法可以按照自己的接口数据和要求更改

+ (BOOL)WXisEmptyNSDictionary:(NSDictionary *)dictionary {
    
    if (dictionary == nil || [dictionary isKindOfClass:[NSNull class]] || ![dictionary isKindOfClass:[NSDictionary class]] || dictionary.allKeys == 0) {
        return YES;
    }
    
    return NO;
    
}

+ (NSString *)HT_URLEncode:(NSString *)url {
    if ([url respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]) {
        
        static NSString * const kAFCharacterHTeneralDelimitersToEncode = @":#[]@";
        static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
        
        NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
        [allowedCharacterSet removeCharactersInString:[kAFCharacterHTeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
        static NSUInteger const batchSize = 50;
        
        NSUInteger index = 0;
        NSMutableString *escaped = @"".mutableCopy;
        
        while (index < url.length) {
            NSUInteger length = MIN(url.length - index, batchSize);
            NSRange range = NSMakeRange(index, length);
            range = [url rangeOfComposedCharacterSequencesForRange:range];
            NSString *substring = [url substringWithRange:range];
            NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
            [escaped appendString:encoded];
            
            index += range.length;
        }
        return escaped;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *encoded = (__bridge_transfer NSString *)
        CFURLCreateStringByAddingPercentEscapes(
                                                kCFAllocatorDefault,
                                                (__bridge CFStringRef)url,
                                                NULL,
                                                CFSTR("!#$&'()*+,/:;=?@[]"),
                                                cfEncoding);
        return encoded;
#pragma clang diagnostic pop
    }
}

+ (id)cahceResponseWithURL:(NSString *)url parameters:params {
    id cacheData = nil;
    
    if (url) {
        
        NSString *directoryPath = cachePath();
        NSString *absoluteURL = [self generateGETAbsoluteURL:url params:params];
        NSString *key = [absoluteURL md5String];
        NSString *path = [directoryPath stringByAppendingPathComponent:key];
        
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
        if (data) {
            cacheData = data;
            NSLog(@"Read data from cache for url: %@\n", url);
        }
    }
    
    return cacheData;
}

+ (void)cacheResponseObject:(id)responseObject request:(NSURLRequest *)request parameters:params {
    if (request && responseObject && ![responseObject isKindOfClass:[NSNull class]]) {
        NSString *directoryPath = cachePath();
        
        NSError *error = nil;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
            if (error) {
                NSLog(@"create cache dir error: %@\n", error);
                return;
            }
        }
        
        NSString *absoluteURL = [self generateGETAbsoluteURL:request.URL.absoluteString params:params];
        NSString *key = [absoluteURL md5String];
        NSString *path = [directoryPath stringByAppendingPathComponent:key];
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        NSData *data = nil;
        if ([dict isKindOfClass:[NSData class]]) {
            data = responseObject;
        } else {
            data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
        }
        
        if (data && error == nil) {
            BOOL isOk = [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
            if (isOk) {
                NSLog(@"cache file ok for request: %@\n", absoluteURL);
            } else {
                NSLog(@"cache file error for request: %@\n", absoluteURL);
            }
        }
    }
}

+ (NSString *)absoluteUrlWithPath:(NSString *)path {
    if (path == nil || path.length == 0) {
        return @"";
    }
    
    if ([self baseUrl] == nil || [[self baseUrl] length] == 0) {
        return path;
    }
    
    NSString *absoluteUrl = path;
    
    if (![path hasPrefix:@"http://"] && ![path hasPrefix:@"https://"]) {
        if ([[self baseUrl] hasSuffix:@"/"]) {
            if ([path hasPrefix:@"/"]) {
                NSMutableString * mutablePath = [NSMutableString stringWithString:path];
                [mutablePath deleteCharactersInRange:NSMakeRange(0, 1)];
                absoluteUrl = [NSString stringWithFormat:@"%@%@",
                               [self baseUrl], mutablePath];
            }else {
                absoluteUrl = [NSString stringWithFormat:@"%@%@",[self baseUrl], path];
            }
        }else {
            if ([path hasPrefix:@"/"]) {
                absoluteUrl = [NSString stringWithFormat:@"%@%@",[self baseUrl], path];
            }else {
                absoluteUrl = [NSString stringWithFormat:@"%@/%@",
                               [self baseUrl], path];
            }
        }
    }
    
    
    return absoluteUrl;
}

#pragma mark - HUD

+ (void)showHUD:(NSString *)showMessge
{
    
    [TFY_ProgressHUD showSuccessWithStatus:showMessge];
}

+ (void)dismissSuccessHUD
{
    [TFY_ProgressHUD dismissStatus:@"数据获取成功"];
    
}
+ (void)dismissErrorHUD
{
     [TFY_ProgressHUD dismissStatus:@"数据获取失败"];
    
}
#pragma mark  - Cookie
// 获取并保存cookie
+ (void)getAndSaveCookie:(NSURLSessionDataTask *)task andUrl:(NSString *)url
{
    //获取cookie
    NSDictionary *headers = [(NSHTTPURLResponse *)task.response allHeaderFields];
    
    NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:headers forURL:[NSURL URLWithString:url]];
    
    if (cookies && cookies.count != 0) {
    
        NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
        //存储归档后的cookie
        [self saveValueInUD:cookiesData forKey:@"UserCookie"];
        
    }
}
//保存数据
+(void)saveValueInUD:(id)value forKey:(NSString *)key{
    if(!value){
        return;
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:value forKey:key];
    [ud synchronize];
}

// 删除cookie
+ (void)deleteCookieWithLoginOut
{
    NSData *cookiesData = [NSData data];
    [self saveValueInUD:cookiesData forKey:@"UserCookie"];
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    
    //删除cookie
    for (NSHTTPCookie *tempCookie in cookies) {
        [cookieStorage deleteCookie:tempCookie];
    }
    
}
// 重新设置cookie
+ (void)setUpCoookie{
    //取出保存的cookie
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //对取出的cookie进行反归档处理
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:@"UserCookie"]];
    
    if (cookies && cookies.count != 0) {
        //设置cookie
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (id cookie in cookies) {
            [cookieStorage setCookie:(NSHTTPCookie *)cookie];
        }
    }else{
        
    }
    
}

@end
