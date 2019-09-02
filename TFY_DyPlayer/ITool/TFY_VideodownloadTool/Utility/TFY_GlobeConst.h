//
//  TFY_GlobeConst.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/25.
//  Copyright © 2019 田风有. All rights reserved.
//
#import <UIKit/UIKit.h>

/************************* 下载 *************************/
UIKIT_EXTERN NSString * const DownloadProgressNotification;                   // 进度回调通知
UIKIT_EXTERN NSString * const DownloadStateChangeNotification;                // 状态改变通知
UIKIT_EXTERN NSString * const DownloadMaxConcurrentCountKey;                  // 最大同时下载数量key
UIKIT_EXTERN NSString * const DownloadMaxConcurrentCountChangeNotification;   // 最大同时下载数量改变通知
UIKIT_EXTERN NSString * const DownloadAllowsCellularAccessKey;                // 是否允许蜂窝网络下载key
UIKIT_EXTERN NSString * const DownloadAllowsCellularAccessChangeNotification; // 是否允许蜂窝网络下载改变通知

/************************* 网络 *************************/
UIKIT_EXTERN NSString * const NetworkingReachabilityDidChangeNotification;    // 网络改变改变通知

typedef NS_ENUM(NSInteger, DownloadState) {
    DownloadStateDefault = 0,  // 默认
    DownloadStateDownloading,  // 正在下载
    DownloadStateWaiting,      // 等待
    DownloadStatePaused,       // 暂停
    DownloadStateFinish,       // 完成
    DownloadStateError,        // 错误
};
