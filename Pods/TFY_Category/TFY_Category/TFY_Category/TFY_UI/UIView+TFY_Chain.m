//
//  UIView+TFY_Chain.m
//  TFY_Category
//
//  Created by 田风有 on 2019/6/11.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "UIView+TFY_Chain.h"
#import <objc/runtime.h>
#define WSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;
NSString const *UIView_badgeKey = @"UIView_badgeKey";
NSString const *UIView_badgeBGColorKey = @"UIView_badgeBGColorKey";
NSString const *UIView_badgeTextColorKey = @"UIView_badgeTextColorKey";
NSString const *UIView_badgeFontKey = @"UIView_badgeFontKey";
NSString const *UIView_badgePaddingKey = @"UIView_badgePaddingKey";
NSString const *UIView_badgeMinSizeKey = @"UIView_badgeMinSizeKey";
NSString const *UIView_badgeOriginXKey = @"UIView_badgeOriginXKey";
NSString const *UIView_badgeOriginYKey = @"UIView_badgeOriginYKey";
NSString const *UIView_shouldHideBadgeAtZeroKey = @"UIView_shouldHideBadgeAtZeroKey";
NSString const *UIView_shouldAnimateBadgeKey = @"UIView_shouldAnimateBadgeKey";
NSString const *UIView_badgeValueKey = @"UIView_badgeValueKey";
NSString const *BlockTapKey = @"BlockTapKey";
NSString const *BlockKey = @"BlockKey";

@interface BorderLayer: CALayer

/// 默认为0.0
@property (nonatomic, assign)CGFloat tfy_border_Width;
/// 默认为UIEdgeInsetsZero
@property (nonatomic, assign)UIEdgeInsets tfy_border_Inset;

@end

@implementation BorderLayer

- (instancetype)init{
    if (self = [super init]) {
        self.anchorPoint = CGPointZero;
        self.tfy_border_Width = 0.0;
        self.tfy_border_Inset = UIEdgeInsetsZero;
    }
    return self;
}

@end

@protocol BorderDirection <NSObject>

@property (nonatomic, strong) BorderLayer *leftLayer;
@property (nonatomic, strong) BorderLayer *topLayer;
@property (nonatomic, strong) BorderLayer *rightLayer;
@property (nonatomic, strong) BorderLayer *bottomLayer;

@end

@interface UIView (BorderDirection)<BorderDirection>
@end


