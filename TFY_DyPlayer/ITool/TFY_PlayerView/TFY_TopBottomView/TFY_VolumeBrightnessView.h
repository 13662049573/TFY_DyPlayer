//
//  TFY_VolumeBrightnessView.h
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/7/1.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VolumeBrightnessType) {
    VolumeBrightnessTypeVolume,       // 声音
    VolumeBrightnessTypeumeBrightness // 亮度
};

NS_ASSUME_NONNULL_BEGIN

@interface TFY_VolumeBrightnessView : UIView
/**
 *  赋值
 */
- (void)updateProgress:(CGFloat)progress withVolumeBrightnessType:(VolumeBrightnessType)volumeBrightnessType;
/**
 *  添加系统音量view
 */
- (void)addSystemVolumeView;
/**
 *  移除系统音量view
 */
- (void)removeSystemVolumeView;

@end

NS_ASSUME_NONNULL_END
