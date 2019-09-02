//
//  TFY_DownloadManager.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/25.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFY_DownloadModel.h"

NS_ASSUME_NONNULL_BEGIN

@class TFY_DownloadModel;

@interface TFY_DownloadManager : NSObject

// 初始化下载单例，若之前程序杀死时有正在下的任务，会自动恢复下载
+ (instancetype)shareManager;

// 开始下载
- (void)startDownloadTask:(TFY_DownloadModel *)model;

// 暂停下载
- (void)pauseDownloadTask:(TFY_DownloadModel *)model;

// 删除下载任务及本地缓存
- (void)deleteTaskAndCache:(TFY_DownloadModel *)model;

@end

NS_ASSUME_NONNULL_END
