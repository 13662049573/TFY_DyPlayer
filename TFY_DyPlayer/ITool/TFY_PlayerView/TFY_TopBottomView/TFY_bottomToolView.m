//
//  TFY_bottomToolView.m
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/7/2.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_bottomToolView.h"

@interface TFY_bottomToolView ()<SliderViewDelegate>
/// 播放或暂停按钮  /// 全屏按钮
@property (nonatomic, strong) UIButton *playOrPauseBtn,*fullScreenBtn,*selection_btn,*nextbtn,*barrage_btn;
/// 播放的当前时间 视频总时间
@property (nonatomic, strong) UILabel *currentTimeLabel,*totalTimeLabel;
/// 滑杆
@property (nonatomic, strong) TFY_SliderView *slider;
//输入框
@property (nonatomic, strong) UIImageView *inputbox_imageView;
//弹幕是否开启
@property (nonatomic, assign) BOOL isbarragebool;
@end

@implementation TFY_bottomToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"videoImages.bundle/bottom_shadow"];
        self.layer.contents = (id)image.CGImage;
        
        [self addSubview:self.playOrPauseBtn];
        
        [self addSubview:self.currentTimeLabel];
        
        [self addSubview:self.fullScreenBtn];
        
        [self addSubview:self.totalTimeLabel];
        
        [self addSubview:self.slider];
        
        [self addSubview:self.selection_btn];
        
        [self addSubview:self.nextbtn];
        
        [self addSubview:self.speed_btn];
        
        [self addSubview:self.barrage_btn];
        
        [self addSubview:self.inputbox_imageView];
        // 更新小屏幕布局
        [self SmallscreenLayer];
        
        self.isbarragebool = YES;
    }
    return self;
}
/**
 *  小屏幕布局
 */
-(void)SmallscreenLayer{
    self.playOrPauseBtn.tfy_LeftSpace(10).tfy_CenterY(0).tfy_size(40, 40);
    
    self.currentTimeLabel.tfy_LeftSpaceToView(0, self.playOrPauseBtn).tfy_CenterY(0).tfy_size(55, 25);
    
    self.fullScreenBtn.tfy_RightSpace(10).tfy_CenterY(0).tfy_size(40, 40);
    
    self.totalTimeLabel.tfy_RightSpaceToView(5, self.fullScreenBtn).tfy_CenterY(0).tfy_size(55, 25);
    
    self.slider.tfy_LeftSpaceToView(5, self.currentTimeLabel).tfy_CenterY(0).tfy_RightSpaceToView(5, self.totalTimeLabel).tfy_Height(25);
    
    self.inputbox_imageView.hidden = self.barrage_btn.hidden = self.speed_btn.hidden = self.nextbtn.hidden = self.selection_btn.hidden = YES;
}
/**
 *  全屏幕布局
 */
-(void)fullscreenLayer{
    self.slider.tfy_LeftSpace(10).tfy_CenterY(-15).tfy_RightSpace(10);
    
    self.inputbox_imageView.hidden = self.barrage_btn.hidden = self.speed_btn.hidden = self.nextbtn.hidden = self.selection_btn.hidden = NO;
    
    self.selection_btn.tfy_RightSpaceToView(5, self.totalTimeLabel).tfy_CenterY(0).tfy_size(40, 30);
    
    self.nextbtn.tfy_LeftSpaceToView(5, self.currentTimeLabel).tfy_CenterY(0).tfy_size(10, 14.5);
    
    self.speed_btn.tfy_RightSpaceToView(5, self.selection_btn).tfy_CenterY(0).tfy_size(40, 30);
    
    self.barrage_btn.tfy_LeftSpaceToView(15, self.nextbtn).tfy_CenterY(0).tfy_size(32, 32);
    
    self.inputbox_imageView.tfy_LeftSpaceToView(5, self.barrage_btn).tfy_CenterY(0).tfy_size(64, 64);
}
-(void)setSelected:(BOOL)selected{
    _selected = selected;
    self.playOrPauseBtn.selected = _selected;
}


