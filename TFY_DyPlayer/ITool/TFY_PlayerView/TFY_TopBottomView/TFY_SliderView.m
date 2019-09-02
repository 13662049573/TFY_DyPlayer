//
//  TFY_SliderView.m
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/7/2.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_SliderView.h"

/** 滑块的大小 */
static const CGFloat kSliderBtnWH = 19.0;
/** 进度的高度 */
static const CGFloat kProgressH = 1.0;
/** 拖动slider动画的时间*/
static const CGFloat kAnimate = 0.3;

@implementation UIView (SliderFrame)

- (CGFloat)tfy_x {
    return self.frame.origin.x;
}

- (void)setTfy_x:(CGFloat)tfy_x {
    CGRect newFrame   = self.frame;
    newFrame.origin.x = tfy_x;
    self.frame        = newFrame;
}

- (CGFloat)tfy_y {
    return self.frame.origin.y;
}

- (void)setTfy_y:(CGFloat)tfy_y {
    CGRect newFrame   = self.frame;
    newFrame.origin.y = tfy_y;
    self.frame        = newFrame;
}

- (CGFloat)tfy_width {
    return CGRectGetWidth(self.bounds);
}

- (void)setTfy_width:(CGFloat)tfy_width {
    CGRect newFrame     = self.frame;
    newFrame.size.width = tfy_width;
    self.frame          = newFrame;
}

- (CGFloat)tfy_height {
    return CGRectGetHeight(self.bounds);
}

- (void)setTfy_height:(CGFloat)tfy_height {
    CGRect newFrame      = self.frame;
    newFrame.size.height = tfy_height;
    self.frame           = newFrame;
}

- (CGFloat)tfy_top {
    return self.frame.origin.y;
}

- (void)setTfy_top:(CGFloat)tfy_top {
    CGRect newFrame   = self.frame;
    newFrame.origin.y = tfy_top;
    self.frame        = newFrame;
}

- (CGFloat)tfy_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setTfy_bottom:(CGFloat)tfy_bottom {
    CGRect newFrame   = self.frame;
    newFrame.origin.y = tfy_bottom - self.frame.size.height;
    self.frame        = newFrame;
}

- (CGFloat)tfy_left {
    return self.frame.origin.x;
}

- (void)setTfy_left:(CGFloat)tfy_left {
    CGRect newFrame   = self.frame;
    newFrame.origin.x = tfy_left;
    self.frame        = newFrame;
}

- (CGFloat)tfy_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setTfy_right:(CGFloat)tfy_right {
    CGRect newFrame   = self.frame;
    newFrame.origin.x = tfy_right - self.frame.size.width;
    self.frame        = newFrame;
}

- (CGFloat)tfy_centerX {
    return self.center.x;
}

- (void)setTfy_centerX:(CGFloat)tfy_centerX {
    CGPoint newCenter = self.center;
    newCenter.x       = tfy_centerX;
    self.center       = newCenter;
}

- (CGFloat)tfy_centerY {
    return self.center.y;
}

- (void)setTfy_centerY:(CGFloat)tfy_centerY {
    CGPoint newCenter = self.center;
    newCenter.y       = tfy_centerY;
    self.center       = newCenter;
}

- (CGPoint)tfy_origin {
    return self.frame.origin;
}

- (void)setTfy_origin:(CGPoint)tfy_origin {
    CGRect newFrame = self.frame;
    newFrame.origin = tfy_origin;
    self.frame      = newFrame;
}

- (CGSize)tfy_size_size {
    return self.frame.size;
}

- (void)setTfy_size_size:(CGSize)tfy_size_size{
    CGRect newFrame = self.frame;
    newFrame.size   = tfy_size_size;
    self.frame      = newFrame;
}

@end


@implementation SliderButton

// 重写此方法将按钮的点击范围扩大
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect bounds = self.bounds;
    // 扩大点击区域
    bounds = CGRectInset(bounds, -20, -20);
    // 若点击的点在新的bounds里面。就返回yes
    return CGRectContainsPoint(bounds, point);
}

