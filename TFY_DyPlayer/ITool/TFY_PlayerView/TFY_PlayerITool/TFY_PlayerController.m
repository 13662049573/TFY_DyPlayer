//
//  TFY_PlayerController.m
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/30.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_PlayerController.h"
#import <objc/runtime.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#import "TFY_PlayerBaseView.h"
#import "TFY_PlayerToolsHeader.h"
#import "TFY_AVPlayerManager.h"

#define PLAYER_WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface TFY_PlayerController ()

@property (nonatomic, strong) TFY_PlayerNotification *notification;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) UISlider *volumeViewSlider;
@property (nonatomic, assign) NSInteger containerViewTag;
@property (nonatomic, assign) PlayerContainerType containerType;
/// 播放的小容器视图。
@property (nonatomic, strong) TFY_FloatView *smallFloatView;
/// 是否显示小窗口。
@property (nonatomic, assign) BOOL isSmallFloatViewShow;
/// indexPath正在播放。
@property (nonatomic, nullable) NSIndexPath *playingIndexPath;
/**
 * 播放数据字典
 */
@property(nonatomic , strong)NSMutableDictionary *dictModel;
@end

@implementation TFY_PlayerController

- (instancetype)init {
    self = [super init];
    if (self) {
        PLAYER_WS(myself);
        [[TFY_ReachabilityManager sharedManager] startMonitoring];
        [[TFY_ReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(ReachabilityStatus status) {
           
            if ([myself.controlView respondsToSelector:@selector(videoPlayer:reachabilityChanged:)]) {
                [myself.controlView videoPlayer:myself reachabilityChanged:status];
            }
        }];
        
        self.continuouslybool = NO;
        [self configureVolume];
    }
    return self;
}
-(void)setRate:(float)rate{
    _rate = rate;
    self.currentPlayerManager.rate = _rate;
}
/// 获取系统卷
- (void)configureVolume {
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    self.volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            self.volumeViewSlider = (UISlider *)view;
            break;
        }
    }
}

- (void)dealloc {
    [self.currentPlayerManager stop];
}

+ (instancetype)playerWithPlayerManagercontainerView:(nonnull UIView *)containerView {
    TFY_PlayerController *player = [[self alloc] initWithPlayerManagercontainerView:containerView];
    return player;
}

+ (instancetype)playerWithScrollView:(UIScrollView *)scrollView containerViewTag:(NSInteger)containerViewTag {
    TFY_PlayerController *player = [[self alloc] initWithScrollView:scrollView containerViewTag:containerViewTag];
    return player;
}

+ (instancetype)playerWithScrollView:(UIScrollView *)scrollView containerView:(UIView *)containerView {
    TFY_PlayerController *player = [[self alloc] initWithScrollView:scrollView containerView:containerView];
    return player;
}

