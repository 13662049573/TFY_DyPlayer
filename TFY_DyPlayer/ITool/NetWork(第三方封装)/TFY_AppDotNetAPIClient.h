//
//  TFY_AppDotNetAPIClient.h
//  daerOA
//
//  Created by 田风有 on 2017/3/30.
//  Copyright © 2017年 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TFY_AppDotNetAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