@end

@interface TFY_SliderView ()
/**
 *  进度背景 | 缓存进度 | 滑动进度
 */
@property (nonatomic, strong) UIImageView *bgProgressView,*bufferProgressView,*sliderProgressView;
/**
 *  滑块
 */
@property(nonatomic , strong)SliderButton *sliderBtn;
/**
 *  线条
 */
@property(nonatomic , strong)UIView *loadingBarView;
/**
 * 是否隐藏
 */
@property(nonatomic , assign)BOOL isLoading;
/**
 * 点击手势
 */
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;


@end

@implementation TFY_SliderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.allowTapped = YES;
        self.animate = YES;
        [self addSubViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.allowTapped = YES;
    self.animate = YES;
    [self addSubViews];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.bounds.size.width;
    CGFloat min_view_h = self.bounds.size.height;
    
    min_x = 0;
    min_w = min_view_w;
    min_y = 0;
    min_h = self.sliderHeight;
    self.bgProgressView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 0;
    min_y = 0;
    min_w = self.thumbSize.width;
    min_h = self.thumbSize.height;
    self.sliderBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.sliderBtn.tfy_centerX = self.bgProgressView.tfy_width * self.value;
    
    min_x = 0;
    min_y = 0;
    if (self.sliderBtn.hidden) {
        min_w = self.bgProgressView.tfy_width * self.value;
    } else {
        min_w = self.sliderBtn.tfy_centerX;
    }
    min_h = self.sliderHeight;
    self.sliderProgressView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 0;
    min_y = 0;
    min_w = self.bgProgressView.tfy_width * self.bufferValue;
    min_h = self.sliderHeight;
    self.bufferProgressView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_w = 0.1;
    min_h = self.sliderHeight;
    min_x = (min_view_w - min_w)/2;
    min_y = (min_view_h - min_h)/2;
    self.loadingBarView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    self.bgProgressView.tfy_centerY     = min_view_h * 0.5;
    self.bufferProgressView.tfy_centerY = min_view_h * 0.5;
    self.sliderProgressView.tfy_centerY = min_view_h * 0.5;
    self.sliderBtn.tfy_centerY          = min_view_h * 0.5;
}

/**
 添加子视图
 */
- (void)addSubViews {
    self.thumbSize = CGSizeMake(kSliderBtnWH, kSliderBtnWH);
    self.sliderHeight = kProgressH;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bgProgressView];
    [self addSubview:self.bufferProgressView];
    [self addSubview:self.sliderProgressView];
    [self addSubview:self.sliderBtn];
    [self addSubview:self.loadingBarView];
    
    // 添加点击手势
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:self.tapGesture];
    
    // 添加滑动手势
    UIPanGestureRecognizer *sliderGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sliderGesture:)];
    [self addGestureRecognizer:sliderGesture];
}
#pragma mark - Setter

- (void)setMaximumTrackTintColor:(UIColor *)maximumTrackTintColor {
    _maximumTrackTintColor = maximumTrackTintColor;
    self.bgProgressView.backgroundColor = maximumTrackTintColor;
}

- (void)setMinimumTrackTintColor:(UIColor *)minimumTrackTintColor {
    _minimumTrackTintColor = minimumTrackTintColor;
    self.sliderProgressView.backgroundColor = minimumTrackTintColor;
}

- (void)setBufferTrackTintColor:(UIColor *)bufferTrackTintColor {
    _bufferTrackTintColor = bufferTrackTintColor;
    self.bufferProgressView.backgroundColor = bufferTrackTintColor;
}

- (void)setLoadingTintColor:(UIColor *)loadingTintColor {
    _loadingTintColor = loadingTintColor;
    self.loadingBarView.backgroundColor = loadingTintColor;
}

- (void)setMaximumTrackImage:(UIImage *)maximumTrackImage {
    _maximumTrackImage = maximumTrackImage;
    self.bgProgressView.image = maximumTrackImage;
    self.maximumTrackTintColor = [UIColor clearColor];
}

