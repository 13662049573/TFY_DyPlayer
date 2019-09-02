//
//  TFY_PlayerController.h
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/30.
//  Copyright © 2019 田风有. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "TFY_PlayerMediaPlayback.h"
#import "TFY_OrientationObserver.h"
#import "TFY_PlayerMediaControl.h"
#import "TFY_PlayerGestureControl.h"
#import "TFY_PlayerNotification.h"
#import "TFY_FloatView.h"
#import "UIScrollView+TFY_Player.h"
#import "TFY_PlayerVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_PlayerController : NSObject

/**
 *  你需要适合的控制器，或者默认图片View
 */
@property (nonatomic, strong) UIView *imageView;
/**
 *  播放速度，0.5 ... 2
 */
@property (nonatomic) float rate;
/**
 *  currentPlayerManager必须符合`TFY_PlayerMediaPlayback`协议。
 */
@property (nonatomic, strong) id<TFY_PlayerMediaPlayback> currentPlayerManager;

/**
 * 自定义controlView必须符合`TFY_PlayerMediaControl`协议。
 */
@property (nonatomic, strong) UIView<TFY_PlayerMediaControl> *controlView;

/**
 *  通知管理器类
 */
@property (nonatomic, strong, readonly) TFY_PlayerNotification *notification;

/**
 * 容器视图类型。
 */
@property (nonatomic, assign, readonly) PlayerContainerType containerType;

/**
 *  播放的小容器视图。
 */
@property (nonatomic, strong, readonly) TFY_FloatView *smallFloatView;

/**
 *  是否显示小窗口。
 */
@property (nonatomic, assign, readonly) BOOL isSmallFloatViewShow;
/**
 * 是否开启多视频连续播放，默认 NO
 */
@property (nonatomic , assign)BOOL continuouslybool;
/*!
 *  playerWithPlayerManager：containerView：
 * 创建一个播放单个视听项目的TFY_PlayerController。
 * containerView要查看视频帧必须设置contrainerView。
 * TFY_PlayerController的一个实例。
 */
+ (instancetype)playerWithPlayerManagercontainerView:(UIView *)containerView;

/*!
 *  initWithPlayerManager：containerView：
 * 创建一个播放单个视听项目的TFY_PlayerController。
 * containerView要查看视频帧必须设置contrainerView。
 * TFY_PlayerController的一个实例。
 */
- (instancetype)initWithPlayerManagercontainerView:(UIView *)containerView;

/*!
 * playerWithScrollView：playerManager：containerViewTag：
 * 创建一个播放单个视听项目的TFY_PlayerController。在`UITableView`或`UICollectionView`中使用。
 * scrollView是`tableView`或`collectionView`。
 * containerViewTag在scrollView上查看视频必须设置contrainerViewTag。
 * TFY_PlayerController的一个实例。
 */
+ (instancetype)playerWithScrollView:(UIScrollView *)scrollView containerViewTag:(NSInteger)containerViewTag;

/*!
 * initWithScrollView：playerManager：containerViewTag：
 * 创建一个播放单个视听项目的TFY_PlayerController。在`UITableView`或`UICollectionView`中使用。
 * scrollView是`tableView`或`collectionView`。
 * containerViewTag在scrollView上查看视频必须设置contrainerViewTag。
 * TFY_PlayerController的一个实例。
 */
- (instancetype)initWithScrollView:(UIScrollView *)scrollView containerViewTag:(NSInteger)containerViewTag;

/*!
 * playerWithScrollView：playerManager：containerView：
 * 创建一个播放单个视听项目的TFY_PlayerController。在`UIScrollView`中使用。
 * containerView在scrollView上查看视频。
 * TFY_PlayerController的一个实例。
 */
+ (instancetype)playerWithScrollView:(UIScrollView *)scrollView containerView:(UIView *)containerView;

/*!
 * initWithScrollView：playerManager：containerView：
 * 创建一个播放单个视听项目的ZFPlayerController。在`UIScrollView`中使用。
 * containerView在scrollView上查看视频。
 * TFY_PlayerController的一个实例。
 */
- (instancetype)initWithScrollView:(UIScrollView *)scrollView containerView:(UIView *)containerView;

@end

@interface TFY_PlayerController (PlayerTimeControl)

/**
 *  播放当前的游戏时间。
 */
@property (nonatomic, readonly) NSTimeInterval currentTime;

/**
 *  播放总时间。
 */
@property (nonatomic, readonly) NSTimeInterval totalTime;

/**
 *  播放器缓冲时间。
 */
