//
//  TFY_PlayerControllerView.m
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/7/2.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_PlayerControllerView.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "TFY_VolumeBrightnessView.h" //声音和亮度
#import "TFY_SmallFloatControlView.h" //小视频关闭
#import "TFY_SliderView.h"

@interface TFY_PlayerControllerView ()<SliderViewDelegate>
/// 竖屏控制层的View
@property (nonatomic, strong) TFY_PortraitControlView *portraitControlView;
/// 横屏控制层的View
@property (nonatomic, strong) TFY_LandScapeControlView *landScapeControlView;
//显示工具
@property (nonatomic, strong) TFY_fastView *fastView;

/// 是否显示了控制层
@property (nonatomic, assign, getter=isShowing) BOOL showing;
/// 是否播放结束
@property (nonatomic, assign, getter=isPlayEnd) BOOL playeEnd;

@property (nonatomic, assign) BOOL controlViewAppeared;

@property (nonatomic, assign) NSTimeInterval sumTime;

@property (nonatomic, strong) dispatch_block_t afterBlock;

@property (nonatomic, strong) TFY_VolumeBrightnessView *volumeBrightnessView;

@property (nonatomic, strong) TFY_SmallFloatControlView *floatControlView;
/// 底部播放进度
@property (nonatomic, strong) TFY_SliderView *bottomPgrogress;

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UIView *effectView;
@property (nonatomic, strong) UIView *statusBar;
/// 封面图
@property (nonatomic, strong) UIImageView *coverImageView;
/**
 *  全屏显示 ，小屏隐藏
 */
@property (assign,nonatomic) BOOL lockBtnbool;

@end

@implementation TFY_PlayerControllerView
@synthesize player = _player;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addAllSubViews];
        
        self.landScapeControlView.hidden = YES;
        self.floatControlView.hidden = YES;
        self.seekToPlay = YES;
        self.effectViewShow = YES;
        self.horizontalPanShowControlView = YES;
        self.autoFadeTimeInterval = 0.25;
        self.autoHiddenTimeInterval = 2.5;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(volumeChanged:)
                                                     name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                                   object:nil];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.coverImageView.frame = self.bounds;
    self.bgImgView.frame = self.bounds;
    self.effectView.frame = self.bounds;
}

/// 添加所有子控件
- (void)addAllSubViews {
    [self addSubview:self.portraitControlView];
    [self.portraitControlView tfy_AutoSize:0 top:0 right:0 bottom:0];
    
    [self addSubview:self.landScapeControlView];
    [self.landScapeControlView tfy_AutoSize:0 top:0 right:0 bottom:0];
    
    [self addSubview:self.fastView];
    self.fastView.tfy_Center(0, 0).tfy_size(120, 80);
    
    [self addSubview:self.floatControlView];
    self.floatControlView.tfy_RightSpace(40).tfy_size(self.coverImageView.frame.size.width/2, self.coverImageView.frame.size.width*9/16);
    
    [self addSubview:self.volumeBrightnessView];
    self.volumeBrightnessView.tfy_CenterX(0).tfy_TopSpace(30).tfy_size(140, 35);
    
    [self addSubview:self.bottomPgrogress];
    self.bottomPgrogress.tfy_LeftSpace(0).tfy_RightSpace(0).tfy_BottomSpace(0).tfy_Height(1);
    
    TFY_PLAYER_WS(myslef);
    self.fastView.failblack = ^{
         [myslef.player.currentPlayerManager reloadPlayer];
    };
}

/// 重置控制层
- (void)resetControlView {
    [self.portraitControlView resetControlView];
    [self.landScapeControlView resetControlView];
    [self cancelAutoFadeOutControlView];
    self.bottomPgrogress.value = 0;
    self.bottomPgrogress.bufferValue = 0;
    self.floatControlView.hidden = YES;
    self.fastView.hidden = YES;
    self.lockBtnbool = YES;
    self.volumeBrightnessView.hidden = YES;
    self.portraitControlView.hidden = self.player.isFullScreen;
    self.landScapeControlView.hidden = !self.player.isFullScreen;
    if (self.controlViewAppeared) {
        [self showControlViewWithAnimated:NO];
    } else {
        [self hideControlViewWithAnimated:NO];
    }
}

-(void)setVideoCount:(NSInteger)videoCount{
    _videoCount = videoCount;
    
    self.landScapeControlView.videoCount = _videoCount;
    self.portraitControlView.videoCount = _videoCount;
}

