//
//  TFY_ServerConfig.h
//  daerOA
//
//  Created by 田风有 on 2017/3/30.
//  Copyright © 2017年 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFY_Const.h"

@interface TFY_ServerConfig : NSObject
// env: 环境参数 00: 测试环境 01: 生产环境
+ (void)setTFY_ConfigEnv:(NSString *)value;

// 返回环境参数 00: 测试环境 01: 生产环境
+ (NSString *)TFY_ConfigEnv;

// 获取服务器地址
+ (NSString *)getTFY_ServerAddr;

@end