@property (nonatomic, readonly) NSTimeInterval bufferTime;
/**
 *  播放进度，0 ... 1
 */
@property (nonatomic, readonly) float progress;

/**
 *  播放器bufferProgress，0 ... 1
 */
@property (nonatomic, readonly) float bufferProgress;

/**
 * 使用此方法可以搜索当前播放器的指定时间，并在搜索操作完成时收到通知。
 * 时间寻求时间。
 * completionHandler完成处理程序。
 */
- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^ __nullable)(BOOL finished))completionHandler;
/**
 *  视频分解
 */
- (void)splitVideofps:(float)fps progressImageBlock:(void (NS_NOESCAPE ^)(CGFloat progress))progressImageBlock splitCompleteBlock:(void (NS_NOESCAPE ^)(BOOL success, NSMutableArray *splitimgs))splitCompleteBlock;
@end

@interface TFY_PlayerController (PlayerPlaybackControl)

/// 0 ... 1.0
///仅影响设备实例的音量而不影响播放器。
///您可以根据需要更改设备音量或播放器音量，更改可以符合`TFY_PlayerMediaPlayback`协议的播放器音量。
@property (nonatomic) float volume;

///设备静音
///仅影响设备实例的音频静音，而不影响播放器的音频静音。
///您可以根据需要更改设备静音或播放器静音，更改播放器静音，您可以符合`TFY_PlayerMediaPlayback`协议。
@property (nonatomic, getter=isMuted) BOOL muted;

/**
 *  0 ... 1.0，其中1.0是最大亮度。仅由主屏幕支持。
 */
@property (nonatomic) float brightness;

/**
 * 播放资产网址。
 */
@property (nonatomic , strong)TFY_PlayerVideoModel *assetUrlModel;

///如果tableView或collectionView只有一个部分，请使用`assetURLs`。
///如果tableView或collectionView有更多部分，请使用`sectionAssetURLs`。
///设置此项你可以使用`playTheNext``playThePrevious``playTheIndex：`方法。
@property (nonatomic, copy, nullable) NSArray <TFY_PlayerVideoModel *>*assetUrlMododels;
/**
 *  当前播放的索引，仅限于一维数组。
 */
@property (nonatomic) NSInteger currentPlayIndex;

/**
 *  是`assetURLs`中的最后一个资产URL。
 */
@property (nonatomic, readonly) BOOL isLastAssetURL;

/**
 * 是`assetURLs`中的第一个资产URL。
 */
@property (nonatomic, readonly) BOOL isFirstAssetURL;

///如果是，播放器将被调用暂停方法当收到`UIApplicationWillResignActiveNotification`通知时。
///默认为YES。
@property (nonatomic) BOOL pauseWhenAppResignActive;

///播放器播放时，某些事件会暂停，而不是用户点击暂停。
///例如，当播放正在玩时，应用程序进入后台或推送到另一个viewController
@property (nonatomic, getter=isPauseByEvent) BOOL pauseByEvent;

/**
 *  当前的播放控制器消失了，而不是dealloc
 */
@property (nonatomic, getter=isViewControllerDisappear) BOOL viewControllerDisappear;

///您可以自定义AVAudioSession，
///默认为NO。
@property (nonatomic, assign) BOOL customAudioSession;

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
 * 当播放缓冲区改变时调用的块。
 */
@property (nonatomic, copy, nullable) void(^playerBufferTimeChanged)(id<TFY_PlayerMediaPlayback> asset, NSTimeInterval bufferTime);

/**
 * 当播放器播放状态改变时调用该块。
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
 * 播放器播放结束时调用的块。
 */
@property (nonatomic, copy, nullable) void(^playerDidToEnd)(id<TFY_PlayerMediaPlayback> asset);

/**
 * 视频大小更改时调用的块。
 */
@property (nonatomic, copy, nullable) void(^presentationSizeChanged)(id<TFY_PlayerMediaPlayback> asset, CGSize size);
/**
 * 开启连续播放时 需要获取的model数据回调
 */
@property (nonatomic, copy, nullable) void(^playvideocontinuously)(TFY_PlayerController *player, TFY_PlayerVideoModel *model);
/**
 * 播放下一个url，而`assetURLs`不是NULL。
 */
- (void)playTheNext;

/**
 * 播放上一个url，而`assetURLs`不是NULL。
 */
- (void)playThePrevious;

/**
 * 播放url的索引，而`assetURLs`不是NULL。
 * index播放索引。
 */
- (void)playTheIndex:(NSInteger)index;

/**
 * 播放器停止并从超级视图中删除playerView，删除其他通知。
 */
- (void)stop;

