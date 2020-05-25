//
//  UIButton+TFY_Chain.m
//  TFY_CHESHI
//
//  Created by 田风有 on 2019/6/5.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "UIButton+TFY_Chain.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <time.h>
#import "UIImage+Image.h"
#define WSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define RGBA(r,g,b,a)     [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@interface UIButton ()
/**
 *  🐶nn    👇
 */
@property(nonatomic,strong)dispatch_source_t timer;
/**
 *  🐶记录外边的时间    👇
 */
@property(nonatomic,assign)NSInteger userTime;

@end

static NSInteger const TimeInterval = 60; // 默认时间
static NSString * const ButtonTitleFormat = @"剩余%ld秒";
static NSString * const RetainTitle = @"重试";
static const void *ButtonRuntimeLimitTasks         = &ButtonRuntimeLimitTasks;
static const void *ButtonRuntimeLimitTapBlock      = &ButtonRuntimeLimitTapBlock;
static const void *ButtonRuntimeLimitTapTimes      = &ButtonRuntimeLimitTapTimes;
static const void *ButtonRuntimeLimitTapLastTimes  = &ButtonRuntimeLimitTapLastTimes;
static const void *ButtonRuntimeLimitTapSpaceTimes = &ButtonRuntimeLimitTapSpaceTimes;
static const void *ButtonRuntimeLimitIsStop        = &ButtonRuntimeLimitIsStop;

