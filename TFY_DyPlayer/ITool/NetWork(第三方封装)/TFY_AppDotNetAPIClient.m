//
//  TFY_AppDotNetAPIClient.m
//  daerOA
//
//  Created by 田风有 on 2017/3/30.
//  Copyright © 2017年 田风有. All rights reserved.
//

#import "TFY_AppDotNetAPIClient.h"

@implementation TFY_AppDotNetAPIClient

+ (instancetype)sharedClient {
    static TFY_AppDotNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[TFY_AppDotNetAPIClient alloc] init];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    
    return _sharedClient;
}

@end