- (void)setMinimumTrackImage:(UIImage *)minimumTrackImage {
    _minimumTrackImage = minimumTrackImage;
    self.sliderProgressView.image = minimumTrackImage;
    self.minimumTrackTintColor = [UIColor clearColor];
}

- (void)setBufferTrackImage:(UIImage *)bufferTrackImage {
    _bufferTrackImage = bufferTrackImage;
    self.bufferProgressView.image = bufferTrackImage;
    self.bufferTrackTintColor = [UIColor clearColor];
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state {
    [self.sliderBtn setBackgroundImage:image forState:state];
}

- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state {
    [self.sliderBtn setImage:image forState:state];
}

- (void)setValue:(float)value {
    if (isnan(value)) return;
    value = MIN(1.0, value);
    _value = value;
    if (self.sliderBtn.hidden) {
        self.sliderProgressView.tfy_width = self.bgProgressView.tfy_width * value;
    } else {
        self.sliderBtn.tfy_centerX = self.bgProgressView.tfy_width * value;
        self.sliderProgressView.tfy_width = self.sliderBtn.tfy_centerX;
    }
}

- (void)setBufferValue:(float)bufferValue {
    if (isnan(bufferValue)) return;
    bufferValue = MIN(1.0, bufferValue);
    _bufferValue = bufferValue;
    self.bufferProgressView.tfy_width = self.bgProgressView.tfy_width * bufferValue;
}

- (void)setAllowTapped:(BOOL)allowTapped {
    _allowTapped = allowTapped;
    if (!allowTapped) {
        [self removeGestureRecognizer:self.tapGesture];
    }
}

- (void)setSliderHeight:(CGFloat)sliderHeight {
    if (isnan(sliderHeight)) return;
    _sliderHeight = sliderHeight;
    self.bgProgressView.tfy_height     = sliderHeight;
    self.bufferProgressView.tfy_height = sliderHeight;
    self.sliderProgressView.tfy_height = sliderHeight;
}

- (void)setIsHideSliderBlock:(BOOL)isHideSliderBlock {
    _isHideSliderBlock = isHideSliderBlock;
    // 隐藏滑块，滑杆不可点击
    if (isHideSliderBlock) {
        self.sliderBtn.hidden = YES;
        self.bgProgressView.tfy_left     = 0;
        self.bufferProgressView.tfy_left = 0;
        self.sliderProgressView.tfy_left = 0;
        self.allowTapped = NO;
    }
}

/**
 * 启动微调器的动画。
 */
- (void)startAnimating {
    if (self.isLoading) return;
    self.isLoading = YES;
    self.bufferProgressView.hidden = YES;
    self.sliderProgressView.hidden = YES;
    self.sliderBtn.hidden = YES;
    self.loadingBarView.hidden = NO;
    
    [self.loadingBarView.layer removeAllAnimations];
    CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc] init];
    animationGroup.duration = 0.4;
    animationGroup.beginTime = CACurrentMediaTime() + 0.4;
    animationGroup.repeatCount = MAXFLOAT;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animation];
    scaleAnimation.keyPath = @"transform.scale.x";
    scaleAnimation.fromValue = @(1000.0f);
    scaleAnimation.toValue = @(self.tfy_width * 10);
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animation];
    alphaAnimation.keyPath = @"opacity";
    alphaAnimation.fromValue = @(1.0f);
    alphaAnimation.toValue = @(0.0f);
    
    [animationGroup setAnimations:@[scaleAnimation, alphaAnimation]];
    [self.loadingBarView.layer addAnimation:animationGroup forKey:@"loading"];
}

/**
 *  停止微调器的动画。
 */
- (void)stopAnimating {
    self.isLoading = NO;
    self.bufferProgressView.hidden = NO;
    self.sliderProgressView.hidden = NO;
    self.sliderBtn.hidden = self.isHideSliderBlock;
    self.loadingBarView.hidden = YES;
    [self.loadingBarView.layer removeAllAnimations];
}