@implementation UIView (TFY_Chain)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 变化方法实现
        [self tfy_swizzleMethod:[self class] orgSel:@selector(layoutSubviews) swizzSel:@selector(tfy_layoutSubviews)];
    });
}
+ (void)tfy_swizzleMethod:(Class)class orgSel:(SEL)originalSelector swizzSel:(SEL)swizzledSelector {
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    IMP swizzledImp = method_getImplementation(swizzledMethod);
    char *swizzledTypes = (char *)method_getTypeEncoding(swizzledMethod);
    
    IMP originalImp = method_getImplementation(originalMethod);
    char *originalTypes = (char *)method_getTypeEncoding(originalMethod);
    
    BOOL success = class_addMethod(class, originalSelector, swizzledImp, swizzledTypes);
    if (success) {
        class_replaceMethod(class, swizzledSelector, originalImp, originalTypes);
    }else {
        // 添加失败，表明已经有这个方法，直接交换
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (UIView *(^)(UIColor *))tfy_backgroundColor {
    WSelf(myself);
    return ^(UIColor *backgroundColor) {
        myself.backgroundColor = backgroundColor;
        return myself;
    };
}

- (UIView *(^)(CGRect))tfy_frame {
    WSelf(myself);
    return  ^(CGRect frame) {
        myself.frame = frame;
        return myself;
    };
}

- (UIView *(^)(UIView *))tfy_addToSuperView {
    WSelf(myself);
    return ^(UIView *view) {
        [view addSubview:myself];
        return myself;
    };
}

- (UIView *(^)(BOOL))tfy_clipsToBounds {
    WSelf(myself);
    return ^(BOOL clipsToBounds) {
        myself.clipsToBounds = clipsToBounds;
        return myself;
    };
}

- (UIView *(^)(BOOL))tfy_hidden {
    WSelf(myself);
    return ^(BOOL hidden) {
        myself.hidden = hidden;
        return myself;
    };
}

- (UIView *(^)(BOOL))tfy_userInteractionEnabled {
    WSelf(myself);
    return ^(BOOL userInteractionEnabled) {
        myself.userInteractionEnabled = userInteractionEnabled;
        return myself;
    };
}

- (UIView *(^)(CGFloat))tfy_alpha {
    WSelf(myself);
    return ^(CGFloat alpha) {
        myself.alpha = alpha;
        return myself;
    };
}

-(UILabel *)tfy_bgdge{
    return objc_getAssociatedObject(self, &UIView_badgeKey);
}

-(void)setTfy_bgdge:(UILabel * _Nonnull)tfy_bgdge{
    objc_setAssociatedObject(self, &UIView_badgeKey, tfy_bgdge, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)tfy_badgeValue{
    return objc_getAssociatedObject(self, &UIView_badgeValueKey);
}

-(void)setTfy_badgeValue:(NSString * _Nonnull)tfy_badgeValue{
    objc_setAssociatedObject(self, &UIView_badgeValueKey, tfy_badgeValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (!tfy_badgeValue || [tfy_badgeValue isEqualToString:@""] || ([tfy_badgeValue isEqualToString:@"0"] && self.tfy_shouldHideBadgeAtZero)) {
        [self removeBadge];
    }
    else if (!self.tfy_bgdge){
        self.tfy_bgdge = [[UILabel alloc] initWithFrame:CGRectMake(self.tfy_badgeOriginX, self.tfy_badgeOriginY, 20, 20)];
        self.tfy_bgdge.textColor = self.tfy_badgeTextColor;
        self.tfy_bgdge.backgroundColor = self.tfy_badgeBGColor;
        self.tfy_bgdge.font = self.tfy_badgeFont;
        self.tfy_bgdge.textAlignment = NSTextAlignmentCenter;
        [self badgeInit];
        [self addSubview:self.tfy_bgdge];
        [self updateBadgeValueAnimated:NO];
    }
    else{
        [self updateBadgeValueAnimated:YES];
    }
}

-(UIColor *)tfy_badgeBGColor{
    return objc_getAssociatedObject(self, &UIView_badgeBGColorKey);
}

-(void)setTfy_badgeBGColor:(UIColor * _Nonnull)tfy_badgeBGColor{
    objc_setAssociatedObject(self, &UIView_badgeBGColorKey, tfy_badgeBGColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.tfy_bgdge) {
        [self refreshBadge];
    }
}

-(UIColor *)tfy_badgeTextColor{
    return objc_getAssociatedObject(self, &UIView_badgeTextColorKey);
}

-(void)setTfy_badgeTextColor:(UIColor * _Nonnull)tfy_badgeTextColor{
    objc_setAssociatedObject(self, &UIView_badgeTextColorKey, tfy_badgeTextColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.tfy_bgdge) {
        [self refreshBadge];
    }
}

-(UIFont *)tfy_badgeFont{
    return objc_getAssociatedObject(self, &UIView_badgeFontKey);
}

-(void)setTfy_badgeFont:(UIFont * _Nonnull)tfy_badgeFont{
    objc_setAssociatedObject(self, &UIView_badgeFontKey, tfy_badgeFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.tfy_bgdge) {
        [self refreshBadge];
    }
}

-(CGFloat)tfy_badgePadding{
    NSNumber *number = objc_getAssociatedObject(self, &UIView_badgePaddingKey);
    return number.floatValue;
}

-(void)setTfy_badgePadding:(CGFloat)tfy_badgePadding{
    NSNumber *number = [NSNumber numberWithDouble:tfy_badgePadding];
    objc_setAssociatedObject(self, &UIView_badgePaddingKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.tfy_bgdge) {
        [self updateBadgeFrame];
    }
}

-(CGFloat)tfy_badgeMinSize{
    NSNumber *number = objc_getAssociatedObject(self, &UIView_badgeMinSizeKey);
    return number.floatValue;
}

-(void)setTfy_badgeMinSize:(CGFloat)tfy_badgeMinSize{
    NSNumber *number = [NSNumber numberWithDouble:tfy_badgeMinSize];
    objc_setAssociatedObject(self, &UIView_badgeMinSizeKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.tfy_bgdge) {
        [self updateBadgeFrame];
    }
}

-(CGFloat)tfy_badgeOriginX{
    NSNumber *number = objc_getAssociatedObject(self, &UIView_badgeOriginXKey);
    return number.floatValue;
}

-(void)setTfy_badgeOriginX:(CGFloat)tfy_badgeOriginX{
    NSNumber *number = [NSNumber numberWithDouble:tfy_badgeOriginX];
    objc_setAssociatedObject(self, &UIView_badgeOriginXKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.tfy_bgdge) {
        [self updateBadgeFrame];
    }
}

-(CGFloat)tfy_badgeOriginY{
    NSNumber *number = objc_getAssociatedObject(self, &UIView_badgeOriginYKey);
    return number.floatValue;
}

-(void)setTfy_badgeOriginY:(CGFloat)tfy_badgeOriginY{
    NSNumber *number = [NSNumber numberWithDouble:tfy_badgeOriginY];
    objc_setAssociatedObject(self, &UIView_badgeOriginYKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.tfy_bgdge) {
        [self updateBadgeFrame];
    }
}

-(BOOL)tfy_shouldHideBadgeAtZero{
    NSNumber *number = objc_getAssociatedObject(self, &UIView_shouldHideBadgeAtZeroKey);
    return number.boolValue;
}

-(void)setTfy_shouldHideBadgeAtZero:(BOOL)tfy_shouldHideBadgeAtZero{
    NSNumber *number = [NSNumber numberWithBool:tfy_shouldHideBadgeAtZero];
    objc_setAssociatedObject(self, &UIView_shouldHideBadgeAtZeroKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)tfy_shouldAnimateBadge{
    NSNumber *number = objc_getAssociatedObject(self, &UIView_shouldAnimateBadgeKey);
    return number.boolValue;
}

-(void)setTfy_shouldAnimateBadge:(BOOL)tfy_shouldAnimateBadge{
    NSNumber *number = [NSNumber numberWithBool:tfy_shouldAnimateBadge];
    objc_setAssociatedObject(self, &UIView_shouldAnimateBadgeKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)removeBadge{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.tfy_bgdge.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        [self.tfy_bgdge removeFromSuperview];
    }];
}

-(void)badgeInit{
    
    self.tfy_badgeBGColor = [UIColor redColor];
    self.tfy_badgeTextColor = [UIColor whiteColor];
    self.tfy_badgeFont = [UIFont systemFontOfSize:12];
    self.tfy_badgePadding = 6;
    self.tfy_badgeMinSize = 8;
    self.tfy_badgeOriginX = self.frame.size.width - self.tfy_bgdge.frame.size.width/2;
    self.tfy_badgeOriginY = -4;
    self.tfy_shouldHideBadgeAtZero = YES;
    self.tfy_shouldAnimateBadge = YES;
    self.clipsToBounds = NO;
}

-(void)updateBadgeValueAnimated:(BOOL)animated{
    
    if (animated && self.tfy_shouldAnimateBadge && ![self.tfy_bgdge.text isEqualToString:self.tfy_badgeValue]) {
        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [animation setFromValue:[NSNumber numberWithFloat:1.5]];
        [animation setToValue:[NSNumber numberWithFloat:1]];
        [animation setDuration:0.2];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.4f :1.3f :1.f :1.f]];
        [self.tfy_bgdge.layer addAnimation:animation forKey:@"bounceAnimation"];
    }
    self.tfy_bgdge.text = self.tfy_badgeValue;

    NSTimeInterval duration = animated ? 0.2 : 0;
    [UIView animateWithDuration:duration animations:^{
        [self updateBadgeFrame];
    }];
}

-(void)updateBadgeFrame{
    
    CGSize expectedLabelSize = [self badgeExpectedSize];
    CGFloat minHeight = expectedLabelSize.height;
    minHeight = (minHeight < self.tfy_badgeMinSize) ? self.tfy_badgeMinSize : expectedLabelSize.height;
    CGFloat minWidth = expectedLabelSize.width;
    CGFloat padding = self.tfy_badgePadding;
    minWidth = (minWidth < minHeight) ? minHeight : expectedLabelSize.width;
    self.tfy_bgdge.frame = CGRectMake(self.tfy_badgeOriginX, self.tfy_badgeOriginY, minWidth + padding, minHeight + padding);
    self.tfy_bgdge.layer.cornerRadius = (minHeight + padding) / 2;
    self.tfy_bgdge.layer.masksToBounds = YES;
}

-(CGSize)badgeExpectedSize
{
    UILabel *frameLabel = [self duplicateLabel:self.tfy_bgdge];
    [frameLabel sizeToFit];
    
    CGSize expectedLabelSize = frameLabel.frame.size;
    return expectedLabelSize;
}

-(UILabel *)duplicateLabel:(UILabel *)labelToCopy{
    
    UILabel *duplicateLabel = [[UILabel alloc] initWithFrame:labelToCopy.frame];
    duplicateLabel.text = labelToCopy.text;
    duplicateLabel.font = labelToCopy.font;
    return duplicateLabel;
}

-(void)refreshBadge{

    self.tfy_bgdge.textColor = self.tfy_badgeTextColor;
    self.tfy_bgdge.backgroundColor = self.tfy_badgeBGColor;
    self.tfy_bgdge.font = self.tfy_badgeFont;
}


- (UIViewController *_Nonnull)viewController
{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    } while (next);
    return nil;
    
}

- (UINavigationController *_Nonnull)navigationController
{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)next;
            
        }
        next = next.nextResponder;
    } while (next);
    return nil;
    
}
- (UITabBarController *_Nonnull)tabBarController
{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UITabBarController class]]) {
            return (UITabBarController *)next;
        }
        next = next.nextResponder;
    } while (next);
    return nil;
}

