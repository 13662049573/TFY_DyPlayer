//
//  AppDelegate.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/5.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBar_Controller.h"
#import "TFY_ServerConfig.h"
#import "TFY_WSMovieController.h"
#import "TFY_DownloadManager.h"
#import "TFY_PlayerVideoController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor  whiteColor];
    
    [TFY_ServerConfig setTFY_ConfigEnv:@"01"];
    
    // 一次性代码
//    [self projectOnceCode];
    
    // 初始化下载单例，若之前程序杀死时有正在下的任务，会自动恢复下载
//    [TFY_DownloadManager shareManager];
    
    BOOL versionCache = [TFY_CommonUtils version_CFBundleShortVersionString];
    if (!versionCache) {
        TabBar_Controller *tabbar=[[TabBar_Controller alloc] init];
        self.window.rootViewController = tabbar;
    }
    else{
        TFY_WSMovieController *vc = [TFY_WSMovieController new];
        vc.videoUrl = [[NSBundle mainBundle]pathForResource:@"qidong"ofType:@"mp4"];
        self.window.rootViewController = vc;
    }
    [self.window makeKeyAndVisible];
    
    return YES;
}

// 应用处于后台，所有下载任务完成调用
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler{
    
    _backgroundSessionCompletionHandler = completionHandler;
}

// 一次性代码
- (void)projectOnceCode
{
    NSString  *reachable = [TFY_CommonUtils getNetconnType];//检测网络
    // 网络改变通知
    [[NSNotificationCenter defaultCenter] postNotificationName:NetworkingReachabilityDidChangeNotification object:reachable];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *onceKey = @"ProjectOnceKey";
    if (![defaults boolForKey:onceKey]) {
        // 初始化下载最大并发数为1，不允许蜂窝网络下载
        [defaults setInteger:1 forKey:DownloadMaxConcurrentCountKey];
        [defaults setBool:NO forKey:DownloadAllowsCellularAccessKey];
        [defaults setBool:YES forKey:onceKey];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Killbackground" object:nil];
    
}

// 在这里写支持的旋转方向，为了防止横屏方向，应用启动时候界面变为横屏模式
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if(self.enablePortrait)
    {
        if (self.lockedScreen) {
            return UIInterfaceOrientationMaskLandscape;
        }
        return UIInterfaceOrientationMaskLandscape | UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskPortrait;
}

@end