-(void)setCurrentTime:(NSTimeInterval)currentTime{
    _currentTime = currentTime;
    
    self.currentTimeLabel.tfy_text([TFY_CommonUtils convertSecond2Time:_currentTime]);
    
}

-(void)setTotalTime:(NSTimeInterval)totalTime{
    _totalTime = totalTime;
    
    self.totalTimeLabel.tfy_text([TFY_CommonUtils convertSecond2Time:_totalTime]);
}

/**
 *  判断是不是全屏
 */
-(void)fullScreenMode:(BOOL)fullScreenMode VideoCount:(NSInteger)count{
    if (fullScreenMode == YES && count > 1) {
        self.fullScreenBtn.selected = YES;
        [self fullscreenLayer];
    }
    else{
        self.fullScreenBtn.selected = NO;
        [self SmallscreenLayer];
    }
}

-(void)setRightbool:(BOOL)rightbool{
    _rightbool = rightbool;
    
    self.selection_btn.selected = _rightbool;
}

#pragma 滑块代理
/**
 *  滑块滑动开始
 */
- (void)sliderTouchBegan:(float)value{
    if ([self.delegate respondsToSelector:@selector(sliderTouchBegan:)]) {
        [self.delegate sliderTouchBegan:value];
    }
}
/**
 *  滑块滑动中
 */
- (void)sliderValueChanged:(float)value{
    if ([self.delegate respondsToSelector:@selector(sliderValueChanged)]) {
        [self.delegate sliderValueChanged:value];
    }
}
/**
 * 滑块滑动结束
 */
- (void)sliderTouchEnded:(float)value{
    if ([self.delegate respondsToSelector:@selector(sliderTouchEnded:)]) {
        [self.delegate sliderTouchEnded:value];
    }
}
/**
 *  滑杆点击
 */
- (void)sliderTapped:(float)value{
    if ([self.delegate respondsToSelector:@selector(sliderTapped:)]) {
        [self.delegate sliderTapped:value];
    }
}
//播放
-(void)player_btnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if ([self.delegate respondsToSelector:@selector(controlBarSetPlayerPlay:)]) {
        [self.delegate controlBarSetPlayerPlay:btn.selected];
    }
}

//全屏
-(void)fullscreen_btnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if ([self.delegate respondsToSelector:@selector(controlBarSetPlayerFullScreen:)]) {
        [self.delegate controlBarSetPlayerFullScreen:btn.selected];
    }
}

//选集
-(void)selection_btnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if ([self.delegate respondsToSelector:@selector(selectionplayer:)]) {
        [self.delegate selectionplayer:btn.selected];
    }
}
//下一集
-(void)nextbtnClick{
    if ([self.delegate respondsToSelector:@selector(nextbtnplayer)]) {
        [self.delegate nextbtnplayer];
    }
}
//倍速
-(void)doublespeed_btnClick:(UIButton*)btn{
    btn.selected = !btn.selected;
    if ([self.delegate respondsToSelector:@selector(doublespeed_btnClick:)]) {
        [self.delegate doublespeed_btnClick:btn.selected];
    }
}

//弹幕
-(void)barrage_btnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    self.isbarragebool = self.inputbox_imageView.hidden = btn.selected;
    self.inputbox_imageView.userInteractionEnabled = !btn.selected;
}

/**
 *  字符开始是否
 */
-(BOOL)barragebool{
    return self.isbarragebool;
}

//输入框
-(void)inputbox_btnClick{
    if ([self.delegate respondsToSelector:@selector(barrage_inputboxClick)]) {
        [self.delegate barrage_inputboxClick];
    }
}

-(UIButton *)playOrPauseBtn{
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = tfy_button();
        _playOrPauseBtn.tfy_image(@"videoImages.bundle/Stop", UIControlStateNormal).tfy_image(@"videoImages.bundle/bottom_window", UIControlStateSelected).tfy_action(self, @selector(player_btnClick:),UIControlEventTouchUpInside);
    }
    return _playOrPauseBtn;
}


