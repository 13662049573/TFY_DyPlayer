//
//  TFY_PlayerMediaPlayback.h
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/30.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TFY_PlayerBaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PlayerPlaybackState) {
    PlayerPlayStateUnknown,
    PlayerPlayStatePlaying,
    PlayerPlayStatePaused,
    PlayerPlayStatePlayFailed,
    PlayerPlayStatePlayStopped
};

typedef NS_OPTIONS(NSUInteger, PlayerLoadState) {
    PlayerLoadStateUnknown        = 0,
    PlayerLoadStatePrepare        = 1 << 0,
    PlayerLoadStatePlayable       = 1 << 1,
    PlayerLoadStatePlaythroughOK  = 1 << 2, // 播放将自动开始。
    PlayerLoadStateStalled        = 1 << 3, // 如果启动，播放将在此状态下自动暂停。
};

typedef NS_ENUM(NSInteger, PlayerScalingMode) {
    PlayerScalingModeNone,       // 没有缩放。
    PlayerScalingModeAspectFit,  // 均匀刻度，直到一个尺寸适合。
    PlayerScalingModeAspectFill, // 均匀缩放直到电影填满可见边界。一个维度可能包含剪辑内容。
    PlayerScalingModeFill        // 规模不均匀。两个渲染维度都将与可见边界完全匹配。
};

@protocol TFY_PlayerMediaPlayback <NSObject>

@required
/**
 * 该视图必须继承`TFY_PlayerBaseView`，此视图处理一些手势冲突。
 */
@property (nonatomic) TFY_PlayerBaseView *view;

@optional
///播放器音量。
///仅影响播放器实例的音量而不影响设备。
///您可以根据需要更改设备音量或播放器音量，更改播放器音量，您可以使用`ZFPlayerMediaPlayback`协议。
@property (nonatomic) float volume;

///播放静音
///表示播放器的音频输出是否静音。仅影响播放器实例的音频静音，而不影响设备的音频静音。
///您可以根据需要更改设备音量或播放器静音，将播放器静音更改为可以使用`TFY_PlayerMediaPlayback`协议。
@property (nonatomic, getter=isMuted) BOOL muted;
/**
 *  播放速度，0.5 ... 2
 */
@property (nonatomic) float rate;
/**
 * 播放当前的游戏时间。
 */
@property (nonatomic, readonly) NSTimeInterval currentTime;
/**
 *  播放总时间。
 */
@property (nonatomic, readonly) NSTimeInterval totalTime;
/**
 * 播放器缓冲时间。
 */
@property (nonatomic, readonly) NSTimeInterval bufferTime;
/**
 * 播放寻求时间。
 */
@property (nonatomic) NSTimeInterval seekTime;
/**
 *  播放玩状态，玩或不玩。
 */
@property (nonatomic, readonly) BOOL isPlaying;
/**
 * 确定内容如何缩放以适合视图。默认为PlayerScalingModeNone。
 */
@property (nonatomic) PlayerScalingMode scalingMode;

/**
 * 检查视频准备是否完整。
 * discussion是PreparedToPlay处理逻辑
 * 如果isPreparedToPlay为TRUE，则可以调用[TFY_PlayerMediaPlayback play] API开始播放;
 * 如果isPreparedToPlay为FALSE，直接调用[TFY_PlayerMediaPlayback play]，在播放内部自动调用[TFY_PlayerMediaPlayback prepareToPlay] API。
 * 如果准备播放，则返回YES。
 */
@property (nonatomic, readonly) BOOL isPreparedToPlay;
/**
 *  播放器应该是自动播放器，默认为YES。
 */
@property (nonatomic) BOOL shouldAutoPlay;
/**
 *  播放资产网址。
 */
@property (nonatomic, copy) NSString *assetURL;
/**
 *  视频大小。
 */
@property (nonatomic, readonly) CGSize presentationSize;
/**
 *  播放状态。
 */
@property (nonatomic, readonly) PlayerPlaybackState playState;
/**
 * 播放加载状态。
 */
@property (nonatomic, readonly) PlayerLoadState loadState;

/// ------------------------------------
///如果未指定controlView，则可以调用以下块。
///如果指定controlView，则不能在外部调用以下块，仅用于`TFY_PlayerController`调用。
/// ------------------------------------
/**
 *  当播放准备玩时调用该块。
 */
@property (nonatomic, copy, nullable) void(^playerPrepareToPlay)(id<TFY_PlayerMediaPlayback> asset, NSString *assetURL);
/**
 *  当播放准备好玩时，会调用该块。
 */
@property (nonatomic, copy, nullable) void(^playerReadyToPlay)(id<TFY_PlayerMediaPlayback> asset, NSString *assetURL);
/**
 *  当播放进行改变时调用的块。
 */
@property (nonatomic, copy, nullable) void(^playerPlayTimeChanged)(id<TFY_PlayerMediaPlayback> asset, NSTimeInterval currentTime, NSTimeInterval duration);
/**
 *  当播放缓冲区改变时调用的块。
 */
@property (nonatomic, copy, nullable) void(^playerBufferTimeChanged)(id<TFY_PlayerMediaPlayback> asset, NSTimeInterval bufferTime);
/**
 *  当播放器播放状态改变时调用该块。
 */
@property (nonatomic, copy, nullable) void(^playerPlayStateChanged)(id<TFY_PlayerMediaPlayback> asset, PlayerPlaybackState playState);
/**
 *  当播放加载状态改变时调用的块。
 */
@property (nonatomic, copy, nullable) void(^playerLoadStateChanged)(id<TFY_PlayerMediaPlayback> asset, PlayerLoadState loadState);

/**
 * 播放器播放失败时调用的块。
 */
@property (nonatomic, copy, nullable) void(^playerPlayFailed)(id<TFY_PlayerMediaPlayback> asset, id error);
/**
 *  播放器播放结束时调用的块。
 */
@property (nonatomic, copy, nullable) void(^playerDidToEnd)(id<TFY_PlayerMediaPlayback> asset);
/**
 *  视频大小更改时调用的块。
 */
@property (nonatomic, copy, nullable) void(^presentationSizeChanged)(id<TFY_PlayerMediaPlayback> asset, CGSize size);

///------------------------------------
/// end
///------------------------------------
/**
 *  准备当前队列以进行回放，中断任何活动（不可混合）音频会话。
 */
- (void)prepareToPlay;
/**
 *  重新加载播放器。
 */
- (void)reloadPlayer;
/**
 *  播放播放
 */
- (void)play;
/**
 *  暂停播放。
 */
- (void)pause;
/**
 *  重播播放。
 */
- (void)replay;
/**
 * 停止播放。
 */
- (void)stop;
/**
 *  视频分解
 */
- (void)splitVideofps:(float)fps progressImageBlock:(void (NS_NOESCAPE ^)(CGFloat progress))progressImageBlock splitCompleteBlock:(void (NS_NOESCAPE ^)(BOOL success, NSMutableArray *splitimgs))splitCompleteBlock;
/**
 *  使用此方法可以搜索当前播放器的指定时间，并在搜索操作完成时收到通知。
 */
- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^ __nullable)(BOOL finished))completionHandler;
/**
 *  当前时间的视频UIImage。
 */
- (UIImage *)thumbnailImageAtCurrentTime;
@end

NS_ASSUME_NONNULL_END