/*!
 * replaceCurrentPlayerManager：
 * 用指定的播放项目替换播放当前的playeranager。
 * manager必须符合`TFY_PlayerMediaPlayback`协议
 * 将成为播放当前playeranager的playerManager。
 */
- (void)replaceCurrentPlayerManager:(id<TFY_PlayerMediaPlayback>)manager;

/**
 * 将视频添加到单元格。
 */
- (void)addPlayerViewToCell;

/**
 * 将视频添加到容器视图。
 */
- (void)addPlayerViewToContainerView:(UIView *)containerView;

/**
 * 添加到keyWindow。
 */
- (void)addPlayerViewToKeyWindow;

/**
 * 停止当前播放的视频并删除playerView。
 */
- (void)stopCurrentPlayingView;

/**
 * 停止当前正在播放的视频。
 */
- (void)stopCurrentPlayingCell;
/**
 * 获取播放视频所有数据
 */
-(NSDictionary *)ModelDict;
@end

@interface TFY_PlayerController (PlayerOrientationRotation)

@property (nonatomic, readonly) TFY_OrientationObserver *orientationObserver;

///是否支持自动屏幕旋转。
/// iOS8.1~iOS8.3的值为YES，其他iOS版本的值为NO。
///此属性用于UIViewController`eduAutorotate`方法的返回值。
@property (nonatomic, readonly) BOOL shouldAutorotate;

///是否允许视频方向旋转。
///默认为YES。
@property (nonatomic) BOOL allowOrentitaionRotation;

///当FullScreenMode为FullScreenModeLandscape时，方向为LandscapeLeft或LandscapeRight，此值为YES。
///当FullScreenMode为FullScreenModePortrait时，播放器fullSceen此值为YES。
@property (nonatomic, readonly) BOOL isFullScreen;
/**
 *  屏幕锁定但需要开启视频转动 默认NO
 */
@property (nonatomic, assign) BOOL systemrotationbool;

/**
 * 当调用`stop`方法时，退出fullScreen模型，默认为YES。
 */
@property (nonatomic, assign) BOOL exitFullScreenWhenStop;

/**
 *  锁定屏幕方向。
 */
@property (nonatomic, getter=isLockedScreen) BOOL lockedScreen;

/**
 * 状态栏已隐藏。
 */
@property (nonatomic, getter=isStatusBarHidden) BOOL statusBarHidden;

/**
 *  使用设备方向，默认值为NO。
 */
@property (nonatomic, assign) BOOL forceDeviceOrientation;

///播放器的当前方向
///默认为UIInterfaceOrientationPortrait。
@property (nonatomic, readonly) UIInterfaceOrientation currentOrientation;
/**
 * 调用的块当播放旋转时。
 */
@property (nonatomic, copy, nullable) void(^orientationWillChange)(TFY_PlayerController *player, BOOL isFullScreen);

/**
 * 播放旋转时调用的块。
 */
@property (nonatomic, copy, nullable) void(^orientationDidChanged)(TFY_PlayerController *player, BOOL isFullScreen);

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
 * orientation UIInterfaceOrientation
 * 动画是动画的。
 */
- (void)enterLandscapeFullScreen:(UIInterfaceOrientation)orientation animated:(BOOL)animated;

/**
 * 在FullScreenMode为FullScreenModePortrait时输入fullScreen。
 * fullScreen是全屏的。
 * 动画是动画的。
 */
- (void)enterPortraitFullScreen:(BOOL)fullScreen animated:(BOOL)animated;

/**
 * 全屏模式由ZFFullScreenMode确定。
 * fullScreen是全屏的。
 * 动画是动画的。
 */
- (void)enterFullScreen:(BOOL)fullScreen animated:(BOOL)animated;

@end

@interface TFY_PlayerController (PlayerViewGesture)

/**
 *  TFY_PlayerGestureControl的一个实例。
 */
@property (nonatomic, readonly) TFY_PlayerGestureControl *gestureControl;

/**
 *  播放器不支持的手势类型。
 */
@property (nonatomic, assign) PlayerDisableGestureTypes disableGestureTypes;

/**
 *  平移手势移动方向，播放不支持。
 */
@property (nonatomic) PlayerDisablePanMovingDirection disablePanMovingDirection;

@end

@interface TFY_PlayerController (PlayerScrollView)

/**
 *  滚动视图是`tableView`或`collectionView`。
 */
@property (nonatomic, readonly, nullable) UIScrollView *scrollView;

/**
 *  scrollView播放器应该是自动播放器，默认为YES。
 */
@property (nonatomic) BOOL shouldAutoPlay;

