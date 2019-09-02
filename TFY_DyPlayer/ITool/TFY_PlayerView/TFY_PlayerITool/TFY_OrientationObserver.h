//
//  TFY_OrientationObserver.h
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/30.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 全屏模式
typedef NS_ENUM(NSUInteger, FullScreenMode) {
    FullScreenModeAutomatic,  // 自动确定全屏模式
    FullScreenModeLandscape,  // 横向全屏模式
    FullScreenModePortrait    // 人像全屏模特
};

/// 视图上的全屏模式
typedef NS_ENUM(NSUInteger, RotateType) {
    RotateTypeNormal,         // 正常
    RotateTypeCell,           // Cell
    RotateTypeCellOther       //单元格模式添加到其他视图
};

/**
 旋转支撑方向
 */
typedef NS_OPTIONS(NSUInteger, InterfaceOrientationMask) {
    InterfaceOrientationMaskPortrait = (1 << 0),
    InterfaceOrientationMaskLandscapeLeft = (1 << 1),
    InterfaceOrientationMaskLandscapeRight = (1 << 2),
    InterfaceOrientationMaskPortraitUpsideDown = (1 << 3),
    InterfaceOrientationMaskLandscape = (InterfaceOrientationMaskLandscapeLeft | InterfaceOrientationMaskLandscapeRight),
    InterfaceOrientationMaskAll = (InterfaceOrientationMaskPortrait | InterfaceOrientationMaskLandscapeLeft | InterfaceOrientationMaskLandscapeRight | InterfaceOrientationMaskPortraitUpsideDown),
    InterfaceOrientationMaskAllButUpsideDown = (InterfaceOrientationMaskPortrait | InterfaceOrientationMaskLandscapeLeft | InterfaceOrientationMaskLandscapeRight),
};


NS_ASSUME_NONNULL_BEGIN

@interface TFY_OrientationObserver : NSObject
/**
 *  添加对应的容器
 */
- (void)updateRotateView:(UIView *)rotateView containerView:(UIView *)containerView;
/**
 *  列表播放
 */
- (void)cellModelRotateView:(UIView *)rotateView rotateViewAtCell:(UIView *)cell playerViewTag:(NSInteger)playerViewTag;
/**
 * 单元格其他视图旋转
 */
- (void)cellOtherModelRotateView:(UIView *)rotateView containerView:(UIView *)containerView;
/**
 * 容器视图的全屏状态播放器。
 */
@property (nonatomic, strong) UIView *fullScreenContainerView;
/**
 * 一个小屏幕状态球员的容器视图。
 */
@property (nonatomic, weak) UIView *containerView;
/**
 * 如果全屏。
 */
@property (nonatomic, readonly, getter=isFullScreen) BOOL fullScreen;
/**
 * 使用设备方向，默认值为NO。
 */
@property (nonatomic, assign) BOOL forceDeviceOrientation;
/**
 *  屏幕锁定但需要开启视频转动 默认NO
 */
@property (nonatomic, assign) BOOL systemrotationbool;
/**
 * 锁定屏幕方向
 */
@property (nonatomic, getter=isLockedScreen) BOOL lockedScreen;
/**
 * 调用的块当播放器旋转时。
 */
@property (nonatomic, copy, nullable) void(^orientationWillChange)(TFY_OrientationObserver *observer, BOOL isFullScreen);
/**
 * 播放器旋转时调用的块。
 */
@property (nonatomic, copy, nullable) void(^orientationDidChanged)(TFY_OrientationObserver *observer, BOOL isFullScreen);
/**
 * 全屏模式，默认横向进入全屏
 */
@property (nonatomic) FullScreenMode fullScreenMode;
/**
 * 旋转持续时间，默认为0.30
 */
@property (nonatomic) float duration;
/**
 * 状态栏已隐藏。
 */
@property (nonatomic, getter=isStatusBarHidden) BOOL statusBarHidden;
/**
 * 播放器的当前方向。 默认为UIInterfaceOrientationPortrait。
 */
@property (nonatomic, readonly) UIInterfaceOrientation currentOrientation;
/**
 * 是否允许视频方向旋转。 默认为YES。
 */
@property (nonatomic) BOOL allowOrentitaionRotation;
/**
 *  支持Interface Orientation，默认为InterfaceOrientationMaskAllButUpsideDown
 */
@property (nonatomic, assign) InterfaceOrientationMask supportInterfaceOrientation;
/**
 * 添加设备方向观察器。
 */
- (void)addDeviceOrientationObserver;
/**
 * 删除设备方向观察器。
 */
- (void)removeDeviceOrientationObserver;
/**
 * 输入fullScreen，而FullScreenMode是FullScreenModeLandscape。
 */
- (void)enterLandscapeFullScreen:(UIInterfaceOrientation)orientation animated:(BOOL)animated;
/**
 *  在FullScreenMode为FullScreenModePortrait时输入fullScreen。
 */
- (void)enterPortraitFullScreen:(BOOL)fullScreen animated:(BOOL)animated;

- (void)exitFullScreenWithAnimated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
