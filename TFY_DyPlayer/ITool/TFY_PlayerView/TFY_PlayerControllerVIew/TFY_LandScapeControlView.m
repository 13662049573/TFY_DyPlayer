//
//  TFY_LandScapeControlView.m
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/7/2.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_LandScapeControlView.h"
#import "TFY_SliderView.h"
#import "TFY_RightView.h"
#import "TFY_SpeedView.h"
#import "TFY_PicturevideoView.h"
#import "TFY_BarragekeyboardManager.h"
#import "TFY_DanMuManager.h"
#define LandScape_WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface TFY_LandScapeControlView ()<bottomToolDelegate,PlayerTopBarDelegate,TFY_RightDelegate,ChatBoxDelegate>
/// 顶部工具栏
@property (nonatomic, strong) TFY_PlayerTopBar *toptoolView;
/// 底部工具栏
@property (nonatomic, strong) TFY_bottomToolView *bottomToolView;
/**
 *  拍照裁剪工具
 */
@property (nonatomic, strong) TFY_PhotocroppingView *photocroppiingView;
/**
 *  选集模型View
 */
@property(nonatomic , strong)TFY_RightView *right_View;
//倍速
@property(nonatomic , strong)TFY_SpeedView *speedView;
//截取当前视频图片
@property(nonatomic , strong)TFY_PicturevideoView *picturevideView;
//键盘
@property(nonatomic , strong)TFY_BarragekeyboardManager *keyboardmanger;
/// 锁定屏幕按钮
@property (nonatomic, strong) UIButton *lockBtn;

@end

@implementation TFY_LandScapeControlView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.photocroppiingView];
        self.photocroppiingView.tfy_RightSpace(-80).tfy_TopSpace(0).tfy_BottomSpace(0).tfy_Width(80);
        
        [self addSubview:self.toptoolView];
        self.toptoolView.tfy_LeftSpace(0).tfy_TopSpace(0).tfy_RightSpace(0).tfy_Height(50);
        
        [self addSubview:self.bottomToolView];
        self.bottomToolView.tfy_LeftSpace(0).tfy_BottomSpace(0).tfy_RightSpace(0).tfy_Height(50);
        
        [self addSubview:self.lockBtn];
        self.lockBtn.tfy_LeftSpace(25).tfy_CenterY(0).tfy_size(40, 40);
        
        [self addSubview:self.right_View];
        self.right_View.tfy_RightSpace(-TFY_PLAYER_ScreenW/2).tfy_TopSpace(0).tfy_BottomSpace(0).tfy_Width(TFY_PLAYER_ScreenW/2);
        
        [self addSubview:self.speedView];
        self.speedView.tfy_LeftSpace(0).tfy_TopSpace(-50).tfy_RightSpace(0).tfy_Height(50);
        
        [self addSubview:self.picturevideView];
        [self.picturevideView tfy_AutoSize:0 top:0 right:0 bottom:0];
        
        [self addSubview:self.keyboardmanger];
        
        
        [self resetControlView];
    }
    return self;
}

-(void)setVideoCount:(NSInteger)videoCount{
    _videoCount = videoCount;
    
    self.right_View.index = _videoCount;
}


-(void)setCurrentPlayIndex:(NSInteger)currentPlayIndex{
    _currentPlayIndex = currentPlayIndex;
    
    self.right_View.arrcount = _currentPlayIndex;
}

/**
 * 小窗口点击集数
 */
-(void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.player playTheIndex:indexPath.row];
}

#pragma mark - SliderViewDelegate

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
    self.bottomToolView.currentTime =self.player.totalTime*value;
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

/**
 * 选集
 */
-(void)selectionplayer:(BOOL)selection{
    self.bottomToolView.rightbool = selection;
    selection?self.right_View.tfy_RightSpace(0):self.right_View.tfy_RightSpace(-TFY_PLAYER_ScreenW/2);
    
    [UIView animateWithDuration:0.5 animations:^{
        [self layoutIfNeeded];
    }];
    
}

/**
 *  下一集
 */
-(void)nextbtnplayer{
    [self.player playTheNext];
}

/**
 *  倍速点击回调
 */
-(void)doublespeed_btnClick:(BOOL)speed{
    self.bottomToolView.speed_btn.selected = speed;
    speed?self.speedView.tfy_TopSpace(0):self.speedView.tfy_TopSpace(-50);
    speed?self.toptoolView.tfy_TopSpace(-50):self.toptoolView.tfy_TopSpace(0);
    
    [UIView animateWithDuration:0.5 animations:^{
        [self layoutIfNeeded];
    }];
}