- (instancetype)initWithPlayerManagercontainerView:(nonnull UIView *)containerView {
    TFY_AVPlayerManager *manger = [TFY_AVPlayerManager new];
    TFY_PlayerController *player = [self init];
    player.imageView = containerView;
    player.currentPlayerManager = manger;
    player.containerType = PlayerContainerTypeView;
    return player;
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView containerViewTag:(NSInteger)containerViewTag {
    TFY_AVPlayerManager *manger = [TFY_AVPlayerManager new];
    TFY_PlayerController *player = [self init];
    player.scrollView = scrollView;
    player.containerViewTag = containerViewTag;
    player.currentPlayerManager = manger;
    player.containerType = PlayerContainerTypeCell;
    return player;
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView containerView:(UIView *)containerView {
    TFY_AVPlayerManager *manger = [TFY_AVPlayerManager new];
    TFY_PlayerController *player = [self init];
    player.scrollView = scrollView;
    player.imageView = containerView;
    player.currentPlayerManager = manger;
    player.containerType = PlayerContainerTypeView;
    return player;
}

- (void)playerManagerCallbcak {
    PLAYER_WS(myself);
    self.currentPlayerManager.playerPrepareToPlay = ^(id<TFY_PlayerMediaPlayback>  _Nonnull asset, NSString * _Nonnull assetURL) {
    
        myself.currentPlayerManager.view.hidden = NO;
        [myself.notification addNotification];
        [myself addDeviceOrientationObserver];
        if (myself.scrollView) {
            myself.scrollView.tfy_stopPlay = NO;
        }
        [myself layoutPlayerSubViews];
        if (myself.playerPrepareToPlay) myself.playerPrepareToPlay(asset,assetURL);
        if ([myself.controlView respondsToSelector:@selector(videoPlayer:prepareToPlay:)]) {
            [myself.controlView videoPlayer:myself prepareToPlay:assetURL];
        }
    };
    
    self.currentPlayerManager.playerReadyToPlay = ^(id<TFY_PlayerMediaPlayback>  _Nonnull asset, NSString * _Nonnull assetURL) {
        
        if (myself.playerReadyToPlay) myself.playerReadyToPlay(asset,assetURL);
        if (!myself.customAudioSession) {
            // 使用此类别的应用程序在手机的静音按钮打开时不会静音，但在手机静音时播放声音
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
        }
    };
    
    self.currentPlayerManager.playerPlayTimeChanged = ^(id<TFY_PlayerMediaPlayback>  _Nonnull asset, NSTimeInterval currentTime, NSTimeInterval duration) {
        
        if (myself.playerPlayTimeChanged) myself.playerPlayTimeChanged(asset,currentTime,duration);
        if ([myself.controlView respondsToSelector:@selector(videoPlayer:currentTime:totalTime:)]) {
            [myself.controlView videoPlayer:myself currentTime:currentTime totalTime:duration];
        }
    };
    
    self.currentPlayerManager.playerBufferTimeChanged = ^(id<TFY_PlayerMediaPlayback>  _Nonnull asset, NSTimeInterval bufferTime) {
        
        if ([myself.controlView respondsToSelector:@selector(videoPlayer:bufferTime:)]) {
            [myself.controlView videoPlayer:myself bufferTime:bufferTime];
        }
        if (myself.playerBufferTimeChanged) myself.playerBufferTimeChanged(asset,bufferTime);
    };
    
    self.currentPlayerManager.playerPlayStateChanged = ^(id  _Nonnull asset, PlayerPlaybackState playState) {
        
        if (myself.playerPlayStateChanged) myself.playerPlayStateChanged(asset, playState);
        if ([myself.controlView respondsToSelector:@selector(videoPlayer:playStateChanged:)]) {
            [myself.controlView videoPlayer:myself playStateChanged:playState];
        }
    };
    
    self.currentPlayerManager.playerLoadStateChanged = ^(id  _Nonnull asset, PlayerLoadState loadState) {
        
        if (myself.playerLoadStateChanged) myself.playerLoadStateChanged(asset, loadState);
        if ([myself.controlView respondsToSelector:@selector(videoPlayer:loadStateChanged:)]) {
            [myself.controlView videoPlayer:myself loadStateChanged:loadState];
        }
    };
    
    self.currentPlayerManager.playerDidToEnd = ^(id  _Nonnull asset) {
        
        if (myself.playerDidToEnd) myself.playerDidToEnd(asset);
        if ([myself.controlView respondsToSelector:@selector(videoPlayerPlayEnd:)]) {
            [myself.controlView videoPlayerPlayEnd:myself];
        }
        //这里开始连续播放视频t调用
        if (myself.continuouslybool) {
            [myself.currentPlayerManager replay];
            [myself playTheNext];
        }
    };
    
    self.currentPlayerManager.playerPlayFailed = ^(id<TFY_PlayerMediaPlayback>  _Nonnull asset, id  _Nonnull error) {
        
        if (myself.playerPlayFailed) myself.playerPlayFailed(asset, error);
        if ([myself.controlView respondsToSelector:@selector(videoPlayerPlayFailed:error:)]) {
            [myself.controlView videoPlayerPlayFailed:myself error:error];
        }
    };
    
    self.currentPlayerManager.presentationSizeChanged = ^(id<TFY_PlayerMediaPlayback>  _Nonnull asset, CGSize size){
        
        if (myself.orientationObserver.fullScreenMode == FullScreenModeAutomatic) {
            if (size.width > size.height) {
                myself.orientationObserver.fullScreenMode = FullScreenModeLandscape;
            } else {
                myself.orientationObserver.fullScreenMode = FullScreenModePortrait;
            }
        }
        if (myself.presentationSizeChanged) myself.presentationSizeChanged(asset, size);
        if ([myself.controlView respondsToSelector:@selector(videoPlayer:presentationSizeChanged:)]) {
            [myself.controlView videoPlayer:myself presentationSizeChanged:size];
        }
    };
}




- (void)layoutPlayerSubViews {
    if (self.imageView && self.currentPlayerManager.view) {
        UIView *superview = nil;
        if (self.isFullScreen) {
            superview = self.orientationObserver.fullScreenContainerView;
        } else if (self.imageView) {
            superview = self.imageView;
        }
        [superview addSubview:self.currentPlayerManager.view];
        [self.currentPlayerManager.view addSubview:self.controlView];
        self.currentPlayerManager.view.frame = superview.bounds;
        self.currentPlayerManager.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.controlView.frame = self.currentPlayerManager.view.bounds;
        self.controlView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
}

#pragma mark - getter

- (TFY_PlayerNotification *)notification {
    if (!_notification) {
        _notification = [[TFY_PlayerNotification alloc] init];
        PLAYER_WS(myslef);
        _notification.willResignActive = ^(TFY_PlayerNotification * _Nonnull registrar) {
            
            if (myslef.isViewControllerDisappear) return;
            if (myslef.pauseWhenAppResignActive && myslef.currentPlayerManager.isPlaying) {
                myslef.pauseByEvent = YES;
            }
            if (myslef.isFullScreen && !myslef.isLockedScreen) myslef.orientationObserver.lockedScreen = YES;
            [[UIApplication sharedApplication].keyWindow endEditing:YES];
            if (!myslef.pauseWhenAppResignActive) {
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [[AVAudioSession sharedInstance] setActive:YES error:nil];
            }
        };
        _notification.didBecomeActive = ^(TFY_PlayerNotification * _Nonnull registrar) {
            
            if (myslef.isViewControllerDisappear) return;
            if (myslef.isPauseByEvent) myslef.pauseByEvent = NO;
            if (myslef.isFullScreen && !myslef.isLockedScreen) myslef.orientationObserver.lockedScreen = NO;
        };
        _notification.oldDeviceUnavailable = ^(TFY_PlayerNotification * _Nonnull registrar) {
            
            if (myslef.currentPlayerManager.isPlaying) {
                [myslef.currentPlayerManager play];
            }
        };
    }
    return _notification;
}

- (TFY_FloatView *)smallFloatView {
    if (!_smallFloatView) {
        _smallFloatView = [[TFY_FloatView alloc] init];
        _smallFloatView.parentView = [UIApplication sharedApplication].keyWindow;
        _smallFloatView.hidden = YES;
    }
    return _smallFloatView;
}

-(NSMutableDictionary *)dictModel{
    if (!_dictModel) {
        _dictModel = [NSMutableDictionary dictionary];
    }
    return _dictModel;
}

#pragma mark - setter

- (void)setCurrentPlayerManager:(id<TFY_PlayerMediaPlayback>)currentPlayerManager {
    if (!currentPlayerManager) return;
    if (_currentPlayerManager.isPreparedToPlay) {
        [_currentPlayerManager stop];
        [_currentPlayerManager.view removeFromSuperview];
        [self.orientationObserver removeDeviceOrientationObserver];
        [self.gestureControl removeGestureToView:self.currentPlayerManager.view];
    }
    _currentPlayerManager = currentPlayerManager;
    _currentPlayerManager.view.hidden = YES;
    self.gestureControl.disableTypes = self.disableGestureTypes;
    [self.gestureControl addGestureToView:currentPlayerManager.view];
    [self playerManagerCallbcak];
    [self.orientationObserver updateRotateView:currentPlayerManager.view containerView:self.imageView];
    self.controlView.player = self;
    [self layoutPlayerSubViews];
}

-(void)setImageView:(UIView *)imageView{
    _imageView = imageView;
    if (self.scrollView) {
        self.scrollView.tfy_containerView = _imageView;
    }
    if (!_imageView) return;
    _imageView.userInteractionEnabled = YES;
    [self layoutPlayerSubViews];
}

- (void)setControlView:(UIView<TFY_PlayerMediaControl> *)controlView {
    _controlView = controlView;
    if (!controlView) return;
    controlView.player = self;
    [self layoutPlayerSubViews];
}

- (void)setContainerType:(PlayerContainerType)containerType {
    _containerType = containerType;
    if (self.scrollView) {
        self.scrollView.tfy_containerType = containerType;
    }
}

@end

@implementation TFY_PlayerController (PlayerTimeControl)

- (NSTimeInterval)currentTime {
    return self.currentPlayerManager.currentTime;
}

- (NSTimeInterval)totalTime {
    return self.currentPlayerManager.totalTime;
}

- (NSTimeInterval)bufferTime {
    return self.currentPlayerManager.bufferTime;
}

- (float)progress {
    if (self.totalTime == 0) return 0;
    return self.currentTime/self.totalTime;
}

- (float)bufferProgress {
    if (self.totalTime == 0) return 0;
    return self.bufferTime/self.totalTime;
}

- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^)(BOOL))completionHandler {
    [self.currentPlayerManager seekToTime:time completionHandler:completionHandler];
}
/**
 *  视频分解
 */
- (void)splitVideofps:(float)fps progressImageBlock:(void (NS_NOESCAPE ^)(CGFloat progress))progressImageBlock splitCompleteBlock:(void (NS_NOESCAPE ^)(BOOL success, NSMutableArray *splitimgs))splitCompleteBlock{
    [self.currentPlayerManager splitVideofps:fps progressImageBlock:progressImageBlock splitCompleteBlock:splitCompleteBlock];
}
@end

@implementation TFY_PlayerController (PlayerPlaybackControl)

- (void)playTheNext {
    if (self.assetUrlMododels.count > 0) {
        NSInteger index = self.currentPlayIndex + 1;
        if (index >= self.assetUrlMododels.count) return;
        TFY_PlayerVideoModel *model = [self.assetUrlMododels objectAtIndex:index];
        self.assetUrlModel = model;
        self.currentPlayIndex = [self.assetUrlMododels indexOfObject:model];
        if (self.continuouslybool) {
            self.playvideocontinuously(self, model);
        }
    }
}

- (void)playThePrevious {
    if (self.assetUrlMododels.count > 0) {
        NSInteger index = self.currentPlayIndex - 1;
        if (index < 0) return;
        TFY_PlayerVideoModel *model = [self.assetUrlMododels objectAtIndex:index];
        self.assetUrlModel = model;
        self.currentPlayIndex = [self.assetUrlMododels indexOfObject:model];
        if (self.continuouslybool) {
            self.playvideocontinuously(self, model);
        }
    }
}

- (void)playTheIndex:(NSInteger)index {
    if (self.assetUrlMododels.count > 0) {
        if (index >= self.assetUrlMododels.count) return;
        TFY_PlayerVideoModel *model = [self.assetUrlMododels objectAtIndex:index];
        self.assetUrlModel = model;
        self.currentPlayIndex = index;
        if (self.continuouslybool) {
            self.playvideocontinuously(self, model);
        }
    }
}

- (void)stop {
    [self.notification removeNotification];
    [self.orientationObserver removeDeviceOrientationObserver];
    if (self.isFullScreen && self.exitFullScreenWhenStop) {
        [self.orientationObserver exitFullScreenWithAnimated:NO];
    }
    [self.currentPlayerManager stop];
    [self.currentPlayerManager.view removeFromSuperview];
    if (self.scrollView) {
        self.scrollView.tfy_stopPlay = YES;
    }
}

- (void)replaceCurrentPlayerManager:(id<TFY_PlayerMediaPlayback>)playerManager {
    self.currentPlayerManager = playerManager;
}

//// 将视频添加到单元格
- (void)addPlayerViewToCell {
    self.isSmallFloatViewShow = NO;
    self.smallFloatView.hidden = YES;
    UIView *cell = [self.scrollView tfy_getCellForIndexPath:self.playingIndexPath];
    self.imageView = [cell viewWithTag:self.containerViewTag];
    [self.imageView addSubview:self.currentPlayerManager.view];
    self.currentPlayerManager.view.frame = self.imageView.bounds;
    self.currentPlayerManager.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.orientationObserver cellModelRotateView:self.currentPlayerManager.view rotateViewAtCell:cell playerViewTag:self.containerViewTag];
    if ([self.controlView respondsToSelector:@selector(videoPlayer:floatViewShow:)]) {
        [self.controlView videoPlayer:self floatViewShow:NO];
    }
}