/**
 * WWAN网络自动播放，当`shouldAutoPlay`为YES时，仅支持scrollView模式，默认为NO。
 */
@property (nonatomic, getter=isWWANAutoPlay) BOOL WWANAutoPlay;

/**
 * indexPath正在播放。
 */
@property (nonatomic, readonly, nullable) NSIndexPath *playingIndexPath;

/**
 * 播放器在scrollView中显示的视图标记。
 */
@property (nonatomic, readonly) NSInteger containerViewTag;

/**
 * 当单元格关闭屏幕时，当前播放单元格停止播放，默认为YES。
 */
@property (nonatomic) BOOL stopWhileNotVisible;

/**
 * 当前播放器滚动滑出屏幕百分比。
 * 当`stopWhileNotVisible`为YES时使用的属性，停止当前播放的播放器。
 * 当`stopWhileNotVisible`为NO时使用的属性，当前播放的播放器添加到小容器视图。
 * 范围是0.0~1.0，defalut是0.5。
 * 0.0是播放将消失。
 * 1.0是播放确实消失了。
 */
@property (nonatomic) CGFloat playerDisapperaPercent;

/**
 * 当前播放器滚动到屏幕百分比以播放视频。范围是0.0~1.0，默认值是0.0。 0.0是播放将出现。 1.0是播放确实出现的。
 */
@property (nonatomic) CGFloat playerApperaPercent;

/**
 * 如果tableView或collectionView有更多部分，请使用`sectionAssetURLs`。
 */
@property (nonatomic, copy, nullable) NSArray <NSArray <TFY_PlayerVideoModel *>*>*sectionAssetURLs;

/**
 * 当播放出现时调用该块。
 */
@property (nonatomic, copy, nullable) void(^tfy_playerAppearingInScrollView)(NSIndexPath *indexPath, CGFloat playerApperaPercent);

/**
 * 当播放消失时调用该块。
 */
@property (nonatomic, copy, nullable) void(^tfy_playerDisappearingInScrollView)(NSIndexPath *indexPath, CGFloat playerDisapperaPercent);

/**
 * 调用块当播放器出现时。
 */
@property (nonatomic, copy, nullable) void(^tfy_playerWillAppearInScrollView)(NSIndexPath *indexPath);

/**
 * 当播放出现时，调用该块。
 */
@property (nonatomic, copy, nullable) void(^tfy_playerDidAppearInScrollView)(NSIndexPath *indexPath);

/**
 * 调用的块当播放消失时。
 */
@property (nonatomic, copy, nullable) void(^tfy_playerWillDisappearInScrollView)(NSIndexPath *indexPath);

/**
 * 调用的块当播放消失时。
 */
@property (nonatomic, copy, nullable) void(^tfy_playerDidDisappearInScrollView)(NSIndexPath *indexPath);

/**
 * 播放url的indexPath，而`assetURLs`或`sectionAssetURLs`不是NULL。
 * indexPath播放url的indexPath。
 */
- (void)playTheIndexPath:(NSIndexPath *)indexPath;

/**
 * 播放url的indexPath，而`assetURLs`或`sectionAssetURLs`不是NULL。
 * indexPath播放url的indexPath
 * scrollToTop使用动画将当前单元格滚动到顶部。
 */
- (void)playTheIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop;

/**
 * 播放url的indexPath，而`assetURLs`或`sectionAssetURLs`不是NULL。
 * indexPath播放url的indexPath
 * assetURL播放器URL。
 * scrollToTop使用动画将当前单元格滚动到顶部。
 */
- (void)playTheIndexPath:(NSIndexPath *)indexPath assetURL:(NSString *)assetURL scrollToTop:(BOOL)scrollToTop;

/**
 * 播放url的indexPath，而`assetURLs`或`sectionAssetURLs`不是NULL。
 * indexPath播放url的indexPath
 * scrollToTop使用动画将当前单元格滚动到顶部。
 * completionHandler滚动完成回调。
 */
- (void)playTheIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop completionHandler:(void (^ __nullable)(void))completionHandler;

@end



@interface TFY_PlayerController (PlayerDeprecated)

/**
 * 将playerView添加到单元格。
 */
- (void)updateScrollViewPlayerToCell  __attribute__((deprecated("use `addPlayerViewToCell:` instead.")));

/**
 * 将playerView添加到containerView
 * containerView playerView containerView。
 */
- (void)updateNoramlPlayerWithContainerView:(UIView *)containerView __attribute__((deprecated("use `addPlayerViewToContainerView:` instead.")));

@end

NS_ASSUME_NONNULL_END
