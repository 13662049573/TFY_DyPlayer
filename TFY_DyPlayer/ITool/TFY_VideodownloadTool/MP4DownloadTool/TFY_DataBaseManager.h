//
//  TFY_DataBaseManager.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/25.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFY_DownloadModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, DBUpdateOption) {
    DBUpdateOptionState         = 1 << 0,  // 更新状态
    DBUpdateOptionLastStateTime = 1 << 1,  // 更新状态最后改变的时间
    DBUpdateOptionResumeData    = 1 << 2,  // 更新下载的数据
    DBUpdateOptionProgressData  = 1 << 3,  // 更新进度数据（包含tmpFileSize、totalFileSize、progress、intervalFileSize、lastSpeedTime）
    DBUpdateOptionAllParam      = 1 << 4   // 更新全部数据
};

@interface TFY_DataBaseManager : NSObject
// 获取单例
+ (instancetype)shareManager;

// 插入数据
- (void)insertModel:(TFY_DownloadModel *)model;

// 获取数据
- (TFY_DownloadModel *)getModelWithUrl:(NSString *)url;    // 根据url获取数据
- (TFY_DownloadModel *)getWaitingModel;                    // 获取第一条等待的数据
- (TFY_DownloadModel *)getLastDownloadingModel;            // 获取最后一条正在下载的数据
- (NSArray<TFY_DownloadModel *> *)getAllCacheData;         // 获取所有数据
- (NSArray<TFY_DownloadModel *> *)getAllDownloadingData;   // 根据lastStateTime倒叙获取所有正在下载的数据
- (NSArray<TFY_DownloadModel *> *)getAllDownloadedData;    // 获取所有下载完成的数据
- (NSArray<TFY_DownloadModel *> *)getAllUnDownloadedData;  // 获取所有未下载完成的数据（包含正在下载、等待、暂停、错误）
- (NSArray<TFY_DownloadModel *> *)getAllWaitingData;       // 获取所有等待下载的数据

// 更新数据
- (void)updateWithModel:(TFY_DownloadModel *)model option:(DBUpdateOption)option;

// 删除数据
- (void)deleteModelWithUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
