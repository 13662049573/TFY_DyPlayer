//
//  TFY_PlayerControllerView.h
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/7/2.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFY_LandScapeControlView.h" //横屏控制层的View
#import "TFY_PortraitControlView.h" //竖屏控制层的View
#import "TFY_PlayerMediaControl.h" //协议
#import "TFY_fastView.h"  //快进快退View
#import "TFY_VolumeBrightnessView.h" //声音亮度控制
NS_ASSUME_NONNULL_BEGIN

@interface TFY_PlayerControllerView : UIView<TFY_PlayerMediaControl>
/**
 * 快进视图是否显示动画，默认NO.
 */
@property (nonatomic, assign) BOOL fastViewAnimated;
/**
 *  视频之外区域是否高斯模糊显示，默认YES.
 */
@property (nonatomic, assign) BOOL effectViewShow;
/**
 * 直接进入全屏模式，只支持全屏模式
 */
@property (nonatomic, assign) BOOL fullScreenOnly;
/**
 *  如果是暂停状态，seek完是否播放，默认YES
 */
@property (nonatomic, assign) BOOL seekToPlay;
/**
 *  返回按钮点击回调
 */
@property (nonatomic, copy) void(^backBtnClickCallback)(void);
/**
 *  控制层显示或者隐藏
 */
@property (nonatomic, readonly) BOOL controlViewAppeared;
/**
 *  控制层显示或者隐藏的回调
 */
@property (nonatomic, copy) void(^controlViewAppearedCallback)(BOOL appeared);
/**
 * 控制层自动隐藏的时间，默认2.5秒
 */
@property (nonatomic, assign) NSTimeInterval autoHiddenTimeInterval;
/**
 *  控制层显示、隐藏动画的时长，默认0.25秒
 */
@property (nonatomic, assign) NSTimeInterval autoFadeTimeInterval;
/**
 *  横向滑动控制播放进度时是否显示控制层,默认 YES.
 */
@property (nonatomic, assign) BOOL horizontalPanShowControlView;
/**
 * prepare时候是否显示控制层,默认 NO.
 */
@property (nonatomic, assign) BOOL prepareShowControlView;
/**
 *  prepare时候是否显示loading,默认 NO.
 */
@property (nonatomic, assign) BOOL prepareShowLoading;
/**
 *  是否自定义禁止pan手势，默认 NO.
 */
@property (nonatomic, assign) BOOL customDisablePanMovingDirection;
/**
 *  多视频播放总个数
 */
@property (nonatomic, assign) NSInteger videoCount;
/**
 *  当前播放的索引，仅限于一维数组。
 */
@property (nonatomic) NSInteger currentPlayIndex;
/**
 * 设置标题、封面、全屏模式
 * title 视频的标题
 * coverUrl 视频的封面，占位图默认是灰色的
 * fullScreenMode 全屏模式
 */
- (void)showTitle:(NSString *)title coverURLString:(NSString *)coverUrl fullScreenMode:(FullScreenMode)fullScreenMode;

/**
 * 设置标题、封面、默认占位图、全屏模式
 * title 视频的标题
 * coverUrl 视频的封面
 * placeholder 指定封面的placeholder
 * fullScreenMode 全屏模式
 */
- (void)showTitle:(NSString *)title coverURLString:(NSString *)coverUrl placeholderImage:(UIImage *)placeholder fullScreenMode:(FullScreenMode)fullScreenMode;

/**
 * 设置标题、UIImage封面、全屏模式
 * title 视频的标题
 * image 视频的封面UIImage
 * fullScreenMode 全屏模式
 */
- (void)showTitle:(NSString *)title coverImage:(UIImage *)image fullScreenMode:(FullScreenMode)fullScreenMode;

/**
 * 重置控制层
 */
- (void)resetControlView;

@end

NS_ASSUME_NONNULL_END