-(void)setRightbool:(BOOL)rightbool{
    _rightbool = rightbool;
    
    self.bottomToolView.rightbool = _rightbool;
}

/**
 *  弹幕输入点击输回调
 */
-(void)barrage_inputboxClick{
    [self.keyboardmanger popToolbar];
}



/// 重置ControlView
- (void)resetControlView {
    self.bottomToolView.totalTime = self.bottomToolView.currentTime = self.bottomToolView.slider.bufferValue = self.bottomToolView.slider.value = 0;
    self.backgroundColor             = [UIColor clearColor];
    self.bottomToolView.selected     = YES;
    self.toptoolView.title_string             = @"";
    self.bottomToolView.alpha = self.toptoolView.alpha = 1;
}


- (void)showControlView {
    self.lockBtn.alpha               = 1;
    if (self.player.isLockedScreen) {
        self.toptoolView.tfy_TopSpace(-50);
        self.bottomToolView.tfy_BottomSpace(-50);
        self.photocroppiingView.tfy_RightSpace(-80);
        self.photocroppiingView.alpha = self.bottomToolView.alpha = self.toptoolView.alpha = 0;
    } else {
        self.toptoolView.tfy_TopSpace(0);
        self.bottomToolView.tfy_BottomSpace(0);
        self.photocroppiingView.tfy_RightSpace(0);
        self.photocroppiingView.alpha = self.bottomToolView.alpha = self.toptoolView.alpha = 1;
    }
    self.lockBtn.tfy_LeftSpace(25);
    self.player.statusBarHidden      = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self layoutIfNeeded];
    }];
}
- (void)hideControlView {
    self.toptoolView.tfy_TopSpace(-50);
    self.bottomToolView.tfy_BottomSpace(-50);
    self.photocroppiingView.tfy_RightSpace(-80);
    self.lockBtn.tfy_LeftSpace(-70);
    self.player.statusBarHidden      = YES;
    self.lockBtn.alpha = self.bottomToolView.alpha = self.toptoolView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        [self layoutIfNeeded];
    }];
}

-(BOOL)shouldResponseGestureWithPoint:(CGPoint)point withGestureType:(PlayerGestureType)type touch:(UITouch *)touch{
    CGRect sliderRect = [self.bottomToolView convertRect:self.bottomToolView.slider.frame toView:self];
    CGRect rightViews = [self.right_View convertRect:self.right_View.collectionView.frame toView:self];
    CGRect photocViews = [self.photocroppiingView convertRect:self.photocroppiingView.back_View.frame toView:self];
    CGRect lockViews = [self convertRect:self.lockBtn.frame toView:self];
    if (CGRectContainsPoint(sliderRect, point) || CGRectContainsPoint(rightViews, point) || CGRectContainsPoint(photocViews, point) || CGRectContainsPoint(lockViews, point)) {
        return NO;
    }
    if (self.player.isLockedScreen && type != PlayerGestureTypeSingleTap) {// 锁定屏幕方向后只相应tap手势
        return NO;
    }
    [self doublespeed_btnClick:NO];
    [self selectionplayer:NO];
//    [self.keyboardmanger bounceToolbar];
    return YES;
}

-(void)videoPlayer:(TFY_PlayerController *)videoPlayer presentationSizeChanged:(CGSize)size{
    self.lockBtn.hidden = self.player.orientationObserver.fullScreenMode == FullScreenModePortrait;
}