#pragma mark - User Action

- (void)sliderGesture:(UIGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            [self sliderBtnTouchBegin:self.sliderBtn];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            [self sliderBtnDragMoving:self.sliderBtn point:[gesture locationInView:self.bgProgressView]];
        }
            break;
        case UIGestureRecognizerStateEnded: {
            [self sliderBtnTouchEnded:self.sliderBtn];
        }
            break;
        default:
            break;
    }
}

- (void)sliderBtnTouchBegin:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(sliderTouchBegan:)]) {
        [self.delegate sliderTouchBegan:self.value];
    }
    if (self.animate) {
        [UIView animateWithDuration:kAnimate animations:^{
            btn.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }];
    }
}

- (void)sliderBtnTouchEnded:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(sliderTouchEnded:)]) {
        [self.delegate sliderTouchEnded:self.value];
    }
    if (self.animate) {
        [UIView animateWithDuration:kAnimate animations:^{
            btn.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)sliderBtnDragMoving:(UIButton *)btn point:(CGPoint)touchPoint {
    // 点击的位置
    CGPoint point = touchPoint;
    // 获取进度值 由于btn是从 0-(self.width - btn.width)
    CGFloat value = (point.x - btn.tfy_width * 0.5) / self.bgProgressView.tfy_width;
    // value的值需在0-1之间
    value = value >= 1.0 ? 1.0 : value <= 0.0 ? 0.0 : value;
    if (self.value == value) return;
    self.isForward = self.value < value;
    self.value = value;
    if ([self.delegate respondsToSelector:@selector(sliderValueChanged:)]) {
        [self.delegate sliderValueChanged:value];
    }
}

- (void)tapped:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self.bgProgressView];
    // 获取进度
    CGFloat value = (point.x - self.sliderBtn.tfy_width * 0.5) * 1.0 / self.bgProgressView.tfy_width;
    value = value >= 1.0 ? 1.0 : value <= 0 ? 0 : value;
    self.value = value;
    if ([self.delegate respondsToSelector:@selector(sliderTapped:)]) {
        [self.delegate sliderTapped:value];
    }
}

#pragma mark - getter

- (UIView *)bgProgressView {
    if (!_bgProgressView) {
        _bgProgressView = [UIImageView new];
        _bgProgressView.backgroundColor = [UIColor grayColor];
        _bgProgressView.contentMode = UIViewContentModeScaleAspectFill;
        _bgProgressView.clipsToBounds = YES;
    }
    return _bgProgressView;
}

- (UIView *)bufferProgressView {
    if (!_bufferProgressView) {
        _bufferProgressView = [UIImageView new];
        _bufferProgressView.backgroundColor = [UIColor whiteColor];
        _bufferProgressView.contentMode = UIViewContentModeScaleAspectFill;
        _bufferProgressView.clipsToBounds = YES;
    }
    return _bufferProgressView;
}

- (UIView *)sliderProgressView {
    if (!_sliderProgressView) {
        _sliderProgressView = [UIImageView new];
        _sliderProgressView.backgroundColor = [UIColor redColor];
        _sliderProgressView.contentMode = UIViewContentModeScaleAspectFill;
        _sliderProgressView.clipsToBounds = YES;
    }
    return _sliderProgressView;
}

- (SliderButton *)sliderBtn {
    if (!_sliderBtn) {
        _sliderBtn = [SliderButton buttonWithType:UIButtonTypeCustom];
        [_sliderBtn setAdjustsImageWhenHighlighted:NO];
    }
    return _sliderBtn;
}

- (UIView *)loadingBarView {
    if (!_loadingBarView) {
        _loadingBarView = [[UIView alloc] init];
        _loadingBarView.backgroundColor = [UIColor whiteColor];
        _loadingBarView.hidden = YES;
    }
    return _loadingBarView;
}

@end