static inline NSMutableSet *UIButtonSwizzledSet(){
    static NSMutableSet *set = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        set = [NSMutableSet set];
    });
    return set;
}
static inline void UI_swizzleButtonIfNeed(Class swizzleClass){
    NSMutableSet *buttonTapSet = UIButtonSwizzledSet();
    @synchronized (buttonTapSet) {
        NSString *className = NSStringFromClass(swizzleClass);
        if ([buttonTapSet containsObject:className]) return;
        SEL buttonTapSelector = sel_registerName("_sendActionsForEvents:withEvent:");
        __block void (* oldImp) (__unsafe_unretained id, SEL,UIControlEvents,id) = NULL;
        id newImpBlock = ^ (__unsafe_unretained UIButton* self,UIControlEvents events, id a){
            if (events & UIControlEventTouchUpInside) {
                if (objc_getAssociatedObject(self, ButtonRuntimeLimitIsStop)) return;
                id spaceTime = objc_getAssociatedObject(self, ButtonRuntimeLimitTapSpaceTimes);
                if (spaceTime) {
                   NSTimeInterval spaceTimef = [spaceTime doubleValue];
                    id lastTime = objc_getAssociatedObject(self, ButtonRuntimeLimitTapLastTimes);
                    NSTimeInterval currentTime = time(NULL);
                    if (lastTime) {
                        if (currentTime - [lastTime doubleValue] < spaceTimef) return;
                    }
                    objc_setAssociatedObject(self, ButtonRuntimeLimitTapLastTimes, @(currentTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                }
                ButtonLimitTimesTapBlock block = objc_getAssociatedObject(self, ButtonRuntimeLimitTapBlock);
                if (block) {
                    NSUInteger tapTimes = [objc_getAssociatedObject(self, ButtonRuntimeLimitTapTimes) integerValue];
                    tapTimes ++;
                    objc_setAssociatedObject(self, ButtonRuntimeLimitTapTimes, @(tapTimes), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    BOOL stop = NO;
                    block(tapTimes,&stop,self);
                    if (stop) {
                        objc_setAssociatedObject(self, ButtonRuntimeLimitIsStop, @(stop), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                        return;
                    }
                }
            }
            if (oldImp == NULL) {
                struct objc_super supperInfo = {
                    .receiver = self,
                    .super_class = class_getSuperclass(swizzleClass)
                };
                ((void (*) (struct objc_super *, SEL,UIControlEvents,id))objc_msgSendSuper)(&supperInfo, buttonTapSelector,events,a);
            }else{
                oldImp(self,buttonTapSelector,events,a);
            }
        };
        IMP newImp = imp_implementationWithBlock(newImpBlock);
        if (!class_addMethod(swizzleClass, buttonTapSelector, newImp, "v@:")) {
            Method buttonTapMethod = class_getInstanceMethod(swizzleClass, buttonTapSelector);
            oldImp = (__typeof__ (oldImp))method_setImplementation(buttonTapMethod, newImp);
        }
        [buttonTapSet addObject:className];
    }
}

@implementation UIButton (TFY_Chain)
CALayer *_layer;
UIColor *_startColorOne;
UIColor *_startColorTwo;
NSInteger _lineWidths;
NSInteger _topHeight;
static NSString *keyOfMethod_btn; //关联者的索引key-用于获取block
@dynamic startColorOne;
@dynamic startColorTwo;
@dynamic lineWidths;
@dynamic topHeight;

/**
 *  文本输入
 */
-(UIButton *(^)(NSString *,UIControlState))tfy_text{
    WSelf(myself);
    return ^(NSString *title_str,UIControlState state){
        [myself setTitle:title_str forState:state];
        return myself;
    };
}
/**
 *  文本颜色
 */
-(UIButton *(^)(id,UIControlState))tfy_textcolor{
    WSelf(myself);
    return ^(id color_str,UIControlState colorstate){
        if ([color_str isKindOfClass:[UIColor class]]) {
            [myself setTitleColor:color_str forState:colorstate];
        }
        if ([color_str isKindOfClass:[NSString class]]) {
            [myself setTitleColor:[myself btncolorWithHexString:color_str alpha:1] forState:colorstate];
        }
        return myself;
    };
}
/**
 *  文本大小
 */
-(UIButton *(^)(UIFont *))tfy_font{
    WSelf(myself);
    return ^(UIFont *font){
        myself.titleLabel.font = font;
        return myself;
    };
}

/**
 *  按钮 title_str 文本文字 color_str 文字颜色  font文字大小
 */
-(UIButton *(^)(NSString *,UIControlState,id,UIControlState,UIFont *))tfy_title{
    WSelf(myself);
    return ^(NSString *title_str,UIControlState titlestate,id color_str,UIControlState colorstate,UIFont *font){
        [myself setTitle:title_str forState:titlestate];
        if ([color_str isKindOfClass:[NSString class]]) {
            [myself setTitleColor:[myself btncolorWithHexString:color_str alpha:1] forState:colorstate];
        }
        if ([color_str isKindOfClass:[UIColor class]]) {
            [myself setTitleColor:color_str forState:colorstate];
        }
        myself.titleLabel.font = font;
        return myself;
    };
}
/**
 *  按钮  HexString 背景颜色 alpha 背景透明度
 */
-(UIButton *(^)(id,CGFloat))tfy_backgroundColor{
    WSelf(myself);
    return ^(id HexString,CGFloat alpha){
        if ([HexString isKindOfClass:[NSString class]]) {
            [myself setBackgroundColor:[myself btncolorWithHexString:HexString alpha:alpha]];
        }
        if ([HexString isKindOfClass:[UIColor class]]) {
            [myself setBackgroundColor:HexString];
        }
        return myself;
    };
}
/**
 *  按钮  alignment 0 左 1 中 2 右
 */
-(UIButton *(^)(NSInteger))tfy_alAlignment{
    WSelf(myself);
    return ^(NSInteger alignment){
        switch (alignment) {
            case 0:
                myself.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
                break;
            case 1:
                myself.contentHorizontalAlignment =UIControlContentHorizontalAlignmentCenter;
                break;
            case 2:
                myself.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
                break;
        }
        return myself;
    };
}
/**
 *  添加四边框和color 颜色  borderWidth 宽度
 */
-(UIButton *(^)(CGFloat, id))tfy_borders{
    WSelf(myself);
    return ^(CGFloat borderWidth,id color){
        myself.layer.borderWidth = borderWidth;
        if ([color isKindOfClass:[NSString class]]) {
            myself.layer.borderColor = [myself btncolorWithHexString:color alpha:1].CGColor;
        }
        if ([color isKindOfClass:[UIColor class]]) {
            myself.layer.borderColor = [(UIColor *)color CGColor];
        }
        return myself;
    };
}
/**
 *  添加四边 color_str阴影颜色  shadowRadius阴影半径
 */
-(UIButton *(^)(id, CGFloat))tfy_bordersShadow{
    WSelf(myself);
    return ^(id color_str, CGFloat shadowRadius){
        // 阴影颜色
        if ([color_str isKindOfClass:[NSString class]]) {
            myself.layer.shadowColor = [myself btncolorWithHexString:color_str alpha:1].CGColor;
        }
        if ([color_str isKindOfClass:[UIColor class]]) {
            myself.layer.borderColor = [(UIColor *)color_str CGColor];
        }
        // 阴影偏移，默认(0, -3)
        myself.layer.shadowOffset = CGSizeMake(0,0);
        // 阴影透明度，默认0
        myself.layer.shadowOpacity = 0.5;
        // 阴影半径，默认3
        myself.layer.shadowRadius = shadowRadius;
        
        return myself;
    };
}

/**
 *  按钮  cornerRadius 圆角
 */
-(UIButton *(^)(CGFloat))tfy_cornerRadius{
    WSelf(myself);
    return ^(CGFloat cornerRadius){
        myself.layer.cornerRadius = cornerRadius;
        return myself;
    };
}
/**
 *  按钮  image_str 图片字符串
 */
-(UIButton *(^)(id,UIControlState))tfy_image{
    WSelf(myself);
    return ^(id image_id,UIControlState state){
        if ([image_id isKindOfClass:[UIColor class]]) {
            [myself setImage:[[UIImage tfy_createImage:image_id] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:state];
        }
        if ([image_id isKindOfClass:[NSString class]]) {
           [myself setImage:[[UIImage imageNamed:image_id] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:state];
        }
        return myself;
    };
}
/**
 *  按钮  backimage_str 背景图片
 */
-(UIButton *(^)(id,UIControlState))tfy_backgroundImage{
    WSelf(myself);
    return ^(id image_id,UIControlState state){
        if ([image_id isKindOfClass:[UIColor class]]) {
            [myself setBackgroundImage:[[UIImage tfy_createImage:image_id] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:state];
        }
        if ([image_id isKindOfClass:[NSString class]]) {
           [myself setBackgroundImage:[[UIImage imageNamed:image_id] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:state];
        }
        return myself;
    };
}
/**
 *  按钮 点击方法
 */
-(UIButton *(^)(id, SEL,UIControlEvents))tfy_action{
    WSelf(myself);
    return ^(id object, SEL action,UIControlEvents events){
        [myself addTarget:object action:action forControlEvents:events];
        return myself;
    };
}

- (UIButton *(^)(BOOL))tfy_adjustsWidth{
    WSelf(weakSelf);
    return ^(BOOL adjustsWidth){
        weakSelf.titleLabel.adjustsFontSizeToFitWidth = adjustsWidth;
        return weakSelf;
    };
}

- (UIButton *(^)(NSInteger))tfy_numberOfLines{
    WSelf(weakSelf);
    return ^(NSInteger numberOfLines){
        weakSelf.titleLabel.numberOfLines = numberOfLines;
        return weakSelf;
    };
}
/**
 * 文字省略格式
 */
- (UIButton *(^)(NSLineBreakMode))tfy_lineBreakMode{
    WSelf(weakSelf);
    return ^(NSLineBreakMode mode){
        weakSelf.titleLabel.lineBreakMode = mode;
        return weakSelf;
    };
}

- (UIButton *(^)(NSAttributedString *,UIControlState))tfy_attributrdString{
    WSelf(weakSelf);
    return ^(NSAttributedString *attributrdString,UIControlState state){
        [weakSelf setAttributedTitle:attributrdString forState:state];
        return weakSelf;
    };
}

/**
 *  添加指定的View
 */
-(UIButton *(^)(UIView *))tfy_addToSuperView{
    WSelf(myself);
    return ^(UIView *view){
        [view addSubview:myself];
        return myself;
    };
}

/**
 * 隐藏本类
 */
-(UIButton *(^)(BOOL))tfy_hidden{
    WSelf(myself);
    return ^(BOOL hidden){
        myself.hidden = hidden;
        return myself;
    };
}
/**
 * 透明度
 */
-(UIButton *(^)(CGFloat))tfy_alpha{
    WSelf(myself);
    return ^(CGFloat alpha){
        myself.alpha = alpha;
        return myself;
    };
}
/**
 * 交互开关
 */
-(UIButton *(^)(BOOL))tfy_userInteractionEnabled{
    WSelf(myself);
    return ^(BOOL userInteractionEnabled){
        myself.userInteractionEnabled = userInteractionEnabled;
        return myself;
    };
}

/**
 *  位置偏移量
 */
-(UIButton *(^)(UIEdgeInsets))tfy_contentEdgeInsets{
    WSelf(myself);
    return ^(UIEdgeInsets insets){
        myself.contentEdgeInsets = insets;
        return myself;
    };
}
/**
 *  文字偏移量
 */
-(UIButton *(^)(UIEdgeInsets))tfy_titleEdgeInsets{
    WSelf(myself);
    return ^(UIEdgeInsets insets){
        myself.titleEdgeInsets = insets;
        return myself;
    };
}
/**
 *  图片偏移量
 */
-(UIButton *(^)(UIEdgeInsets))tfy_imageEdgeInsets{
    WSelf(myself);
    return ^(UIEdgeInsets insets){
        myself.imageEdgeInsets = insets;
        return myself;
    };
}

/**
 *  添加图片的位置和文字距离
 */
-(UIButton *(^)(ButtonPosition,CGFloat))tfy_layouEdgeInsetsPosition{
    WSelf(myself);
    return ^(ButtonPosition postion,CGFloat spacing){
        [myself tfy_layouEdgeInsetsPosition:postion spacing:spacing];
        return myself;
    };
}


- (UIButton * _Nonnull (^)(ButtonLimitTimesTapBlock _Nonnull))buttonTapTime{
    return ^(ButtonLimitTimesTapBlock block){
        if (block != nil) {
            UI_swizzleButtonIfNeed(object_getClass(self));
        }
        objc_setAssociatedObject(self, ButtonRuntimeLimitTapBlock, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
        return self;
    };
}

- (UIButton * _Nonnull (^)(NSTimeInterval))tapSpaceTime{
    return ^(NSTimeInterval time){
        UI_swizzleButtonIfNeed(object_getClass(self));
        objc_setAssociatedObject(self, ButtonRuntimeLimitTapSpaceTimes, @(time), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return self;
    };
}
- (void)cancelRecordTime{
    if (!objc_getAssociatedObject(self, ButtonRuntimeLimitTapLastTimes)) return;
    objc_setAssociatedObject(self, ButtonRuntimeLimitTapLastTimes, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**
 *  button的大小要大于 图片大小+文字大小+spacing   spacing 图片和文字的间隔
 */
-(void)tfy_layouEdgeInsetsPosition:(ButtonPosition)postion spacing:(CGFloat)spacing{
    
    CGFloat imageWidth, imageHeight, textWidth, textHeight, x, y;
    imageWidth = self.currentImage.size.width;
    imageHeight = self.currentImage.size.height;
    [self.titleLabel sizeToFit];
    textWidth = self.titleLabel.frame.size.width;
    textHeight = self.titleLabel.frame.size.height;
    spacing = spacing / 2;
    switch (postion) {
        case ButtonPositionImageTop_titleBottom:{
            x = textHeight / 2 + spacing;
            y = textWidth / 2;
            self.imageEdgeInsets = UIEdgeInsetsMake(-x, y, x, - y);
            x = imageHeight / 2 + spacing;
            y = imageWidth / 2;
            self.titleEdgeInsets = UIEdgeInsetsMake(x, - y, - x, y);
        }
            break;
        case ButtonPositionImageBottom_titleTop:{
            x = textHeight / 2 + spacing;
            y = textWidth / 2;
            self.imageEdgeInsets = UIEdgeInsetsMake(x, y, -x, - y);
            x = imageHeight / 2 + spacing;
            y = imageWidth / 2;
            self.titleEdgeInsets = UIEdgeInsetsMake(-x, - y, x, y);
        }
            break;
        case ButtonPositionImageLeft_titleRight:{
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing,0, spacing);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing , 0, - spacing);
        }
            break;
        case ButtonPositionImageRight_titleLeft:{
            self.imageEdgeInsets = UIEdgeInsetsMake(0, spacing + textWidth, 0, - (spacing + textWidth));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(spacing + imageWidth), 0, (spacing + imageWidth));
        }
            break;
        default:
            break;
    }
}



-(UIColor *)btncolorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r                       截取的range = (0,2)
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;//     截取的range = (2,2)
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;//     截取的range = (4,2)
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;//将字符串十六进制两位数字转为十进制整数
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

- (void)setTime:(NSInteger)time{
    objc_setAssociatedObject(self, @selector(time), @(time), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)time{
    
    return  [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setFormat:(NSString *)format{
    
    objc_setAssociatedObject(self, @selector(format), format, OBJC_ASSOCIATION_COPY);
}

- (NSString *)format{
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setUserTime:(NSInteger)userTime{
    
    objc_setAssociatedObject(self, @selector(userTime), @(userTime), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)userTime{
    
    return  [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setTimer:(dispatch_source_t)timer{
    
    objc_setAssociatedObject(self, @selector(timer), timer, OBJC_ASSOCIATION_RETAIN);
}

- (dispatch_source_t)timer{
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCompleteBlock:(void (^)(void))CompleteBlock{
    objc_setAssociatedObject(self, @selector(CompleteBlock), CompleteBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void (^)(void))CompleteBlock{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)startTimer
{
    if (!self.time) {
        self.time = TimeInterval;
    }
    if (!self.format) {
        self.format = ButtonTitleFormat;
    }
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, globalQueue);
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.timer, ^{
        if (self.time <= 1) {
            dispatch_source_cancel(self.timer);
        }else
        {
            self.time --;
            dispatch_async(mainQueue, ^{
                self.enabled = NO;
                [self setTitle:[NSString stringWithFormat:self.format,self.time] forState:UIControlStateNormal];
            });
        }
    });
    dispatch_source_set_cancel_handler(self.timer, ^{
        dispatch_async(mainQueue, ^{
            self.enabled = YES;
            [self setTitle:RetainTitle forState:UIControlStateNormal];
            if (self.CompleteBlock) {
                self.CompleteBlock();
            }
            if (self.userTime) {
                self.time = self.userTime;
            }else
            {
                self.time = TimeInterval;
            }
        });
    });
    dispatch_resume(self.timer);
}

- (void)endTimer{
    
    dispatch_source_cancel(self.timer);
}

/**
 *  动画启动
 */
- (void)show{
    if (!self.hidden) return;
    
    self.hidden = NO;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:2.0];
    scaleAnimation.toValue   = [NSNumber numberWithFloat:1.0];
    scaleAnimation.duration  = .3;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue  = [NSNumber numberWithFloat:.5];
    opacityAnimation.toValue    = [NSNumber numberWithFloat:1];
    opacityAnimation.duration   = .3;
    
    [self.layer addAnimation:scaleAnimation forKey:@"scale"];
    [self.layer addAnimation:opacityAnimation forKey:@"opacity"];
}
/**
 *  动画结束
 */
- (void)hide {
    self.hidden = YES;
}

/**
 *  绑定button
 **/
-(void)BindingBtnactionBlock:(ActionBlock)actionBlock{
    [self addTarget:nil action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject (self , &keyOfMethod_btn, actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)buttonClick{
    //判断动画-如果正在加载就不能点击
    if (_layer.animationKeys.count>0) {
        return;
    }
    //旋转
    [self setTitle:@"" forState:UIControlStateNormal];
    [self setImage:nil forState:UIControlStateNormal];
    [self creatLayerWithStartLoadingButton];
    
    
}

/**
 *  加载完毕停止旋转
 *  title:停止后button的文字
 *  textColor :字体色 如果颜色不变就为nil
 *  backgroundColor :背景色 如果颜色不变就为nil
 **/

-(void)stopLoading:(NSString*)title textColor:(UIColor*)textColor backgroundColor:(UIColor*)backColor{
    
    if (textColor) {
        [self setTitleColor:textColor forState:UIControlStateNormal];
    }
    
    if (backColor) {
        self.backgroundColor = backColor;
    }
    
    [self setTitle:title forState:UIControlStateNormal];
    [_layer removeAllAnimations];//停止动画
    [_layer removeFromSuperlayer];//移除动画

    
}


-(void)setStartColorOne:(UIColor *)startColorOne{
    
    _startColorOne = startColorOne;
}
-(void)setStartColorTwo:(UIColor *)startColorTwo{
    
    _startColorTwo = startColorTwo;
}

-(void)setLineWidths:(NSInteger)lineWidths{
    _lineWidths = lineWidths;
}
-(void)setTopHeight:(NSInteger)topHeight{
    
    _topHeight = topHeight;
}

-(void)creatLayerWithStartLoadingButton{
    UIColor *backgroundColor = self.backgroundColor;//获取背景色
    UIColor *textColor = self.currentTitleColor;//获取字体色
    if (_startColorOne) {
        backgroundColor = _startColorOne;
    }
    if (_startColorTwo) {
        textColor = _startColorTwo;
    }
    NSInteger lineW =  5;//圆圈的宽度默认5
    if (_lineWidths>0) {
        lineW = _lineWidths;
    }
    NSInteger topWid = 5;
    if (_topHeight) {
        topWid = _topHeight;
    }
    
    CGRect rect = self.frame;
    float wid = rect.size.height-topWid*2;
    float x = rect.size.width/2-wid/2;
    
    _layer = [CALayer layer];
    _layer.frame = CGRectMake(x, topWid, wid, wid);
    _layer.backgroundColor = backgroundColor.CGColor;
    
    [self.layer addSublayer:_layer];
    //创建圆环
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(wid/2, wid/2) radius:(wid-lineW*2)/2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    //圆环遮罩
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = textColor.CGColor;
    shapeLayer.lineWidth = lineW;
    shapeLayer.strokeStart = 0;
    shapeLayer.strokeEnd = 1;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineDashPhase = 0.8;
    shapeLayer.path = bezierPath.CGPath;
    [_layer setMask:shapeLayer];
    
    
    //颜色渐变
    NSMutableArray *colors = [NSMutableArray arrayWithObjects:(id)backgroundColor.CGColor,(id)[RGBA(255, 255, 255, 0.5) CGColor], nil];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.shadowPath = bezierPath.CGPath;
    gradientLayer.frame = CGRectMake(0, 0, wid, wid/2);
    gradientLayer.startPoint = CGPointMake(1, 0);
    gradientLayer.endPoint = CGPointMake(0, 0);
    [gradientLayer setColors:[NSArray arrayWithArray:colors]];
    
    NSMutableArray *colors1 = [NSMutableArray arrayWithObjects:(id)[RGBA(255, 255, 255, 0.5) CGColor],(id)[textColor CGColor], nil];
    CAGradientLayer *gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.shadowPath = bezierPath.CGPath;
    gradientLayer1.frame = CGRectMake(0, wid/2, wid, wid/2);
    gradientLayer1.startPoint = CGPointMake(0, 1);
    gradientLayer1.endPoint = CGPointMake(1, 1);
    [gradientLayer1 setColors:[NSArray arrayWithArray:colors1]];
    [_layer addSublayer:gradientLayer]; //设置颜色渐变
    [_layer addSublayer:gradientLayer1];
    

    [self animation];
    [self loadActionBlock];
    
}

- (void)animation {
    //动画
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotationAnimation.toValue = [NSNumber numberWithFloat:2.0*M_PI];
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.duration = 0.8;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_layer addAnimation:rotationAnimation forKey:@"rotationAnnimation"];
}

-(void)loadActionBlock{
    //获取关联
    ActionBlock block1 = (ActionBlock)objc_getAssociatedObject(self, &keyOfMethod_btn);
    if(block1){
        block1(self);
    }
}

@end