-(void)tfy_setShadow:(CGSize)size shadowOpacity:(CGFloat)opacity shadowRadius:(CGFloat)radius shadowColor:(UIColor *)color{
    self.layer.shadowOffset = size;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowColor = color.CGColor;
}

/**
 *  添加点击事件
 */
- (void)addActionWithblock:(TouchCallBackBlock)block
{
    self.touchCallBackBlock = block;

    self.userInteractionEnabled = YES;
    
    /**
     *  添加相同事件方法，，先将原来的事件移除，避免重复调用
     */
    NSMutableArray *taps = [self allUIViewBlockTaps];
    [taps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UITapGestureRecognizer *tap = (UITapGestureRecognizer *)obj;
        [self removeGestureRecognizer:tap];
    }];
    [taps removeAllObjects];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(invoke:)];
    [self addGestureRecognizer:tap];
    [taps addObject:tap];
}

- (void)invoke:(id)sender
{
    if(self.touchCallBackBlock) {
        self.touchCallBackBlock();
    }
}

- (void)setTouchCallBackBlock:(TouchCallBackBlock)touchCallBackBlock
{
    objc_setAssociatedObject(self, &BlockKey, touchCallBackBlock, OBJC_ASSOCIATION_COPY);
}

- (TouchCallBackBlock)touchCallBackBlock
{
    return objc_getAssociatedObject(self, &BlockKey);
}

