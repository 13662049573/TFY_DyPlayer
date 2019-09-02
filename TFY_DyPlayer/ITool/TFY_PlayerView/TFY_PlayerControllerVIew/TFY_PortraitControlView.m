//
//  TFY_PortraitControlView.m
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/7/3.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_PortraitControlView.h"

#define LandScape_WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface TFY_PortraitControlView ()<bottomToolDelegate,PlayerTopBarDelegate>
/**
 *  头部工具
 */
@property (nonatomic, strong) TFY_PlayerTopBar *toptoolView;
/**
 * 底部工具栏 |
 */
@property (nonatomic, strong) TFY_bottomToolView *bottomToolView;

@end

@implementation TFY_PortraitControlView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubvievLayout];
        
        [self resetControlView];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubvievLayout];
        
        [self resetControlView];
        
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)addSubvievLayout{
    [self addSubview:self.toptoolView];
    self.toptoolView.tfy_LeftSpace(0).tfy_TopSpace(0).tfy_RightSpace(0).tfy_Height(50);
    
    
    [self addSubview:self.bottomToolView];
    self.bottomToolView.tfy_LeftSpace(0).tfy_BottomSpace(0).tfy_RightSpace(0).tfy_Height(50);
}

/** 重置ControlView */
- (void)resetControlView {
    self.bottomToolView.alpha        = 1;
    self.bottomToolView.slider.value = self.bottomToolView.slider.bufferValue = self.bottomToolView.totalTime= self.bottomToolView.currentTime       = 0;
    
    self.backgroundColor             = [UIColor clearColor];
    self.bottomToolView.selected     = YES;
    self.toptoolView.title_string             = @"";
}

- (void)showControlView {
    self.bottomToolView.alpha = self.toptoolView.alpha = 1;
    self.toptoolView.tfy_TopSpace(0);
    self.bottomToolView.tfy_BottomSpace(0);
    self.player.statusBarHidden      = NO;
    [UIView animateWithDuration:0.5 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)hideControlView {
    self.toptoolView.tfy_TopSpace(-50);
    self.bottomToolView.tfy_BottomSpace(-50);
    self.player.statusBarHidden      = NO;
    self.bottomToolView.alpha = self.toptoolView.alpha  = 0;
    [UIView animateWithDuration:0.5 animations:^{
        [self layoutIfNeeded];
    }];
}


#pragma  代理实现

-(void)sliderTouchBegan:(float)value{
    self.bottomToolView.slider.isdragging = YES;
}

-(void)sliderTouchEnded:(float)value{
    if (self.player.totalTime > 0) {
        LandScape_WS(myself);
        [self.player seekToTime:self.player.totalTime*value completionHandler:^(BOOL finished) {
            if (finished) {
                myself.bottomToolView.slider.isdragging = NO;
            }
        }];
        if (self.seekToPlay) {
            [self.player.currentPlayerManager play];
        }
    }
    else{
        self.bottomToolView.slider.isdragging = NO;
    }
    if (self.sliderValueChanged) {
        self.sliderValueChanged(value);
    }
}

-(void)sliderValueChanged:(float)value{
    if (self.player.totalTime == 0) {
        self.bottomToolView.slider.value = 0;
        return;
    }
    self.bottomToolView.slider.isdragging = NO;
    self.bottomToolView.currentTime = self.player.totalTime*value;
    if (self.sliderValueChanging) {
        self.sliderValueChanging(value, self.bottomToolView.slider.isForward);
    }
}

-(void)sliderTapped:(float)value{
    if (self.player.totalTime > 0) {
        self.bottomToolView.slider.isdragging = YES;
        LandScape_WS(myself);
        [self.player seekToTime:self.player.totalTime*value completionHandler:^(BOOL finished) {
            if (finished) {
                myself.bottomToolView.slider.isdragging = NO;
                [myself.player.currentPlayerManager play];
            }
        }];
    }
    else{
        self.bottomToolView.slider.isdragging = NO;
        self.bottomToolView.slider.value =0;
    }
}

/**
 *  播放暂停返回
 */
-(void)controlBarSetPlayerPlay:(BOOL)play{
    if (play) {
        [self.player.currentPlayerManager play];
    }
    else{
        [self.player.currentPlayerManager pause];
    }
}

- (void)topBarBackBtnClicked {
    if (self.backBtnClickCallback) {
        self.backBtnClickCallback();
    }
}
/**
 * 分享
 */
-(void)report_btnClick{
    
}
/**
 *  屏幕全屏
 */
-(void)controlBarSetPlayerFullScreen:(BOOL)fullScreen{
    [self.player enterFullScreen:YES animated:YES];
}

-(void)setRightbool:(BOOL)rightbool{
    _rightbool = rightbool;
    
    self.bottomToolView.rightbool = _rightbool;
}

- (void)playBtnSelectedState:(BOOL)selected {
    self.bottomToolView.selected = selected;
}

- (BOOL)shouldResponseGestureWithPoint:(CGPoint)point withGestureType:(PlayerGestureType)type touch:(nonnull UITouch *)touch {
    CGRect sliderRect = [self.bottomToolView convertRect:self.bottomToolView.slider.frame toView:self];
    if (CGRectContainsPoint(sliderRect, point)) {
        return NO;
    }
    return YES;
}

- (void)videoPlayer:(TFY_PlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    if (!self.bottomToolView.slider.isdragging) {
        self.bottomToolView.currentTime = currentTime;
        self.bottomToolView.totalTime = totalTime;
        self.bottomToolView.slider.value = videoPlayer.progress;
    }
}

- (void)videoPlayer:(TFY_PlayerController *)videoPlayer bufferTime:(NSTimeInterval)bufferTime {
    self.bottomToolView.slider.bufferValue = videoPlayer.bufferProgress;
}

- (void)showTitle:(NSString *)title fullScreenMode:(FullScreenMode)fullScreenMode {
    self.toptoolView.title_string = title;
    self.player.orientationObserver.fullScreenMode = fullScreenMode;
}
/**
 *  判断是不是全屏
 */
-(void)fullScreenMode:(BOOL)fullScreenMode VideoCount:(NSInteger)count{
    [self.bottomToolView fullScreenMode:fullScreenMode VideoCount:count];
}
/// 调节播放进度slider和当前时间更新
- (void)sliderValueChanged:(CGFloat)value currentTimeString:(NSTimeInterval)timeString {
    self.bottomToolView.slider.value = value;
    self.bottomToolView.currentTime = timeString;
    self.bottomToolView.slider.isdragging = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomToolView.slider.sliderBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
}

/// 滑杆结束滑动
- (void)sliderChangeEnded {
    self.bottomToolView.slider.isdragging = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomToolView.slider.sliderBtn.transform = CGAffineTransformIdentity;
    }];
}



-(TFY_PlayerTopBar *)toptoolView{
    if (!_toptoolView) {
        _toptoolView = [TFY_PlayerTopBar new];
        _toptoolView.delegate = self;
    }
    return _toptoolView;
}

-(TFY_bottomToolView *)bottomToolView{
    if (!_bottomToolView) {
        _bottomToolView = [TFY_bottomToolView new];
        _bottomToolView.delegate = self;
    }
    return _bottomToolView;
}



@end