//// 将视频添加到容器视图
- (void)addPlayerViewToContainerView:(UIView *)containerView {
    self.isSmallFloatViewShow = NO;
    self.smallFloatView.hidden = YES;
    self.imageView = containerView;
    [self.imageView addSubview:self.currentPlayerManager.view];
    self.currentPlayerManager.view.frame = self.imageView.bounds;
    self.currentPlayerManager.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.orientationObserver cellOtherModelRotateView:self.currentPlayerManager.view containerView:self.imageView];
    if ([self.controlView respondsToSelector:@selector(videoPlayer:floatViewShow:)]) {
        [self.controlView videoPlayer:self floatViewShow:NO];
    }
}

/// 添加到keyWindow
- (void)addPlayerViewToKeyWindow {
    self.isSmallFloatViewShow = YES;
    self.smallFloatView.hidden = NO;
    [self.smallFloatView addSubview:self.currentPlayerManager.view];
    self.currentPlayerManager.view.frame = self.smallFloatView.bounds;
    self.currentPlayerManager.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.orientationObserver cellOtherModelRotateView:self.currentPlayerManager.view containerView:self.smallFloatView];
    if ([self.controlView respondsToSelector:@selector(videoPlayer:floatViewShow:)]) {
        [self.controlView videoPlayer:self floatViewShow:YES];
    }
}

- (void)stopCurrentPlayingView {
    if (self.imageView) {
        [self stop];
        self.isSmallFloatViewShow = NO;
        if (self.smallFloatView) self.smallFloatView.hidden = YES;
    }
}

- (void)stopCurrentPlayingCell {
    if (self.scrollView.tfy_playingIndexPath) {
        [self stop];
        self.isSmallFloatViewShow = NO;
        self.playingIndexPath = nil;
        if (self.smallFloatView) self.smallFloatView.hidden = YES;
    }
}
/**
 * 获取播放视频所有数据
 */
-(NSDictionary *)ModelDict{
    if (self.assetUrlModel.tfy_url !=nil || ![self.assetUrlModel.tfy_url isEqualToString:@""]) {
        [self.dictModel setObject:self.assetUrlModel.tfy_url forKey:@"tfy_url"];
        [self.dictModel setObject:self.assetUrlModel.tfy_name forKey:@"tfy_name"];
        [self.dictModel setObject:[NSString stringWithFormat:@"%.2f",self.currentTime] forKey:@"tfy_seconds"];
        [self.dictModel setObject:[NSString stringWithFormat:@"%ld",(long)self.currentPlayIndex] forKey:@"tfy_videoId"];
    }
    if (self.assetUrlModel.tfy_ids!=nil || ![self.assetUrlModel.tfy_ids isEqualToString:@""]) {
        [self.dictModel setObject:self.assetUrlModel.tfy_ids forKey:@"tfy_ids"];
    }
    if (self.assetUrlModel.tfy_pic!=nil || ![self.assetUrlModel.tfy_pic isEqualToString:@""]) {
        [self.dictModel setObject:self.assetUrlModel.tfy_pic forKey:@"tfy_pic"];
    }
    return self.dictModel;
}
#pragma mark - getter