-(void)videoPlayer:(TFY_PlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime{
    if (!self.bottomToolView.slider.isdragging) {
        self.bottomToolView.currentTime = currentTime;
        self.bottomToolView.totalTime = totalTime;
        self.bottomToolView.slider.value = videoPlayer.progress;
    }
}

-(void)videoPlayer:(TFY_PlayerController *)videoPlayer bufferTime:(NSTimeInterval)bufferTime{
    self.bottomToolView.slider.bufferValue = videoPlayer.bufferProgress;
}

-(void)showTitle:(NSString *)title fullScreenMode:(FullScreenMode)fullScreenMode{
    self.toptoolView.title_string = title;
    self.player.orientationObserver.fullScreenMode = fullScreenMode;
    self.lockBtn.hidden = fullScreenMode == FullScreenModePortrait;
}
/**
 *  判断是不是全屏
 */
-(void)fullScreenMode:(BOOL)fullScreenMode VideoCount:(NSInteger)count{
    [self selectionplayer:NO];
    [self doublespeed_btnClick:NO];
    [self.bottomToolView fullScreenMode:fullScreenMode VideoCount:count];
}
//调节播放进度slider和当前时间更新
-(void)sliderValueChanged:(CGFloat)value currentTimeString:(NSTimeInterval)timeString{
    self.bottomToolView.slider.value = value;
    self.bottomToolView.currentTime = timeString;
    self.bottomToolView.slider.isdragging = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomToolView.slider.sliderBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
}

//滑杆结束滑动
-(void)sliderChangeEnded{
    self.bottomToolView.slider.isdragging = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomToolView.slider.sliderBtn.transform = CGAffineTransformIdentity;
    }];
}

- (void)playBtnSelectedState:(BOOL)selected {
    self.bottomToolView.selected = selected;
}

- (void)lockButtonClickAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.player.lockedScreen = sender.selected;
}

/**
 *  返回按钮
 */
-(void)topBarBackBtnClicked{
    self.lockBtn.selected = NO;
    self.player.lockedScreen = NO;
    self.lockBtn.selected = NO;
    if (self.player.orientationObserver.supportInterfaceOrientation & InterfaceOrientationMaskPortrait) {
        [self.player enterFullScreen:NO animated:YES];
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
    [self.player enterFullScreen:NO animated:YES];
}
#pragma 懒加载

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
-(TFY_RightView *)right_View{
    if (!_right_View) {
        _right_View = [TFY_RightView new];
        _right_View.delegate = self;
    }
    return _right_View;
}

-(TFY_PhotocroppingView *)photocroppiingView{
    if (!_photocroppiingView) {
        _photocroppiingView = [TFY_PhotocroppingView new];
        TFY_PLAYER_WS(myself);
        _photocroppiingView.PhotoBlock = ^{//获取当前视频照片
            myself.picturevideView.hidden = NO;
            UIImage *images = [myself.player.currentPlayerManager thumbnailImageAtCurrentTime];
            if ([images isKindOfClass:[UIImage class]]) {
                myself.picturevideView.thumeimage = images;
                [myself.player.currentPlayerManager pause];
            }
        };
        _photocroppiingView.croppingBlock = ^{//截取当前一段视频
            
        };
    }
    return _photocroppiingView;
}

-(TFY_PicturevideoView *)picturevideView{
    if (!_picturevideView) {
        _picturevideView = [TFY_PicturevideoView new];
        _picturevideView.hidden = YES;
        TFY_PLAYER_WS(myself);
        _picturevideView.picturevideoback = ^{
            [myself.player.currentPlayerManager play];
        };
    }
    return _picturevideView;
}


-(UIButton *)lockBtn{
    if (!_lockBtn) {
        _lockBtn = tfy_button();
        _lockBtn.tfy_image(@"videoImages.bundle/unlock-nor", UIControlStateNormal).tfy_image(@"videoImages.bundle/lock-nor", UIControlStateSelected).tfy_action(self, @selector(lockButtonClickAction:));
    }
    return _lockBtn;
}

-(TFY_SpeedView *)speedView{
    if (!_speedView) {
        _speedView = [TFY_SpeedView new];
        TFY_PLAYER_WS(myself);
        _speedView.Speekback = ^(CGFloat rate) {
            myself.player.rate = rate;
            myself.bottomToolView.speed_btn.tfy_text([NSString stringWithFormat:@"%.2fX",rate]);
        };
    }
    return _speedView;
}

-(TFY_BarragekeyboardManager *)keyboardmanger{
    if (!_keyboardmanger) {
        _keyboardmanger = [TFY_BarragekeyboardManager new];
        _keyboardmanger.delegate = self;
        _keyboardmanger.maxVisibleLine = 3;
    }
    return _keyboardmanger;
}

-(void)changeStatusChat:(CGFloat)chatBoxY{
    
}
-(void)chatBoxSendTextMessage:(NSString *)message{
    TFY_SubtitlepopupModel *models = [TFY_SubtitlepopupModel new];
    models.text = message;
    models.username = [TFY_CommonUtils getStrValueInUDWithKey:@"username"];
    models.type = 0;
    [TFY_DanMuManager addModel:models Heightarc4random:130 backView:self];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}


@end
