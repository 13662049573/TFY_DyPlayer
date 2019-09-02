//
//  TFY_ServerConfig.m
//  daerOA
//
//  Created by 田风有 on 2017/3/30.
//  Copyright © 2017年 田风有. All rights reserved.
//

#import "TFY_ServerConfig.h"

static NSString *TFY_ConfigEnv;  //环境参数 00: 测试环境,01: 生产环境

@implementation TFY_ServerConfig

+(void)setTFY_ConfigEnv:(NSString *)value
{
    TFY_ConfigEnv = value;
}

+(NSString *)TFY_ConfigEnv
{
    return TFY_ConfigEnv;
}
//获取服务器地址
+ (NSString *)getTFY_ServerAddr{
    if ([TFY_ConfigEnv isEqualToString:@"00"]) {
        return HTURL_Test;
    }else{
        return HTURL;
    }
}
@end