-(TFY_PlayerVideoModel *)assetUrlModel{
    return objc_getAssociatedObject(self, _cmd);
}


-(NSArray<TFY_PlayerVideoModel *> *)assetUrlMododels{
    return objc_getAssociatedObject(self, _cmd);
}

- (BOOL)isLastAssetURL {
    if (self.assetUrlMododels.count > 0) {
        return self.assetUrlModel == self.assetUrlMododels.lastObject;
    }
    return NO;
}

- (BOOL)isFirstAssetURL {
    if (self.assetUrlMododels.count > 0) {
        return self.assetUrlModel == self.assetUrlMododels.firstObject;
    }
    return NO;
}

- (BOOL)isPauseByEvent {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (float)brightness {
    return [UIScreen mainScreen].brightness;
}

- (float)volume {
    CGFloat volume = self.volumeViewSlider.value;
    if (volume == 0) {
        volume = [[AVAudioSession sharedInstance] outputVolume];
    }
    return volume;
}

- (BOOL)isMuted {
    return self.volume == 0;
}

- (float)lastVolumeValue {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (PlayerPlaybackState)playState {
    return self.currentPlayerManager.playState;
}

- (BOOL)isPlaying {
    return self.currentPlayerManager.isPlaying;
}

- (BOOL)pauseWhenAppResignActive {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number.boolValue) return number.boolValue;
    self.pauseWhenAppResignActive = YES;
    return YES;
}

- (void (^)(id<TFY_PlayerMediaPlayback> _Nonnull, NSString * _Nonnull assetURL))playerPrepareToPlay {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(id<TFY_PlayerMediaPlayback> _Nonnull, NSString * _Nonnull assetURL))playerReadyToPlay {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(id<TFY_PlayerMediaPlayback> _Nonnull, NSTimeInterval, NSTimeInterval))playerPlayTimeChanged {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(id<TFY_PlayerMediaPlayback> _Nonnull, NSTimeInterval))playerBufferTimeChanged {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(id<TFY_PlayerMediaPlayback> _Nonnull, PlayerPlaybackState))playerPlayStateChanged {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(id<TFY_PlayerMediaPlayback> _Nonnull, PlayerLoadState))playerLoadStateChanged {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(id<TFY_PlayerMediaPlayback> _Nonnull))playerDidToEnd {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(id<TFY_PlayerMediaPlayback> _Nonnull, id _Nonnull))playerPlayFailed {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(id<TFY_PlayerMediaPlayback> _Nonnull, CGSize ))presentationSizeChanged {
    return objc_getAssociatedObject(self, _cmd);
}

-(void (^)(TFY_PlayerController *player, TFY_PlayerVideoModel *model))playvideocontinuously{
    return objc_getAssociatedObject(self, _cmd);
}

- (NSInteger)currentPlayIndex {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (BOOL)isViewControllerDisappear {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (BOOL)customAudioSession {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

#pragma mark - setter

-(void)setAssetUrlModel:(TFY_PlayerVideoModel *)assetUrlModel{
    objc_setAssociatedObject(self, @selector(assetUrlModel), assetUrlModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.currentPlayerManager.assetURL = assetUrlModel.tfy_url;
}


-(void)setAssetUrlMododels:(NSArray<TFY_PlayerVideoModel *> *)assetUrlMododels{
    objc_setAssociatedObject(self, @selector(assetUrlMododels), assetUrlMododels, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)setVolume:(float)volume {
    volume = MIN(MAX(0, volume), 1);
    objc_setAssociatedObject(self, @selector(volume), @(volume), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.volumeViewSlider.value = volume;
}

- (void)setMuted:(BOOL)muted {
    if (muted) {
        if (self.volumeViewSlider.value > 0) {
            self.lastVolumeValue = self.volumeViewSlider.value;
        }
        self.volumeViewSlider.value = 0;
    } else {
        self.volumeViewSlider.value = self.lastVolumeValue;
    }
}

- (void)setLastVolumeValue:(float)lastVolumeValue {
    objc_setAssociatedObject(self, @selector(lastVolumeValue), @(lastVolumeValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setBrightness:(float)brightness {
    brightness = MIN(MAX(0, brightness), 1);
    objc_setAssociatedObject(self, @selector(brightness), @(brightness), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [UIScreen mainScreen].brightness = brightness;
}

- (void)setPauseByEvent:(BOOL)pauseByEvent {
    objc_setAssociatedObject(self, @selector(isPauseByEvent), @(pauseByEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (pauseByEvent) {
        [self.currentPlayerManager pause];
    } else {
        [self.currentPlayerManager play];
    }
}

- (void)setPauseWhenAppResignActive:(BOOL)pauseWhenAppResignActive {
    objc_setAssociatedObject(self, @selector(pauseWhenAppResignActive), @(pauseWhenAppResignActive), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setPlayerPrepareToPlay:(void (^)(id<TFY_PlayerMediaPlayback> _Nonnull, NSString * _Nonnull url))playerPrepareToPlay {
    objc_setAssociatedObject(self, @selector(playerPrepareToPlay), playerPrepareToPlay, OBJC_ASSOCIATION_COPY);
}

- (void)setPlayerReadyToPlay:(void (^)(id<TFY_PlayerMediaPlayback> _Nonnull, NSString * _Nonnull url))playerReadyToPlay {
    objc_setAssociatedObject(self, @selector(playerReadyToPlay), playerReadyToPlay, OBJC_ASSOCIATION_COPY);
}

- (void)setPlayerPlayTimeChanged:(void (^)(id<TFY_PlayerMediaPlayback> _Nonnull, NSTimeInterval, NSTimeInterval))playerPlayTimeChanged {
    objc_setAssociatedObject(self, @selector(playerPlayTimeChanged), playerPlayTimeChanged, OBJC_ASSOCIATION_COPY);
}

- (void)setPlayerBufferTimeChanged:(void (^)(id<TFY_PlayerMediaPlayback> _Nonnull, NSTimeInterval))playerBufferTimeChanged {
    objc_setAssociatedObject(self, @selector(playerBufferTimeChanged), playerBufferTimeChanged, OBJC_ASSOCIATION_COPY);
}

- (void)setPlayerPlayStateChanged:(void (^)(id<TFY_PlayerMediaPlayback> _Nonnull, PlayerPlaybackState))playerPlayStateChanged {
    objc_setAssociatedObject(self, @selector(playerPlayStateChanged), playerPlayStateChanged, OBJC_ASSOCIATION_COPY);
}

- (void)setPlayerLoadStateChanged:(void (^)(id<TFY_PlayerMediaPlayback> _Nonnull, PlayerLoadState))playerLoadStateChanged {
    objc_setAssociatedObject(self, @selector(playerLoadStateChanged), playerLoadStateChanged, OBJC_ASSOCIATION_COPY);
}

- (void)setPlayerDidToEnd:(void (^)(id<TFY_PlayerMediaPlayback> _Nonnull))playerDidToEnd {
    objc_setAssociatedObject(self, @selector(playerDidToEnd), playerDidToEnd, OBJC_ASSOCIATION_COPY);
}

- (void)setPlayerPlayFailed:(void (^)(id<TFY_PlayerMediaPlayback> _Nonnull, id _Nonnull))playerPlayFailed {
    objc_setAssociatedObject(self, @selector(playerPlayFailed), playerPlayFailed, OBJC_ASSOCIATION_COPY);
}

- (void)setPresentationSizeChanged:(void (^)(id<TFY_PlayerMediaPlayback> _Nonnull, CGSize))presentationSizeChanged {
    objc_setAssociatedObject(self, @selector(presentationSizeChanged), presentationSizeChanged, OBJC_ASSOCIATION_COPY);
}

-(void)setPlayvideocontinuously:(void (^)(TFY_PlayerController *player, TFY_PlayerVideoModel * _Nonnull))playvideocontinuously{
    objc_setAssociatedObject(self, @selector(playvideocontinuously), playvideocontinuously, OBJC_ASSOCIATION_COPY);
}

- (void)setCurrentPlayIndex:(NSInteger)currentPlayIndex {
    objc_setAssociatedObject(self, @selector(currentPlayIndex), @(currentPlayIndex), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setViewControllerDisappear:(BOOL)viewControllerDisappear {
    objc_setAssociatedObject(self, @selector(isViewControllerDisappear), @(viewControllerDisappear), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.scrollView) self.scrollView.tfy_viewControllerDisappear = viewControllerDisappear;
    if (!self.currentPlayerManager.isPreparedToPlay) return;
    if (viewControllerDisappear) {
        [self removeDeviceOrientationObserver];
        if (self.currentPlayerManager.isPlaying) self.pauseByEvent = YES;
    } else {
        if (self.isPauseByEvent) self.pauseByEvent = NO;
        [self addDeviceOrientationObserver];
    }
}

- (void)setCustomAudioSession:(BOOL)customAudioSession {
    objc_setAssociatedObject(self, @selector(customAudioSession), @(customAudioSession), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation TFY_PlayerController (PlayerOrientationRotation)

- (void)addDeviceOrientationObserver {
    [self.orientationObserver addDeviceOrientationObserver];
}

- (void)removeDeviceOrientationObserver {
    [self.orientationObserver removeDeviceOrientationObserver];
}

- (void)enterLandscapeFullScreen:(UIInterfaceOrientation)orientation animated:(BOOL)animated {
    self.orientationObserver.fullScreenMode = FullScreenModeLandscape;
    [self.orientationObserver enterLandscapeFullScreen:orientation animated:animated];
}

- (void)enterPortraitFullScreen:(BOOL)fullScreen animated:(BOOL)animated {
    self.orientationObserver.fullScreenMode = FullScreenModePortrait;
    [self.orientationObserver enterPortraitFullScreen:fullScreen animated:animated];
}

- (void)enterFullScreen:(BOOL)fullScreen animated:(BOOL)animated {
    if (self.orientationObserver.fullScreenMode == FullScreenModePortrait) {
        [self.orientationObserver enterPortraitFullScreen:fullScreen animated:animated];
    } else {
        UIInterfaceOrientation orientation = UIInterfaceOrientationUnknown;
        orientation = fullScreen? UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait;
        [self.orientationObserver enterLandscapeFullScreen:orientation animated:animated];
    }
}

- (BOOL)shouldForceDeviceOrientation {
    if (self.forceDeviceOrientation) return YES;
    NSArray<NSString *> *versionStrArr = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    int firstVer = [[versionStrArr objectAtIndex:0] intValue];
    int secondVer = [[versionStrArr objectAtIndex:1] intValue];
    if (firstVer == 8) {
        if (secondVer >= 1 && secondVer <= 3) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - getter

- (TFY_OrientationObserver *)orientationObserver {
    PLAYER_WS(myself);
    TFY_OrientationObserver *orientationObserver = objc_getAssociatedObject(self, _cmd);
    if (!orientationObserver) {
        orientationObserver = [[TFY_OrientationObserver alloc] init];
        orientationObserver.orientationWillChange = ^(TFY_OrientationObserver * _Nonnull observer, BOOL isFullScreen) {
            
            if (myself.orientationWillChange) myself.orientationWillChange(self, isFullScreen);
            if ([myself.controlView respondsToSelector:@selector(videoPlayer:orientationWillChange:)]) {
                [myself.controlView videoPlayer:myself orientationWillChange:observer];
            }
            [myself.controlView setNeedsLayout];
            [myself.controlView layoutIfNeeded];
        };
        orientationObserver.orientationDidChanged = ^(TFY_OrientationObserver * _Nonnull observer, BOOL isFullScreen) {
            
            if (myself.orientationDidChanged) myself.orientationDidChanged(myself, isFullScreen);
            if ([myself.controlView respondsToSelector:@selector(videoPlayer:orientationDidChanged:)]) {
                [myself.controlView videoPlayer:myself orientationDidChanged:observer];
            }
        };
        objc_setAssociatedObject(self, _cmd, orientationObserver, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return orientationObserver;
}

- (void (^)(TFY_PlayerController * _Nonnull, BOOL))orientationWillChange {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(TFY_PlayerController * _Nonnull, BOOL))orientationDidChanged {
    return objc_getAssociatedObject(self, _cmd);
}

- (BOOL)isFullScreen {
    return self.orientationObserver.isFullScreen;
}

- (BOOL)exitFullScreenWhenStop {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number.boolValue) return number.boolValue;
    self.exitFullScreenWhenStop = YES;
    return YES;
}

- (UIInterfaceOrientation)currentOrientation {
    return self.orientationObserver.currentOrientation;
}

- (BOOL)isStatusBarHidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (BOOL)isLockedScreen {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (BOOL)shouldAutorotate {
    return [self shouldForceDeviceOrientation];
}

- (BOOL)allowOrentitaionRotation {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number.boolValue) return number.boolValue;
    self.allowOrentitaionRotation = YES;
    return YES;
}

-(BOOL)systemrotationbool{
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number.boolValue) return number.boolValue;
    self.systemrotationbool = NO;
    return NO;
}


- (BOOL)forceDeviceOrientation {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

#pragma mark - setter

- (void)setOrientationWillChange:(void (^)(TFY_PlayerController * _Nonnull, BOOL))orientationWillChange {
    objc_setAssociatedObject(self, @selector(orientationWillChange), orientationWillChange, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setOrientationDidChanged:(void (^)(TFY_PlayerController * _Nonnull, BOOL))orientationDidChanged {
    objc_setAssociatedObject(self, @selector(orientationDidChanged), orientationDidChanged, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setStatusBarHidden:(BOOL)statusBarHidden {
    objc_setAssociatedObject(self, @selector(isStatusBarHidden), @(statusBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.orientationObserver.statusBarHidden = statusBarHidden;
}

- (void)setLockedScreen:(BOOL)lockedScreen {
    objc_setAssociatedObject(self, @selector(isLockedScreen), @(lockedScreen), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.orientationObserver.lockedScreen = lockedScreen;
    if ([self.controlView respondsToSelector:@selector(lockedVideoPlayer:lockedScreen:)]) {
        [self.controlView lockedVideoPlayer:self lockedScreen:lockedScreen];
    }
}

- (void)setAllowOrentitaionRotation:(BOOL)allowOrentitaionRotation {
    objc_setAssociatedObject(self, @selector(allowOrentitaionRotation), @(allowOrentitaionRotation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.orientationObserver.allowOrentitaionRotation = allowOrentitaionRotation;
}

- (void)setForceDeviceOrientation:(BOOL)forceDeviceOrientation {
    objc_setAssociatedObject(self, @selector(forceDeviceOrientation), @(forceDeviceOrientation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.orientationObserver.forceDeviceOrientation = forceDeviceOrientation;
}

-(void)setSystemrotationbool:(BOOL)systemrotationbool{
    objc_setAssociatedObject(self, @selector(systemrotationbool), @(systemrotationbool), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.orientationObserver.systemrotationbool = systemrotationbool;
}


- (void)setExitFullScreenWhenStop:(BOOL)exitFullScreenWhenStop {
    objc_setAssociatedObject(self, @selector(exitFullScreenWhenStop), @(exitFullScreenWhenStop), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


@implementation TFY_PlayerController (PlayerViewGesture)

#pragma mark - getter

- (TFY_PlayerGestureControl *)gestureControl {
    TFY_PlayerGestureControl *gestureControl = objc_getAssociatedObject(self, _cmd);
    if (!gestureControl) {
        gestureControl = [[TFY_PlayerGestureControl alloc] init];
        PLAYER_WS(myself);
        gestureControl.triggerCondition = ^BOOL(TFY_PlayerGestureControl * _Nonnull control, PlayerGestureType type, UIGestureRecognizer * _Nonnull gesture, UITouch *touch) {
           
            if ([myself.controlView respondsToSelector:@selector(gestureTriggerCondition:gestureType:gestureRecognizer:touch:)]) {
                return [myself.controlView gestureTriggerCondition:control gestureType:type gestureRecognizer:gesture touch:touch];
            }
            return YES;
        };
        
        gestureControl.singleTapped = ^(TFY_PlayerGestureControl * _Nonnull control) {
            
            if ([myself.controlView respondsToSelector:@selector(gestureSingleTapped:)]) {
                [myself.controlView gestureSingleTapped:control];
            }
        };
        
        gestureControl.doubleTapped = ^(TFY_PlayerGestureControl * _Nonnull control) {
            
            if ([myself.controlView respondsToSelector:@selector(gestureDoubleTapped:)]) {
                [myself.controlView gestureDoubleTapped:control];
            }
        };
        
        gestureControl.beganPan = ^(TFY_PlayerGestureControl * _Nonnull control, PanDirection direction, PanLocation location) {
           
            if ([myself.controlView respondsToSelector:@selector(gestureBeganPan:panDirection:panLocation:)]) {
                [myself.controlView gestureBeganPan:control panDirection:direction panLocation:location];
            }
        };
        
        gestureControl.changedPan = ^(TFY_PlayerGestureControl * _Nonnull control, PanDirection direction, PanLocation location, CGPoint velocity) {
           
            if ([myself.controlView respondsToSelector:@selector(gestureChangedPan:panDirection:panLocation:withVelocity:)]) {
                [myself.controlView gestureChangedPan:control panDirection:direction panLocation:location withVelocity:velocity];
            }
        };
        
        gestureControl.endedPan = ^(TFY_PlayerGestureControl * _Nonnull control, PanDirection direction, PanLocation location) {
            
            if ([myself.controlView respondsToSelector:@selector(gestureEndedPan:panDirection:panLocation:)]) {
                [myself.controlView gestureEndedPan:control panDirection:direction panLocation:location];
            }
        };
        
        gestureControl.pinched = ^(TFY_PlayerGestureControl * _Nonnull control, float scale) {
            
            if ([myself.controlView respondsToSelector:@selector(gesturePinched:scale:)]) {
                [myself.controlView gesturePinched:control scale:scale];
            }
        };
        objc_setAssociatedObject(self, _cmd, gestureControl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return gestureControl;
}

- (PlayerDisableGestureTypes)disableGestureTypes {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (PlayerDisablePanMovingDirection)disablePanMovingDirection {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

#pragma mark - setter

- (void)setDisableGestureTypes:(PlayerDisableGestureTypes)disableGestureTypes {
    objc_setAssociatedObject(self, @selector(disableGestureTypes), @(disableGestureTypes), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.gestureControl.disableTypes = disableGestureTypes;
}

- (void)setDisablePanMovingDirection:(PlayerDisablePanMovingDirection)disablePanMovingDirection {
    objc_setAssociatedObject(self, @selector(disablePanMovingDirection), @(disablePanMovingDirection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.gestureControl.disablePanMovingDirection = disablePanMovingDirection;
}

@end

@implementation TFY_PlayerController (PlayerScrollView)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selectors[] = {
            NSSelectorFromString(@"dealloc")
        };
        
        for (NSInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
            SEL originalSelector = selectors[index];
            SEL swizzledSelector = NSSelectorFromString([@"tfy_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
            Method originalMethod = class_getInstanceMethod(self, originalSelector);
            Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
            if (class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }
    });
}

- (void)tfy_dealloc {
    [self.smallFloatView removeFromSuperview];
    self.smallFloatView = nil;
    [self tfy_dealloc];
}

#pragma mark - setter

- (void)setScrollView:(UIScrollView *)scrollView {
    objc_setAssociatedObject(self, @selector(scrollView), scrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.scrollView.tfy_WWANAutoPlay = self.isWWANAutoPlay;
    PLAYER_WS(myself);
    scrollView.tfy_playerWillAppearInScrollView = ^(NSIndexPath * _Nonnull indexPath) {
        
        if (myself.isFullScreen) return;
        if (myself.tfy_playerWillAppearInScrollView) myself.tfy_playerWillAppearInScrollView(indexPath);
        if ([myself.controlView respondsToSelector:@selector(playerDidAppearInScrollView:)]) {
            [myself.controlView playerDidAppearInScrollView:myself];
        }
    };
    
    scrollView.tfy_playerDidAppearInScrollView = ^(NSIndexPath * _Nonnull indexPath) {
        
        if (myself.isFullScreen) return;
        if (myself.tfy_playerDidAppearInScrollView) myself.tfy_playerDidAppearInScrollView(indexPath);
        if ([myself.controlView respondsToSelector:@selector(playerDidAppearInScrollView:)]) {
            [myself.controlView playerDidAppearInScrollView:myself];
        }
    };
    
    scrollView.tfy_playerWillDisappearInScrollView = ^(NSIndexPath * _Nonnull indexPath) {
        
        if (myself.isFullScreen) return;
        if (myself.tfy_playerWillDisappearInScrollView) myself.tfy_playerWillDisappearInScrollView(indexPath);
        if ([myself.controlView respondsToSelector:@selector(playerWillDisappearInScrollView:)]) {
            [myself.controlView playerWillDisappearInScrollView:myself];
        }
    };
    
    scrollView.tfy_playerDidDisappearInScrollView = ^(NSIndexPath * _Nonnull indexPath) {
        
        if (myself.isFullScreen) return;
        if (myself.tfy_playerDidDisappearInScrollView) myself.tfy_playerDidDisappearInScrollView(indexPath);
        if ([myself.controlView respondsToSelector:@selector(playerDidDisappearInScrollView:)]) {
            [myself.controlView playerDidDisappearInScrollView:myself];
        }
    };
    
    scrollView.tfy_playerAppearingInScrollView = ^(NSIndexPath * _Nonnull indexPath, CGFloat playerApperaPercent) {
        
        if (myself.isFullScreen) return;
        if (myself.tfy_playerAppearingInScrollView) myself.tfy_playerAppearingInScrollView(indexPath, playerApperaPercent);
        if ([myself.controlView respondsToSelector:@selector(playerAppearingInScrollView:playerApperaPercent:)]) {
            [myself.controlView playerAppearingInScrollView:myself playerApperaPercent:playerApperaPercent];
        }
        if (!myself.stopWhileNotVisible && playerApperaPercent >= myself.playerApperaPercent) {
            if (myself.containerType == PlayerContainerTypeView) {
                [myself addPlayerViewToContainerView:myself.imageView];
            } else if (myself.containerType == PlayerContainerTypeCell) {
                [myself addPlayerViewToCell];
            }
        }
    };
    
    scrollView.tfy_playerDisappearingInScrollView = ^(NSIndexPath * _Nonnull indexPath, CGFloat playerDisapperaPercent) {
        
        if (myself.isFullScreen) return;
        if (myself.tfy_playerDisappearingInScrollView) myself.tfy_playerDisappearingInScrollView(indexPath, playerDisapperaPercent);
        if ([myself.controlView respondsToSelector:@selector(playerDisappearingInScrollView:playerDisapperaPercent:)]) {
            [myself.controlView playerDisappearingInScrollView:myself playerDisapperaPercent:playerDisapperaPercent];
        }
        
        if (myself.stopWhileNotVisible && playerDisapperaPercent >= myself.playerDisapperaPercent) {
            if (myself.containerType == PlayerContainerTypeView) {
                [myself stopCurrentPlayingView];
            } else if (myself.containerType == PlayerContainerTypeCell) {
                [myself stopCurrentPlayingCell];
            }
        }
    
        if (!myself.stopWhileNotVisible && playerDisapperaPercent >= myself.playerDisapperaPercent) [myself addPlayerViewToKeyWindow];
    };
}

- (void)setWWANAutoPlay:(BOOL)WWANAutoPlay {
    objc_setAssociatedObject(self, @selector(isWWANAutoPlay), @(WWANAutoPlay), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.scrollView) self.scrollView.tfy_WWANAutoPlay = self.isWWANAutoPlay;
}

- (void)setStopWhileNotVisible:(BOOL)stopWhileNotVisible {
    self.scrollView.tfy_stopWhileNotVisible = stopWhileNotVisible;
    objc_setAssociatedObject(self, @selector(stopWhileNotVisible), @(stopWhileNotVisible), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setContainerViewTag:(NSInteger)containerViewTag {
    objc_setAssociatedObject(self, @selector(containerViewTag), @(containerViewTag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.scrollView.tfy_containerViewTag = containerViewTag;
}

- (void)setPlayingIndexPath:(NSIndexPath *)playingIndexPath {
    objc_setAssociatedObject(self, @selector(playingIndexPath), playingIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (playingIndexPath) {
        [self stopCurrentPlayingCell];
        UIView *cell = [self.scrollView tfy_getCellForIndexPath:playingIndexPath];
        self.imageView = [cell viewWithTag:self.containerViewTag];
        [self.orientationObserver cellModelRotateView:self.currentPlayerManager.view rotateViewAtCell:cell playerViewTag:self.containerViewTag];
        [self addDeviceOrientationObserver];
        self.scrollView.tfy_playingIndexPath = playingIndexPath;
        [self layoutPlayerSubViews];
    } else {
        self.scrollView.tfy_playingIndexPath = playingIndexPath;
    }
}

- (void)setShouldAutoPlay:(BOOL)shouldAutoPlay {
    objc_setAssociatedObject(self, @selector(shouldAutoPlay), @(shouldAutoPlay), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.scrollView.tfy_shouldAutoPlay = shouldAutoPlay;
}

- (void)setSectionAssetURLs:(NSArray<NSArray<TFY_PlayerVideoModel *> *> * _Nullable)sectionAssetURLs {
    objc_setAssociatedObject(self, @selector(sectionAssetURLs), sectionAssetURLs, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setPlayerDisapperaPercent:(CGFloat)playerDisapperaPercent {
    playerDisapperaPercent = MIN(MAX(0.0, playerDisapperaPercent), 1.0);
    self.scrollView.tfy_playerDisapperaPercent = playerDisapperaPercent;
    objc_setAssociatedObject(self, @selector(playerDisapperaPercent), @(playerDisapperaPercent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setPlayerApperaPercent:(CGFloat)playerApperaPercent {
    playerApperaPercent = MIN(MAX(0.0, playerApperaPercent), 1.0);
    self.scrollView.tfy_playerApperaPercent = playerApperaPercent;
    objc_setAssociatedObject(self, @selector(playerApperaPercent), @(playerApperaPercent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTfy_playerAppearingInScrollView:(void (^)(NSIndexPath * _Nonnull, CGFloat))tfy_playerAppearingInScrollView {
    objc_setAssociatedObject(self, @selector(tfy_playerAppearingInScrollView), tfy_playerAppearingInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTfy_playerDisappearingInScrollView:(void (^)(NSIndexPath * _Nonnull, CGFloat))tfy_playerDisappearingInScrollView {
    objc_setAssociatedObject(self, @selector(tfy_playerDisappearingInScrollView), tfy_playerDisappearingInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTfy_playerDidAppearInScrollView:(void (^)(NSIndexPath * _Nonnull))tfy_playerDidAppearInScrollView {
    objc_setAssociatedObject(self, @selector(tfy_playerDidAppearInScrollView), tfy_playerDidAppearInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTfy_playerWillDisappearInScrollView:(void (^)(NSIndexPath * _Nonnull))tfy_playerWillDisappearInScrollView {
    objc_setAssociatedObject(self, @selector(tfy_playerWillDisappearInScrollView), tfy_playerWillDisappearInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTfy_playerWillAppearInScrollView:(void (^)(NSIndexPath * _Nonnull))tfy_playerWillAppearInScrollView {
    objc_setAssociatedObject(self, @selector(tfy_playerWillAppearInScrollView), tfy_playerWillAppearInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTfy_playerDidDisappearInScrollView:(void (^)(NSIndexPath * _Nonnull))tfy_playerDidDisappearInScrollView {
    objc_setAssociatedObject(self, @selector(tfy_playerDidDisappearInScrollView), tfy_playerDidDisappearInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTfy_scrollViewDidStopScrollCallback:(void (^)(NSIndexPath * _Nonnull))tfy_scrollViewDidStopScrollCallback {
    objc_setAssociatedObject(self, @selector(tfy_scrollViewDidStopScrollCallback), tfy_scrollViewDidStopScrollCallback, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - getter

- (UIScrollView *)scrollView {
    UIScrollView *scrollView = objc_getAssociatedObject(self, _cmd);
    return scrollView;
}

- (BOOL)isWWANAutoPlay {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (BOOL)stopWhileNotVisible {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number.boolValue) return number.boolValue;
    self.stopWhileNotVisible = YES;
    return YES;
}

- (NSInteger)containerViewTag {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (NSIndexPath *)playingIndexPath {
    return objc_getAssociatedObject(self, _cmd);
}

- (NSArray<NSArray<TFY_PlayerVideoModel *> *> *)sectionAssetURLs {
    return objc_getAssociatedObject(self, _cmd);
}

- (BOOL)shouldAutoPlay {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (CGFloat)playerDisapperaPercent {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number.floatValue) return number.floatValue;
    self.playerDisapperaPercent = 0.5;
    return 0.5;
}

- (CGFloat)playerApperaPercent {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number.floatValue) return number.floatValue;
    self.playerApperaPercent = 0.0;
    return 0.0;
}

- (void (^)(NSIndexPath * _Nonnull, CGFloat))tfy_playerAppearingInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull, CGFloat))tfy_playerDisappearingInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))tfy_playerDidAppearInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))tfy_playerWillDisappearInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))tfy_playerWillAppearInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))tfy_playerDidDisappearInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))tfy_scrollViewDidStopScrollCallback {
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - Public method

- (void)playTheIndexPath:(NSIndexPath *)indexPath {
    self.playingIndexPath = indexPath;
    TFY_PlayerVideoModel *assetURL=[TFY_PlayerVideoModel new];
    if (self.sectionAssetURLs.count) {
        assetURL = self.sectionAssetURLs[indexPath.section][indexPath.row];
    } else if (self.assetUrlMododels.count) {
        assetURL = self.assetUrlMododels[indexPath.row];
        self.currentPlayIndex = indexPath.row;
    }
    self.assetUrlModel = assetURL;
}

- (void)playTheIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop completionHandler:(void (^ _Nullable)(void))completionHandler {
    TFY_PlayerVideoModel *assetURL=[TFY_PlayerVideoModel new];;
    if (self.sectionAssetURLs.count) {
        assetURL = self.sectionAssetURLs[indexPath.section][indexPath.row];
    } else if (self.assetUrlMododels.count) {
        assetURL = self.assetUrlMododels[indexPath.row];
        self.currentPlayIndex = indexPath.row;
    }
    if (scrollToTop) {
        PLAYER_WS(myself);
        [self.scrollView tfy_scrollToRowAtIndexPath:indexPath completionHandler:^{
            
            if (completionHandler) completionHandler();
            myself.playingIndexPath = indexPath;
            myself.assetUrlModel = assetURL;
        }];
    } else {
        if (completionHandler) completionHandler();
        self.playingIndexPath = indexPath;
        self.assetUrlModel = assetURL;
    }
}

- (void)playTheIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    if ([indexPath compare:self.playingIndexPath] == NSOrderedSame) return;
    if (scrollToTop) {
        PLAYER_WS(myself);
        [self.scrollView tfy_scrollToRowAtIndexPath:indexPath completionHandler:^{
            
            [myself playTheIndexPath:indexPath];
        }];
    } else {
        [self playTheIndexPath:indexPath];
    }
}

- (void)playTheIndexPath:(NSIndexPath *)indexPath assetURL:(NSString *)assetURL scrollToTop:(BOOL)scrollToTop {
    self.playingIndexPath = indexPath;
    self.assetUrlModel.tfy_url = assetURL;
    if (scrollToTop) {
        [self.scrollView tfy_scrollToRowAtIndexPath:indexPath completionHandler:nil];
    }
}

@end

@implementation TFY_PlayerController (PlayerDeprecated)

- (void)updateScrollViewPlayerToCell {
    if (self.currentPlayerManager.view && self.playingIndexPath && self.containerViewTag) {
        UIView *cell = [self.scrollView tfy_getCellForIndexPath:self.playingIndexPath];
        self.imageView = [cell viewWithTag:self.containerViewTag];
        [self.orientationObserver cellModelRotateView:self.currentPlayerManager.view rotateViewAtCell:cell playerViewTag:self.containerViewTag];
        [self layoutPlayerSubViews];
    }
}

- (void)updateNoramlPlayerWithContainerView:(UIView *)containerView {
    if (self.currentPlayerManager.view && self.imageView) {
        self.imageView = containerView;
        [self.orientationObserver cellOtherModelRotateView:self.currentPlayerManager.view containerView:self.imageView];
        [self layoutPlayerSubViews];
    }
}

@end
