//
//  TFY_PlayerMediaControl.h
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/30.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "TFY_PlayerMediaPlayback.h"
#import "TFY_OrientationObserver.h"
#import "TFY_ReachabilityManager.h"
#import "TFY_PlayerController.h"
#import "TFY_PlayerGestureControl.h"

@class TFY_PlayerController;

NS_ASSUME_NONNULL_BEGIN

@protocol TFY_PlayerMediaControl <NSObject>

@required
/// 当前的playerController
@property (nonatomic, weak) TFY_PlayerController *player;

@optional

#pragma mark - Playback state

/**
 *  当播放准备播放视频时。
 */
- (void)videoPlayer:(TFY_PlayerController *)videoPlayer prepareToPlay:(NSString *)assetURL;
/**
 *  当播放器播放状态改变时。
 */
- (void)videoPlayer:(TFY_PlayerController *)videoPlayer playStateChanged:(PlayerPlaybackState)state;
/**
 *  当播放加载状态改变时。
 */
- (void)videoPlayer:(TFY_PlayerController *)videoPlayer loadStateChanged:(PlayerLoadState)state;

#pragma mark - progress

/**
 * 播放改变时。
 * videoPlayer播放器
 * currentTime当前的播放时间。
 * totalTime视频总时间。
 */
- (void)videoPlayer:(TFY_PlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime;

/**
 * 缓冲进度改变时。
 */
- (void)videoPlayer:(TFY_PlayerController *)videoPlayer bufferTime:(NSTimeInterval)bufferTime;

/**
 * 当您拖动以更改视频进度时。
 */
- (void)videoPlayer:(TFY_PlayerController *)videoPlayer draggingTime:(NSTimeInterval)seekTime totalTime:(NSTimeInterval)totalTime;

/**
 * 播放结束时。
 */
- (void)videoPlayerPlayEnd:(TFY_PlayerController *)videoPlayer;

/**
 * 当比赛失败时。
 */
- (void)videoPlayerPlayFailed:(TFY_PlayerController *)videoPlayer error:(id)error;

#pragma mark - lock screen

/**
 * 设置`video Player.lock Screen`时。
 */
- (void)lockedVideoPlayer:(TFY_PlayerController *)videoPlayer lockedScreen:(BOOL)locked;

#pragma mark - Screen rotation

/**
 * 当fullScreen模式改变时。
 */
- (void)videoPlayer:(TFY_PlayerController *)videoPlayer orientationWillChange:(TFY_OrientationObserver *)observer;

/**
 * 全屏模式更改时。
 */
- (void)videoPlayer:(TFY_PlayerController *)videoPlayer orientationDidChanged:(TFY_OrientationObserver *)observer;

#pragma mark - The network changed

/**
 * 网络改变了
 */
- (void)videoPlayer:(TFY_PlayerController *)videoPlayer reachabilityChanged:(ReachabilityStatus)status;

#pragma mark - The video size changed

/**
 * 当视频大小发生变化时
 */
- (void)videoPlayer:(TFY_PlayerController *)videoPlayer presentationSizeChanged:(CGSize)size;

#pragma mark - Gesture

/**
 * 当手势条件
 */
- (BOOL)gestureTriggerCondition:(TFY_PlayerGestureControl *)gestureControl gestureType:(PlayerGestureType)gestureType gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer touch:(UITouch *)touch;

/**
 * 当手势单击时
 */
- (void)gestureSingleTapped:(TFY_PlayerGestureControl *)gestureControl;

/**
 * 当手势双击
 */
- (void)gestureDoubleTapped:(TFY_PlayerGestureControl *)gestureControl;

/**
 * 当手势开始panGesture时
 */
- (void)gestureBeganPan:(TFY_PlayerGestureControl *)gestureControl panDirection:(PanDirection)direction panLocation:(PanLocation)location;

/**
 * 当手势呻吟
 */
- (void)gestureChangedPan:(TFY_PlayerGestureControl *)gestureControl panDirection:(PanDirection)direction panLocation:(PanLocation)location withVelocity:(CGPoint)velocity;

/**
 * 当结束panGesture时
 */
- (void)gestureEndedPan:(TFY_PlayerGestureControl *)gestureControl panDirection:(PanDirection)direction panLocation:(PanLocation)location;

/**
 * 当pinchGesture发生变化时
 */
- (void)gesturePinched:(TFY_PlayerGestureControl *)gestureControl scale:(float)scale;

#pragma mark - scrollview

/**
 * 当播放器出现在scrollView中时。
 */
- (void)playerWillAppearInScrollView:(TFY_PlayerController *)videoPlayer;

/**
 * 当播放器出现在scrollView中时。
 */
- (void)playerDidAppearInScrollView:(TFY_PlayerController *)videoPlayer;

/**
 * 当播放器将在scrollView中消失。
 */
- (void)playerWillDisappearInScrollView:(TFY_PlayerController *)videoPlayer;

/**
 * 当播放器在scrollView中消失时。
 */
- (void)playerDidDisappearInScrollView:(TFY_PlayerController *)videoPlayer;

/**
 * 当播放器出现在scrollView中时。
 */
- (void)playerAppearingInScrollView:(TFY_PlayerController *)videoPlayer playerApperaPercent:(CGFloat)playerApperaPercent;

/**
 * 当播放在scrollView中消失时。
 */
- (void)playerDisappearingInScrollView:(TFY_PlayerController *)videoPlayer playerDisapperaPercent:(CGFloat)playerDisapperaPercent;

/**
 * 当小浮动视图显示时。
 */
- (void)videoPlayer:(TFY_PlayerController *)videoPlayer floatViewShow:(BOOL)show;

@end

NS_ASSUME_NONNULL_END