-(void)setCurrentPlayIndex:(NSInteger)currentPlayIndex{
    _currentPlayIndex = currentPlayIndex;
    
    self.landScapeControlView.currentPlayIndex = _currentPlayIndex;
    self.portraitControlView.currentPlayIndex = _currentPlayIndex;
}

/// 设置标题、封面、全屏模式
- (void)showTitle:(NSString *)title coverURLString:(NSString *)coverUrl fullScreenMode:(FullScreenMode)fullScreenMode {
    
    [self showTitle:title coverURLString:coverUrl placeholderImage:[UIImage imageNamed:@""] fullScreenMode:fullScreenMode];
}

/// 设置标题、封面、默认占位图、全屏模式
- (void)showTitle:(NSString *)title coverURLString:(NSString *)coverUrl placeholderImage:(UIImage *)placeholder fullScreenMode:(FullScreenMode)fullScreenMode {
    [self resetControlView];
    [self layoutIfNeeded];
    [self setNeedsDisplay];
    [self.portraitControlView showTitle:title fullScreenMode:fullScreenMode];
    [self.landScapeControlView showTitle:title fullScreenMode:fullScreenMode];
    [self.coverImageView tfy_setImageWithURLString:coverUrl placeholder:placeholder];
    [self.bgImgView tfy_setImageWithURLString:coverUrl placeholder:placeholder];
    if (self.prepareShowControlView) {
        [self showControlViewWithAnimated:NO];
    } else {
        [self hideControlViewWithAnimated:NO];
    }
}

/// 设置标题、UIImage封面、全屏模式
- (void)showTitle:(NSString *)title coverImage:(UIImage *)image fullScreenMode:(FullScreenMode)fullScreenMode {
    [self resetControlView];
    [self layoutIfNeeded];
    [self setNeedsDisplay];
    [self.portraitControlView showTitle:title fullScreenMode:fullScreenMode];
    [self.landScapeControlView showTitle:title fullScreenMode:fullScreenMode];
    self.coverImageView.image = image;
    self.bgImgView.image = image;
    if (self.prepareShowControlView) {
        [self showControlViewWithAnimated:NO];
    } else {
        [self hideControlViewWithAnimated:NO];
    }
}

/// 音量改变的通知
- (void)volumeChanged:(NSNotification *)notification {
    float volume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    if (self.player.isFullScreen) {
        [self.volumeBrightnessView updateProgress:volume withVolumeBrightnessType:VolumeBrightnessTypeVolume];
    } else {
        [self.volumeBrightnessView addSystemVolumeView];
    }
}
/// 取消延时隐藏controlView的方法
- (void)cancelAutoFadeOutControlView {
    if (self.afterBlock) {
        dispatch_block_cancel(self.afterBlock);
        self.afterBlock = nil;
    }
}