- (void)addTarget:(id)target action:(SEL)action
{
    self.userInteractionEnabled = YES;
    
    /**
     *  添加相同事件方法，，先将原来的事件移除，避免重复调用
     */
    NSMutableArray *taps = [self allUIViewBlockTaps];
    [taps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UITapGestureRecognizer *tap = (UITapGestureRecognizer *)obj;
        [self removeGestureRecognizer:tap];
    }];
    [taps removeAllObjects];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
    [taps addObject:tap];
}

- (NSMutableArray *)allUIViewBlockTaps
{
    NSMutableArray *taps = objc_getAssociatedObject(self, &BlockTapKey);
    if (!taps) {
        taps = [NSMutableArray array];
        objc_setAssociatedObject(self, &BlockTapKey, taps, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return taps;
}


#pragma mark -
- (void)tfy_layoutSubviews
{
    // 调用本身的实现
    [self tfy_layoutSubviews];
    BOOL isFrameChange = NO;;
    if(!CGRectEqualToRect(self.oldBounds, self.bounds)){
        isFrameChange = YES;
        self.oldBounds = self.bounds;
    }
    UIBezierPath *maskPath = [UIBezierPath  bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCorner)self.tfy_clipType cornerRadii:CGSizeMake(self.tfy_clipRadius, self.tfy_clipRadius)];
    if(self.needUpdateRadius || isFrameChange){
        self.needUpdateRadius = NO;
        if (self.tfy_clipType == CornerClipTypeNone || self.tfy_clipRadius <= 0) {
            // 以前使用了maskLayer，去掉
            if(self.layer.mask == self.maskLayer){
                self.layer.mask = nil;
            }
            self.maskLayer = nil;
        } else {
            if (self.layer.mask == nil) {
                self.maskLayer = [[CAShapeLayer alloc] init];
            }
            
            self.maskLayer.frame = self.bounds;
            self.maskLayer.path = maskPath.CGPath;
            self.layer.mask = self.maskLayer;
            
        }
    }
    
    if(self.tfy_borderWidth <= 0 || self.tfy_borderColor == nil){
        if(self.borderLayer){
            [self.borderLayer removeFromSuperlayer];
        }
        self.borderLayer = nil;
    }else{
        if(self.borderLayer == nil){
            self.borderLayer = [CAShapeLayer layer];
            self.borderLayer.lineWidth = self.tfy_borderWidth;
            self.borderLayer.fillColor = [UIColor clearColor].CGColor;
            self.borderLayer.strokeColor = self.tfy_borderColor.CGColor;
            self.borderLayer.frame = self.bounds;
            self.borderLayer.path = maskPath.CGPath;
            
            [self.layer addSublayer:self.borderLayer];
        }
        
    }
    //加边框用
    CGRect generalBound = self.leftLayer.bounds;
    CGPoint generalPoint = CGPointZero;
    UIEdgeInsets generalInset = self.leftLayer.tfy_border_Inset;
    
    //left
    generalBound.size.height = self.layer.bounds.size.height - generalInset.top - generalInset.bottom;//高度
    generalBound.size.width = self.leftLayer.tfy_border_Width;//宽度为border
    self.leftLayer.bounds = generalBound;
    
    generalPoint.x = generalInset.left;
    generalPoint.y = generalInset.top;
    self.leftLayer.position = generalPoint;
    
    generalBound = self.topLayer.bounds;
    generalPoint = self.topLayer.position;
    generalInset = self.topLayer.tfy_border_Inset;
    
    //top
    generalBound.size.height = self.topLayer.tfy_border_Width;
    generalBound.size.width = self.layer.bounds.size.width - generalInset.left - generalInset.right;
    self.topLayer.bounds = generalBound;
    
    generalPoint.x = generalInset.left;
    generalPoint.y = generalInset.top;
    self.topLayer.position = generalPoint;
    
    generalBound = self.rightLayer.bounds;
    generalPoint = self.rightLayer.position;
    generalInset = self.rightLayer.tfy_border_Inset;
    
    //right
    generalBound.size.height = self.layer.bounds.size.height - generalInset.top - generalInset.bottom;
    generalBound.size.width = self.rightLayer.tfy_border_Width;
    self.rightLayer.bounds = generalBound;
    
    generalPoint.x = self.layer.bounds.size.width - generalInset.right - generalBound.size.width;
    generalPoint.y = generalInset.top;
    self.rightLayer.position = generalPoint;
    
    generalBound = self.bottomLayer.bounds;
    generalPoint = self.bottomLayer.position;
    generalInset = self.bottomLayer.tfy_border_Inset;
    
    //bottom
    generalBound.size.height = self.bottomLayer.tfy_border_Width;
    generalBound.size.width = self.layer.bounds.size.width - generalInset.right - generalInset.left;
    self.bottomLayer.bounds = generalBound;
    
    generalPoint.x = generalInset.left;
    generalPoint.y = self.layer.bounds.size.height - generalInset.bottom - generalBound.size.height;
    self.bottomLayer.position = generalPoint;
    
    
}
/**
 * 便捷添加圆角  clipType 圆角类型  radius 圆角角度
 */
- (void)clipWithType:(CornerClipType)clipType radius:(CGFloat)radius
{
    self.tfy_clipType = clipType;
    self.tfy_clipRadius = radius;
}
/**
 * 便捷给添加border color 边框的颜色 borderWidth 边框的宽度
 */
- (void)addBorderWithColor:(UIColor *)color borderWidth:(CGFloat)borderWidth
{
    self.tfy_borderColor = color;
    self.tfy_borderWidth = borderWidth;
}
#pragma mark - getter && setter
#pragma mark - radisu
- (void)setTfy_clipType:(CornerClipType)tfy_clipType
{
    if(self.tfy_clipType == tfy_clipType){
        // 数值相同不需要修改
        return;
    }
    // 以get方法名为key
    objc_setAssociatedObject(self, @selector(tfy_clipType), @(tfy_clipType), OBJC_ASSOCIATION_RETAIN);
    self.needUpdateRadius = YES;
}
- (CornerClipType)tfy_clipType
{
    // 以get方面为key
    return [objc_getAssociatedObject(self, _cmd) unsignedIntegerValue];
}
- (void)setTfy_clipRadius:(CGFloat)tfy_clipRadius
{
    if(self.tfy_clipRadius == tfy_clipRadius){
        // 数值相同，不需要修改内如
        return;
    }
    // 以get方法名为key
    objc_setAssociatedObject(self, @selector(tfy_clipRadius), @(tfy_clipRadius), OBJC_ASSOCIATION_RETAIN);
    self.needUpdateRadius = YES;
}
- (CGFloat)tfy_clipRadius
{
    // 以get方面为key
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}
#pragma mark - border
- (void)setTfy_borderColor:(UIColor *)tfy_borderColor
{
    if(self.tfy_borderColor == tfy_borderColor){
        // 数值相同不需要修改
        return;
    }
    objc_setAssociatedObject(self, @selector(tfy_borderColor), tfy_borderColor, OBJC_ASSOCIATION_RETAIN);
    //self.needUpdateRadius = YES;
}
- (UIColor *)tfy_borderColor
{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setTfy_borderWidth:(CGFloat)tfy_borderWidth
{
    if(self.tfy_borderWidth == tfy_borderWidth){
        // 数值相同不需要修改
        return;
    }
    // 以get方法名为key
    objc_setAssociatedObject(self, @selector(tfy_borderWidth), @(tfy_borderWidth), OBJC_ASSOCIATION_RETAIN);
    //self.needUpdateRadius = YES;
}
- (CGFloat)tfy_borderWidth{
    // 以get方面为key
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}
- (void)setBorderLayer:(CAShapeLayer *)borderLayer
{
    objc_setAssociatedObject(self, @selector(borderLayer), borderLayer, OBJC_ASSOCIATION_RETAIN);
}
- (CAShapeLayer *)borderLayer
{
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark -
- (BOOL)needUpdateRadius
{
    // 以get方面为key
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setNeedUpdateRadius:(BOOL)needUpdateRadius
{
    // 以get方法名为key
    objc_setAssociatedObject(self, @selector(needUpdateRadius), @(needUpdateRadius), OBJC_ASSOCIATION_RETAIN);
}
- (void)setOldBounds:(CGRect)oldBounds
{
    // 以get方法名为key
    objc_setAssociatedObject(self, @selector(oldBounds), [NSValue valueWithCGRect:oldBounds], OBJC_ASSOCIATION_RETAIN);
}
- (CGRect)oldBounds
{
    // 以get方面为key
    return [objc_getAssociatedObject(self, _cmd) CGRectValue];
}
- (void)setMaskLayer:(CAShapeLayer *)maskLayer
{
    objc_setAssociatedObject(self, @selector(maskLayer), maskLayer, OBJC_ASSOCIATION_RETAIN);
}
- (CAShapeLayer *)maskLayer
{
    return objc_getAssociatedObject(self, _cmd);
}

- (NSMutableDictionary *)gestureBlocks{
    id obj = objc_getAssociatedObject(self, _cmd);
    if (!obj) {
        obj = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, @selector(gestureBlocks), obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return obj;
}
#pragma -------------------------------------加边框方法---------------------------------

- (void)addBorderWithInset:(UIEdgeInsets)inset Color:(UIColor *)borderColor direction:(BorderDirection)directions{
    [self addBorderWithInset:inset Color:borderColor BorderWidth:self.layer.borderWidth direction:directions];
}


- (void)addBorderWithInset:(UIEdgeInsets)inset BorderWidth:(CGFloat)borderWidth direction:(BorderDirection)directions{
    [self addBorderWithInset:inset Color:[UIColor colorWithCGColor:self.layer.borderColor] BorderWidth:borderWidth direction:directions];
}

- (void)addBorderWithColor:(UIColor *)borderColor BodrerWidth:(CGFloat)borderWidth direction:(BorderDirection)directions{
    [self addBorderWithInset:UIEdgeInsetsZero Color:borderColor BorderWidth:borderWidth direction:directions];
}

- (void)addBorderWithInset:(UIEdgeInsets)inset Color:(UIColor *)borderColor BorderWidth:(CGFloat)borderWidth direction:(BorderDirection)directions
{
    if (directions & BorderDirectionLeft) {
        
        self.leftLayer.backgroundColor = borderColor.CGColor;
        self.leftLayer.tfy_border_Width = borderWidth;
        self.leftLayer.tfy_border_Inset = inset;
        if (self.leftLayer.superlayer) { [self.leftLayer removeFromSuperlayer]; }
        [self.layer addSublayer:self.leftLayer];
    }
    
    if (directions & BorderDirectionTop) {
        
        self.topLayer.backgroundColor = borderColor.CGColor;
        self.topLayer.tfy_border_Width = borderWidth;
        self.topLayer.tfy_border_Inset = inset;
        if (self.topLayer.superlayer) { [self.topLayer removeFromSuperlayer]; }
        [self.layer addSublayer:self.topLayer];
    }
    
    if (directions & BorderDirectionRight) {
        
        self.rightLayer.backgroundColor = borderColor.CGColor;
        self.rightLayer.tfy_border_Width = borderWidth;
        self.rightLayer.tfy_border_Inset = inset;
        if (self.rightLayer.superlayer) { [self.rightLayer removeFromSuperlayer]; }
        [self.layer addSublayer:self.rightLayer];
    }
    
    if (directions & BorderDirectionBottom) {
        
        self.bottomLayer.backgroundColor = borderColor.CGColor;
        self.bottomLayer.tfy_border_Width = borderWidth;
        self.bottomLayer.tfy_border_Inset = inset;
        if (self.bottomLayer.superlayer) { [self.bottomLayer removeFromSuperlayer]; }
        [self.layer addSublayer:self.bottomLayer];
    }
    
    [self setNeedsLayout];
}

- (void)removeBorders:(BorderDirection)directions{
    if (directions & BorderDirectionLeft) {
        [self removeBorderLayer:self.leftLayer];
    }
    if (directions & BorderDirectionTop) {
        [self removeBorderLayer:self.topLayer];
    }
    if (directions & BorderDirectionRight) {
        [self removeBorderLayer:self.rightLayer];
    }
    if (directions & BorderDirectionBottom) {
        [self removeBorderLayer:self.bottomLayer];
    }
}

- (void)removeAllBorders{
    [self removeBorderLayer:self.leftLayer];
    [self removeBorderLayer:self.topLayer];
    [self removeBorderLayer:self.rightLayer];
    [self removeBorderLayer:self.bottomLayer];
}

- (void)removeBorderLayer:(CALayer *)layer{
    if (layer) {
        [layer removeFromSuperlayer];
    }
}

- (void)setLeftLayer:(BorderLayer *)leftLayer
{
    objc_setAssociatedObject(self, @selector(leftLayer), leftLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTopLayer:(BorderLayer *)topLayer
{
    objc_setAssociatedObject(self, @selector(topLayer), topLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setRightLayer:(BorderLayer *)rightLayer
{
    objc_setAssociatedObject(self, @selector(rightLayer), rightLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setBottomLayer:(BorderLayer *)bottomLayer
{
    objc_setAssociatedObject(self, @selector(bottomLayer), bottomLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BorderLayer *)leftLayer{
    id layer = objc_getAssociatedObject(self, _cmd);
    if (layer == nil) {
        self.leftLayer = BorderLayer.new;
    }
    return objc_getAssociatedObject(self, _cmd);
}

- (BorderLayer *)topLayer{
    id layer = objc_getAssociatedObject(self, _cmd);
    if (layer == nil) {
        self.topLayer = BorderLayer.new;
    }
    return objc_getAssociatedObject(self, _cmd);
}

- (BorderLayer *)rightLayer
{
    id layer = objc_getAssociatedObject(self, _cmd);
    if (layer == nil) {
        self.rightLayer = BorderLayer.new;
    }
    return objc_getAssociatedObject(self, _cmd);
}


- (BorderLayer *)bottomLayer{
    id layer = objc_getAssociatedObject(self, _cmd);
    if (layer == nil) {
        self.bottomLayer = BorderLayer.new;
    }
    return objc_getAssociatedObject(self, _cmd);
}

#pragma -------------------------------------手势点击添加方法---------------------------------

- (id)addGestureTarget:(id)target action:(SEL)action gestureClass:(Class)class {
    UIGestureRecognizer *gesture = [[class alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:gesture];
    return gesture;
}

- (UITapGestureRecognizer *)addGestureTapTarget:(id)target action:(SEL)action {
    return [self addGestureTarget:target action:action gestureClass:[UITapGestureRecognizer class]];
}

- (UIPanGestureRecognizer *)addGesturePanTarget:(id)target action:(SEL)action {
    return [self addGestureTarget:target action:action gestureClass:[UIPanGestureRecognizer class]];
}

- (UIPinchGestureRecognizer *)addGesturePinchTarget:(id)target action:(SEL)action {
    return [self addGestureTarget:target action:action gestureClass:[UIPinchGestureRecognizer class]];
}

- (UILongPressGestureRecognizer *)addGestureLongPressTarget:(id)target action:(SEL)action {
    return [self addGestureTarget:target action:action gestureClass:[UILongPressGestureRecognizer class]];
}

- (UISwipeGestureRecognizer *)addGestureSwipeTarget:(id)target action:(SEL)action {
    return [self addGestureTarget:target action:action gestureClass:[UISwipeGestureRecognizer class]];
}

- (UIRotationGestureRecognizer *)addGestureRotationTarget:(id)target action:(SEL)action {
    return [self addGestureTarget:target action:action gestureClass:[UIRotationGestureRecognizer class]];
}

- (UIScreenEdgePanGestureRecognizer *)addGestureScreenEdgePanTarget:(id)target action:(SEL)action {
    return [self addGestureTarget:target action:action gestureClass:[UIScreenEdgePanGestureRecognizer class]];
}

#pragma mark - Category Block Events

- (id)addGestureEventHandle:(void (^)(id, id))event gestureClass:(Class)class {
    UIGestureRecognizer *gesture = [[class alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
    [self addGestureRecognizer:gesture];
    if (event) {
        [[self gestureBlocks] setObject:event forKey:NSStringFromClass(class)];
    }
    return gesture;
}

- (UITapGestureRecognizer *)addGestureTapEventHandle:(void (^)(id sender, UITapGestureRecognizer *recognizer))event {
    return [self addGestureEventHandle:event gestureClass:[UITapGestureRecognizer class]];
}

- (UIPanGestureRecognizer *)addGesturePanEventHandle:(void (^)(id sender, UIPanGestureRecognizer *recognizer))event {
    return [self addGestureEventHandle:event gestureClass:[UIPanGestureRecognizer class]];
}

- (UIPinchGestureRecognizer *)addGesturePinchEventHandle:(void (^)(id sender, UIPinchGestureRecognizer *recognizer))event {
    return [self addGestureEventHandle:event gestureClass:[UIPinchGestureRecognizer class]];
}

- (UILongPressGestureRecognizer *)addGestureLongPressEventHandle:(void (^)(id sender, UILongPressGestureRecognizer *recognizer))event {
    return [self addGestureEventHandle:event gestureClass:[UILongPressGestureRecognizer class]];
}

- (UISwipeGestureRecognizer *)addGestureSwipeEventHandle:(void (^)(id sender, UISwipeGestureRecognizer *recognizer))event {
    return [self addGestureEventHandle:event gestureClass:[UISwipeGestureRecognizer class]];
}

- (UIRotationGestureRecognizer *)addGestureRotationEventHandle:(void (^)(id sender, UIRotationGestureRecognizer *recognizer))event {
    return [self addGestureEventHandle:event gestureClass:[UIRotationGestureRecognizer class]];
}

- (UIScreenEdgePanGestureRecognizer *)addGestureScreenEdgePanEventHandle:(void (^)(id sender, UIScreenEdgePanGestureRecognizer *recognizer))event {
    return [self addGestureEventHandle:event gestureClass:[UIScreenEdgePanGestureRecognizer class]];
}

#pragma mark -

- (void)handleGestureRecognizer:(UIGestureRecognizer *)gesture
{
    NSString *key = NSStringFromClass(gesture.class);
    void (^block)(id sender, UIGestureRecognizer *tap) = [self gestureBlocks][key];
    block ? block(self, gesture) : nil;
}

@end
