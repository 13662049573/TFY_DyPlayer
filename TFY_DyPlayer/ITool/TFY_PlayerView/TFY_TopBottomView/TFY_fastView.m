//
//  TFY_fastView.m
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/7/3.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_fastView.h"
#import "TFY_SpeedLoadingView.h"  //加载loading
#import "TFY_SliderView.h"

@interface TFY_fastView ()
@property (nonatomic, strong) UIView *fastView,*loodingView,*failView;
/// 快进快退进度progress
@property (nonatomic, strong) TFY_SliderView *fastProgressView;
/// 快进快退时间
@property (nonatomic, strong) UILabel *fastTimeLabel,*faillabel;
/// 快进快退ImageView
@property (nonatomic, strong) UIImageView *fastImageView;
/// 加载失败按钮
@property (nonatomic, strong) UIButton *failBtn;
//加载菊花
@property (nonatomic, strong) TFY_SpeedLoadingView *loadingView;
@end

@implementation TFY_fastView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.loodingView];
        [self.loodingView tfy_AutoSize:0 top:0 right:0 bottom:0];
        
        [self.loodingView addSubview:self.loadingView];
        self.loadingView.tfy_LeftSpace(0).tfy_TopSpace(0).tfy_RightSpace(0).tfy_RightSpace(0).tfy_BottomSpace(0);
        
        [self addSubview:self.fastView];
        [self.fastView tfy_AutoSize:0 top:0 right:0 bottom:0];
        
        [self.fastView addSubview:self.fastImageView];
        self.fastImageView.tfy_Center(0, -15).tfy_size(40, 40);
        
        [self.fastView addSubview:self.fastTimeLabel];
        self.fastTimeLabel.tfy_LeftSpace(10).tfy_TopSpaceToView(0, self.fastImageView).tfy_RightSpace(10).tfy_Height(25);
        
        [self addSubview:self.failView];
        [self.failView tfy_AutoSize:0 top:0 right:0 bottom:0];
        
        [self.failView addSubview:self.failBtn];
        self.failBtn.tfy_Center(0, -15).tfy_size(50, 50);
        
        [self.failView addSubview:self.faillabel];
        self.faillabel.tfy_LeftSpace(10).tfy_TopSpaceToView(0, self.failBtn).tfy_RightSpace(10).tfy_Height(25);
        
    }
    return self;
}

-(void)setFastViewAnimated:(BOOL)fastViewAnimated{
    _fastViewAnimated = fastViewAnimated;
}

-(void)setFaill_string:(NSString *)faill_string{
    _faill_string = faill_string;
    self.fasttype = Progress_fail;
    self.faillabel.tfy_text(_faill_string);
}

-(void)setValue:(CGFloat)value{
    _value = value;
    
    self.fastProgressView.value = _value;
}

/**
 * 快递滑动时间  视频总时间  快递 YES 快退 NO
 */
-(void)draggedTime:(CGFloat)draggedTime totalTime:(CGFloat)totalTime IsForward:(BOOL)isForward{
    self.fasttype = Progress_fast;
    
    self.fastTimeLabel.tfy_text([NSString stringWithFormat:@"%@/%@",[TFY_CommonUtils convertSecond2Time:draggedTime],[TFY_CommonUtils convertSecond2Time:totalTime]]);
    
    NSString *image = @"";
    if (isForward) {
        image = @"videoImages.bundle/fast_forward";
    }
    else{
        image = @"videoImages.bundle/fast_backward";
    }
    self.fastImageView.tfy_imge(image);
    
    [self performSelector:@selector(hideFastView) withObject:nil afterDelay:2.5];
    
    if (self.fastViewAnimated) {
        [UIView animateWithDuration:0.4 animations:^{
            self.fastView.transform = CGAffineTransformMakeTranslation(isForward?8:-8, 0);
        }];
    }
}
/// 隐藏快进视图
- (void)hideFastView {
    [UIView animateWithDuration:0.4 animations:^{
        self.fastView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.fastView.hidden = YES;
    }];
}

-(void)setFasttype:(fastState)fasttype{
    _fasttype = fasttype;
    switch (_fasttype) {
        case Progress_loading:
            self.loodingView.hidden = NO;
            self.failView.hidden = self.fastView.hidden = YES;
            break;
        case Progress_fast:
            self.fastView.hidden = NO;
            self.failView.hidden = self.loodingView.hidden = YES;
            [self stopAnimating];
            break;
        case Progress_fail:
            self.failView.hidden = NO;
            self.loodingView.hidden = self.fastView.hidden = YES;
            [self stopAnimating];
            break;
        default:
            break;
    }
}
/**
 *  开始菊花带网速监听
 */
- (void)startAnimating{
    self.fasttype = Progress_loading;
    [self.loadingView startAnimating];
}
/**
 *  结束菊花带网速监听
 */
- (void)stopAnimating{
    [self.loadingView stopAnimating];
}
//重播按钮返回
-(void)failBtn_btnClick{
    if (self.failblack) {
        self.failblack();
    }
}
#pragma 懒加载

-(TFY_SliderView *)fastProgressView{
    if (!_fastProgressView) {
        _fastProgressView = [TFY_SliderView new];
        _fastProgressView.maximumTrackTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
        _fastProgressView.minimumTrackTintColor = [UIColor whiteColor];
        _fastProgressView.sliderHeight = 2;
        _fastProgressView.isHideSliderBlock = NO;
        _fastProgressView.hidden = YES;
    }
    return _fastProgressView;
}

-(TFY_SpeedLoadingView *)loadingView{
    if (!_loadingView) {
        _loadingView = [TFY_SpeedLoadingView new];
    }
    return _loadingView;
}

-(UILabel *)fastTimeLabel{
    if (!_fastTimeLabel) {
        _fastTimeLabel = tfy_label();
        _fastTimeLabel.tfy_textcolor(@"ffffff", 1).tfy_fontSize(14).tfy_alignment(1).tfy_adjustsWidth(YES);
    }
    return _fastTimeLabel;
}

-(UILabel *)faillabel{
    if (!_faillabel) {
        _faillabel = tfy_label();
        _faillabel.tfy_textcolor(@"ffffff", 1).tfy_fontSize(14).tfy_alignment(1).tfy_adjustsWidth(YES);
    }
    return _faillabel;
}

-(UIImageView *)fastImageView{
    if (!_fastImageView) {
        _fastImageView = tfy_imageView();
        _fastImageView.userInteractionEnabled = YES;
    }
    return _fastImageView;
}

-(UIButton *)failBtn{
    if (!_failBtn) {
        _failBtn = tfy_button();
        _failBtn.tfy_image(@"videoImages.bundle/replay", UIControlStateNormal).tfy_action(self, @selector(failBtn_btnClick));
    }
    return _failBtn;
}

-(UIView *)fastView{
    if (!_fastView) {
        _fastView = [UIView new];
        _fastView.backgroundColor = [UIColor tfy_colorWith3DigitHex:@"000000" andAlpha:0.7];
        _fastView.hidden = YES;
    }
    return _fastView;
}

-(UIView *)loodingView{
    if (!_loodingView) {
        _loodingView = [UIView new];
        _loadingView.hidden = YES;
    }
    return _loodingView;
}

-(UIView *)failView{
    if (!_failView) {
        _failView = [UIView new];
        _failView.backgroundColor = [UIColor tfy_colorWith3DigitHex:@"000000" andAlpha:0.7];
        _failView.hidden = YES;
    }
    return _failView;
}
@end