- (void)autoFadeOutControlView {
    self.controlViewAppeared = YES;
    [self cancelAutoFadeOutControlView];
    TFY_PLAYER_WS(myself);
    self.afterBlock = dispatch_block_create(0, ^{
        [myself hideControlViewWithAnimated:YES];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.autoHiddenTimeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(),self.afterBlock);
}

/// 隐藏控制层
- (void)hideControlViewWithAnimated:(BOOL)animated {
    self.controlViewAppeared = NO;
    if (self.controlViewAppearedCallback) {
        self.controlViewAppearedCallback(NO);
    }
    [UIView animateWithDuration:animated ? self.autoFadeTimeInterval : 0 animations:^{
        if (self.player.isFullScreen) {
            [self.landScapeControlView hideControlView];
        } else {
            if (!self.player.isSmallFloatViewShow) {
                [self.portraitControlView hideControlView];
            }
        }
    } completion:^(BOOL finished) {
        self.bottomPgrogress.hidden = NO;
    }];
}

/// 显示控制层
- (void)showControlViewWithAnimated:(BOOL)animated {
    self.controlViewAppeared = YES;
    if (self.controlViewAppearedCallback) {
        self.controlViewAppearedCallback(YES);
    }
    [self autoFadeOutControlView];
    [UIView animateWithDuration:animated ? self.autoFadeTimeInterval : 0 animations:^{
        if (self.player.isFullScreen) {
            [self.landScapeControlView showControlView];
        } else {
            if (!self.player.isSmallFloatViewShow) {
                [self.portraitControlView showControlView];
            }
        }
    } completion:^(BOOL finished) {
        self.bottomPgrogress.hidden = YES;
    }];
}


#pragma PlayerControlViewDelegate 代理

/// 手势筛选，返回NO不响应该手势
-(BOOL)gestureTriggerCondition:(TFY_PlayerGestureControl *)gestureControl gestureType:(PlayerGestureType)gestureType gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer touch:(UITouch *)touch{
    CGPoint point = [touch locationInView:self];
    if (self.player.isSmallFloatViewShow && !self.player.isFullScreen && gestureType != PlayerGestureTypeSingleTap) {
        return NO;
    }
    if (self.player.isFullScreen) {
        if (!self.customDisablePanMovingDirection) {
            //不禁用滑动方向
            self.player.disablePanMovingDirection = PlayerDisableGestureTypesNone;
        }
        return [self.landScapeControlView shouldResponseGestureWithPoint:point withGestureType:gestureType touch:touch];
    }
    else{
        if (!self.customDisablePanMovingDirection) {
            if (self.player.scrollView) {// 列表时候禁止左右滑动
                self.player.disablePanMovingDirection = PlayerDisablePanMovingDirectionVertical;
            }
            else{//不禁用滑动方向
                self.player.disablePanMovingDirection = PlayerDisablePanMovingDirectionNone;
            }
        }
        return [self.portraitControlView shouldResponseGestureWithPoint:point withGestureType:gestureType touch:touch];
    }
}
// 单击手势事件
-(void)gestureSingleTapped:(TFY_PlayerGestureControl *)gestureControl{
    
    if (!self.player) {
        return;
    }
    if (self.player.isSmallFloatViewShow && !self.player.isFullScreen) {
        [self.player enterFullScreen:YES animated:YES];
    }
    else{
        if (self.controlViewAppeared) {
            [self hideControlViewWithAnimated:YES];
        }
        else{
            /// 显示之前先把控制层复位，先隐藏后显示
            [self hideControlViewWithAnimated:NO];
            [self showControlViewWithAnimated:YES];
            
        }
    }
}
/// 双击手势事件
-(void)gestureDoubleTapped:(TFY_PlayerGestureControl *)gestureControl{
    self.lockBtnbool = !self.lockBtnbool;
    if (!self.player.isFullScreen) {
        [self.landScapeControlView controlBarSetPlayerPlay:self.lockBtnbool];
    }
    else{
        [self.portraitControlView controlBarSetPlayerPlay:self.lockBtnbool];
    }
}

/// 开始滑动手势事件
-(void)gestureBeganPan:(TFY_PlayerGestureControl *)gestureControl panDirection:(PanDirection)direction panLocation:(PanLocation)location{
    if (direction == PanDirectionH) {
        self.sumTime = self.player.currentTime;
    }
}

/// 滑动中手势事件
-(void)gestureChangedPan:(TFY_PlayerGestureControl *)gestureControl panDirection:(PanDirection)direction panLocation:(PanLocation)location withVelocity:(CGPoint)velocity{
    if (direction == PanDirectionH) {
        // 每次滑动需要叠加时间
        self.sumTime += velocity.x / 100;
        // 需要限定sumTime的范围
        NSTimeInterval totalMovieDuration = self.player.totalTime;
        if (totalMovieDuration == 0) return;
        if (self.sumTime > totalMovieDuration) self.sumTime = totalMovieDuration;
        if (self.sumTime < 0) self.sumTime = 0;
        BOOL style = NO;
        if (velocity.x > 0) style = YES;
        if (velocity.x < 0) style = NO;
        if (velocity.x == 0) return;
        [self sliderValueChangingValue:self.sumTime/totalMovieDuration isForward:style];
    }
    else if (direction == PanDirectionV){
        if (location == PanLocationLeft) { /// 调节亮度
            self.player.brightness -= (velocity.y) / 10000;
            [self.volumeBrightnessView updateProgress:self.player.brightness withVolumeBrightnessType:VolumeBrightnessTypeumeBrightness];
        } else if (location == PanLocationRight) { /// 调节声音
            self.player.volume -= (velocity.y) / 10000;
            if (self.player.isFullScreen) {
                [self.volumeBrightnessView updateProgress:self.player.volume withVolumeBrightnessType:VolumeBrightnessTypeVolume];
            }
        }
    }
}

- (void)sliderValueChangingValue:(CGFloat)value isForward:(BOOL)forward {
    if (self.horizontalPanShowControlView) {
        /// 显示控制层
        [self showControlViewWithAnimated:NO];
        [self cancelAutoFadeOutControlView];
    }
    
    self.fastView.value = value;
    self.fastView.fasttype = Progress_fast;
    self.fastView.hidden = NO;
    
    [self.fastView draggedTime:self.player.totalTime*value totalTime:self.player.totalTime IsForward:forward];
    /// 更新滑杆
    [self.portraitControlView sliderValueChanged:value currentTimeString:self.player.totalTime*value];
    [self.landScapeControlView sliderValueChanged:value currentTimeString:self.player.totalTime*value];
    
}

/// 滑动结束手势事件
-(void)gestureEndedPan:(TFY_PlayerGestureControl *)gestureControl panDirection:(PanDirection)direction panLocation:(PanLocation)location{
    TFY_PLAYER_WS(myself);
    if (direction == PanDirectionH && self.sumTime >= 0 && self.player.totalTime > 0) {
        [self.player seekToTime:self.sumTime completionHandler:^(BOOL finished) {
            /// 左右滑动调节播放进度
            [myself.portraitControlView sliderChangeEnded];
            [myself.landScapeControlView sliderChangeEnded];
            self.fastView.hidden = YES;
            if (myself.controlViewAppeared) {
                [myself autoFadeOutControlView];
            }
        }];
        if (self.seekToPlay) {
            [self.player.currentPlayerManager play];
        }
        self.sumTime = 0;
    }
}

/// 捏合手势事件，这里改变了视频的填充模式
-(void)gesturePinched:(TFY_PlayerGestureControl *)gestureControl scale:(float)scale{
    if (scale > 1) {
        self.player.currentPlayerManager.scalingMode = PlayerScalingModeAspectFill;
    } else {
        self.player.currentPlayerManager.scalingMode = PlayerScalingModeAspectFit;
    }
}

/// 准备播放
-(void)videoPlayer:(TFY_PlayerController *)videoPlayer prepareToPlay:(NSString *)assetURL{
    [self.fastView startAnimating];
    [self hideControlViewWithAnimated:NO];
    self.fastView.hidden = YES;
}

/// 播放状态改变
-(void)videoPlayer:(TFY_PlayerController *)videoPlayer playStateChanged:(PlayerPlaybackState)state{
    if (state == PlayerPlayStatePlaying) {
        [self.portraitControlView playBtnSelectedState:YES];
        [self.landScapeControlView playBtnSelectedState:YES];
        
        /// 开始播放时候判断是否显示loading
        if (videoPlayer.currentPlayerManager.loadState == PlayerLoadStateStalled && !self.prepareShowLoading) {
            [self.fastView startAnimating];
        }
        else if ((videoPlayer.currentPlayerManager.loadState == PlayerLoadStateStalled || videoPlayer.currentPlayerManager.loadState == PlayerLoadStatePrepare) && self.prepareShowLoading) {
            [self.fastView startAnimating];
        }
    }
    else if (state == PlayerPlayStatePaused){
        [self.portraitControlView playBtnSelectedState:NO];
        [self.landScapeControlView playBtnSelectedState:NO];
        /// 暂停的时候隐藏loading
        [self.fastView stopAnimating];
    }
    else if (state == PlayerPlayStatePlayFailed) {
        [self.fastView stopAnimating];
    }
}
/// 加载状态改变
-(void)videoPlayer:(TFY_PlayerController *)videoPlayer loadStateChanged:(PlayerLoadState)state{
    if (state == PlayerLoadStatePrepare) {
        self.coverImageView.hidden = NO;
        [self.portraitControlView playBtnSelectedState:videoPlayer.currentPlayerManager.shouldAutoPlay];
        [self.landScapeControlView playBtnSelectedState:videoPlayer.currentPlayerManager.shouldAutoPlay];
    }
    else if (state == PlayerLoadStatePlaythroughOK || state == PlayerLoadStatePlayable){
        self.coverImageView.hidden = YES;
        if (self.effectViewShow) {
            self.effectView.hidden = NO;
        }
        else{
            self.effectView.hidden = YES;
            self.player.currentPlayerManager.view.backgroundColor = [UIColor blackColor];
        }
    }
    if (state == PlayerLoadStateStalled && videoPlayer.currentPlayerManager.isPlaying && !self.prepareShowLoading) {
        [self.fastView startAnimating];
    }
    else if ((state == PlayerLoadStateStalled || state == PlayerLoadStatePrepare) && videoPlayer.currentPlayerManager.isPlaying && self.prepareShowLoading) {
        [self.fastView startAnimating];
    } else {
        [self.fastView stopAnimating];
    }
}

/// 播放进度改变回调
-(void)videoPlayer:(TFY_PlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime{
    [self.portraitControlView videoPlayer:videoPlayer currentTime:currentTime totalTime:totalTime];
    [self.landScapeControlView videoPlayer:videoPlayer currentTime:currentTime totalTime:totalTime];
    self.bottomPgrogress.value = videoPlayer.progress;
}

/// 缓冲改变回调
-(void)videoPlayer:(TFY_PlayerController *)videoPlayer bufferTime:(NSTimeInterval)bufferTime{
    [self.portraitControlView videoPlayer:videoPlayer bufferTime:bufferTime];
    [self.landScapeControlView videoPlayer:videoPlayer bufferTime:bufferTime];
    self.bottomPgrogress.bufferValue = videoPlayer.bufferProgress;
}
- (void)videoPlayer:(TFY_PlayerController *)videoPlayer presentationSizeChanged:(CGSize)size {
    [self.landScapeControlView videoPlayer:videoPlayer presentationSizeChanged:size];
}

/// 视频view即将旋转
- (void)videoPlayer:(TFY_PlayerController *)videoPlayer orientationWillChange:(TFY_OrientationObserver *)observer{
    self.statusBar.hidden = self.portraitControlView.hidden = observer.isFullScreen;
    self.landScapeControlView.hidden = !observer.isFullScreen;
    [self.portraitControlView fullScreenMode:observer.isFullScreen VideoCount:self.videoCount];
    [self.landScapeControlView fullScreenMode:observer.isFullScreen VideoCount:self.videoCount];
    if (videoPlayer.isSmallFloatViewShow) {
        self.floatControlView.hidden = observer.isFullScreen;
        self.portraitControlView.hidden = YES;
        if (observer.isFullScreen) {
            self.controlViewAppeared = NO;
            [self cancelAutoFadeOutControlView];
        }
    }
    if (self.controlViewAppeared) {
        [self showControlViewWithAnimated:NO];
    }
    else{
        [self hideControlViewWithAnimated:NO];
    }
    
    if (observer.isFullScreen) {
        [self.volumeBrightnessView removeSystemVolumeView];
    }
    else{
        [self.volumeBrightnessView addSystemVolumeView];
    }
}

/// 视频view已经旋转
- (void)videoPlayer:(TFY_PlayerController *)videoPlayer orientationDidChanged:(TFY_OrientationObserver *)observer {
    if (self.controlViewAppeared) {
        [self showControlViewWithAnimated:NO];
    } else {
        [self hideControlViewWithAnimated:NO];
    }
}

/// 锁定旋转方向
- (void)lockedVideoPlayer:(TFY_PlayerController *)videoPlayer lockedScreen:(BOOL)locked {
    [self showControlViewWithAnimated:YES];
}

/// 列表滑动时视频view已经显示
- (void)playerDidAppearInScrollView:(TFY_PlayerController *)videoPlayer {
    if (!self.player.stopWhileNotVisible && !videoPlayer.isFullScreen) {
        self.floatControlView.hidden = YES;
        self.portraitControlView.hidden = NO;
    }
}
/// 列表滑动时视频view已经消失
- (void)playerDidDisappearInScrollView:(TFY_PlayerController *)videoPlayer {
    if (!self.player.stopWhileNotVisible && !videoPlayer.isFullScreen) {
        self.floatControlView.hidden = NO;
        self.portraitControlView.hidden = YES;
    }
}

- (void)videoPlayer:(TFY_PlayerController *)videoPlayer floatViewShow:(BOOL)show {
    self.floatControlView.hidden = !show;
    self.portraitControlView.hidden = show;
}
#pragma 懒加载


-(void)setPlayer:(TFY_PlayerController *)player{
    _player = player;
    self.landScapeControlView.player = _player;
    self.portraitControlView.player = _player;
    /// 解决播放时候黑屏闪一下问题
    [_player.currentPlayerManager.view insertSubview:self.bgImgView atIndex:0];
    [self.bgImgView addSubview:self.effectView];
    [_player.currentPlayerManager.view insertSubview:self.coverImageView atIndex:1];
    self.coverImageView.frame = _player.currentPlayerManager.view.bounds;
    self.coverImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.bgImgView.frame = _player.currentPlayerManager.view.bounds;
    self.bgImgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.effectView.frame = self.bgImgView.bounds;
    self.coverImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

-(void)setSeekToPlay:(BOOL)seekToPlay{
    _seekToPlay = seekToPlay;
    self.portraitControlView.seekToPlay = _seekToPlay;
    self.landScapeControlView.seekToPlay = _seekToPlay;
}

- (void)setEffectViewShow:(BOOL)effectViewShow {
    _effectViewShow = effectViewShow;
    if (_effectViewShow) {
        self.bgImgView.hidden = NO;
    } else {
        self.bgImgView.hidden = YES;
    }
}

-(TFY_PortraitControlView *)portraitControlView{
    if (!_portraitControlView) {
        _portraitControlView = [TFY_PortraitControlView new];
        TFY_PLAYER_WS(myself);
        _portraitControlView.sliderValueChanging = ^(CGFloat value, BOOL forward) {
            [myself cancelAutoFadeOutControlView];
        };
        _portraitControlView.sliderValueChanged = ^(CGFloat value) {
            [myself autoFadeOutControlView];
        };
        _portraitControlView.backBtnClickCallback = ^{//返回
            if (myself.backBtnClickCallback) {
                myself.backBtnClickCallback();
            }
        };
    }
    return _portraitControlView;
}


-(TFY_LandScapeControlView *)landScapeControlView{
    if (!_landScapeControlView) {
        _landScapeControlView = [TFY_LandScapeControlView new];
        TFY_PLAYER_WS(myself);
        _landScapeControlView.sliderValueChanging = ^(CGFloat value, BOOL forward) {
            [myself cancelAutoFadeOutControlView];
        };
        _landScapeControlView.sliderValueChanged = ^(CGFloat value) {
            [myself autoFadeOutControlView];
        };
    }
    return _landScapeControlView;
}

-(TFY_fastView *)fastView{
    if (!_fastView) {
        _fastView = [TFY_fastView new];
        _fastView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _fastView.layer.cornerRadius = 4;
        _fastView.layer.masksToBounds = YES;
        
    }
    return _fastView;
}

-(TFY_VolumeBrightnessView *)volumeBrightnessView{
    if (!_volumeBrightnessView) {
        _volumeBrightnessView = [TFY_VolumeBrightnessView new];
        _volumeBrightnessView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    }
    return _volumeBrightnessView;
}

-(TFY_SmallFloatControlView *)floatControlView{
    if (!_floatControlView) {
        _floatControlView = [TFY_SmallFloatControlView new];
         TFY_PLAYER_WS(myself);
        _floatControlView.closeClickCallback = ^{
            if (myself.player.containerType == PlayerContainerTypeCell) {
                [myself.player stopCurrentPlayingCell];
            } else if (myself.player.containerType == PlayerContainerTypeView) {
                [myself.player stopCurrentPlayingView];
            }
            [myself resetControlView];
        };
    }
    return _floatControlView;
}

-(TFY_SliderView *)bottomPgrogress{
    if (!_bottomPgrogress) {
        _bottomPgrogress = [TFY_SliderView new];
        _bottomPgrogress.maximumTrackTintColor = [UIColor clearColor];
        _bottomPgrogress.minimumTrackTintColor = [UIColor whiteColor];
        _bottomPgrogress.bufferTrackTintColor  = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _bottomPgrogress.sliderHeight = 1;
        _bottomPgrogress.isHideSliderBlock = NO;
    }
    return _bottomPgrogress;
}
- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coverImageView;
}
- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.userInteractionEnabled = YES;
    }
    return _bgImgView;
}
- (UIView *)effectView {
    if (!_effectView) {
        if (@available(iOS 8.0, *)) {
            UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        } else {
            UIToolbar *effectView = [[UIToolbar alloc] init];
            effectView.barStyle = UIBarStyleBlackTranslucent;
            _effectView = effectView;
        }
    }
    return _effectView;
}

-(UIView *)statusBar{
    if (!_statusBar) {
        
        if (@available(iOS 13.0, *)) {
            UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager;
            if ([statusBarManager respondsToSelector:@selector(createLocalStatusBar)]) {
                UIView *_localStatusBar = [statusBarManager performSelector:@selector(createLocalStatusBar)];
                if ([_localStatusBar respondsToSelector:@selector(statusBar)]) {
                    _statusBar = [_localStatusBar performSelector:@selector(statusBar)];
                }
            }
        } else {
            // Fallback on earlier versions
            _statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        }
        
    }
    return _statusBar;
}
-(void)createLocalStatusBar{}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    [self cancelAutoFadeOutControlView];
}
@end
