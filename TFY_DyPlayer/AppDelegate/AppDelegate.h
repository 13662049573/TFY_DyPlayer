//
//  AppDelegate.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/5.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, copy) void (^backgroundSessionCompletionHandler)(void);  // 后台所有下载任务完成回调

@property (nonatomic, assign)BOOL enablePortrait;

@property (nonatomic, assign)BOOL lockedScreen;
@end