-(UILabel *)currentTimeLabel{
    if (!_currentTimeLabel) {
        _currentTimeLabel = tfy_label();
        _currentTimeLabel.tfy_text(@"00:00").tfy_textcolor(@"ffffff", 1).tfy_fontSize([UIFont systemFontOfSize:13]).tfy_alignment(1).tfy_adjustsWidth(YES);
    }
    return _currentTimeLabel;
}
-(UILabel *)totalTimeLabel{
    if (!_totalTimeLabel) {
        _totalTimeLabel = tfy_label();
        _totalTimeLabel.tfy_text(@"00:00").tfy_textcolor(@"ffffff", 1).tfy_fontSize([UIFont systemFontOfSize:13]).tfy_alignment(1).tfy_adjustsWidth(YES);
    }
    return _totalTimeLabel;
}
-(UIButton *)fullScreenBtn{
    if (!_fullScreenBtn) {
        _fullScreenBtn = tfy_button();
        _fullScreenBtn.tfy_image(@"videoImages.bundle/btn_zoom_in", UIControlStateNormal).tfy_image(@"videoImages.bundle/btn_zoom_out", UIControlStateSelected).tfy_action(self, @selector(fullscreen_btnClick:),UIControlEventTouchUpInside);
        
    }
    return _fullScreenBtn;
}
-(UIButton *)selection_btn{
    if (!_selection_btn) {
        _selection_btn = tfy_button();
        _selection_btn.tfy_title(@"选集",UIControlStateNormal, @"ffffff",UIControlStateNormal, [UIFont systemFontOfSize:13]).tfy_action(self, @selector(selection_btnClick:),UIControlEventTouchUpInside);
    }
    return _selection_btn;
}

-(UIButton *)speed_btn{
    if (!_speed_btn) {
        _speed_btn = tfy_button();
        _speed_btn.tfy_title(@"倍速",UIControlStateNormal, @"ffffff",UIControlStateNormal, [UIFont systemFontOfSize:13]).tfy_action(self, @selector(doublespeed_btnClick:),UIControlEventTouchUpInside);
    }
    return _speed_btn;
}

-(UIButton *)nextbtn{
    if (!_nextbtn) {
        _nextbtn = tfy_button();
        _nextbtn.tfy_image(@"videoImages.bundle/btn_next_normal", UIControlStateNormal).tfy_action(self, @selector(nextbtnClick),UIControlEventTouchUpInside);
    }
    return _nextbtn;
}

-(UIButton *)barrage_btn{
    if (!_barrage_btn) {
        _barrage_btn = tfy_button();
        _barrage_btn.tfy_image(@"videoImages.bundle/barrageopening", UIControlStateNormal).tfy_image(@"videoImages.bundle/barrageoff", UIControlStateSelected).tfy_action(self, @selector(barrage_btnClick:),UIControlEventTouchUpInside);
    }
    return _barrage_btn;
}


-(UIImageView *)inputbox_imageView{
    if (!_inputbox_imageView) {
        _inputbox_imageView = tfy_imageView();
        UIImage *img = [UIImage imageNamed:@"videoImages.bundle/shurukuang"];
        // 四个数值对应图片中距离上、左、下、右边界的不拉伸部分的范围宽度
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
        _inputbox_imageView.image = img;
        _inputbox_imageView.tfy_action(self, @selector(inputbox_btnClick));
    }
    return _inputbox_imageView;
}

/**
 *  滑块
 */
-(TFY_SliderView *)slider{
    if (!_slider) {
        _slider = [TFY_SliderView new];
        _slider.delegate = self;
        _slider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
        _slider.bufferTrackTintColor  = [UIColor whiteColor];
        _slider.minimumTrackTintColor = [UIColor colorWithRed:0.95 green:0.59 blue:0.24 alpha:1.00];
        [_slider setThumbImage:[UIImage imageNamed:@"videoImages.bundle/thumb_light"] forState:UIControlStateNormal];
        _slider.sliderHeight = 2;
    }
    return _slider;
}
@end
