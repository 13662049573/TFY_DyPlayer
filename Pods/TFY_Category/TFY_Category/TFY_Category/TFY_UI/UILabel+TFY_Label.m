//
//  UILabel+TFY_Label.m
//  TFY_CHESHI
//
//  Created by 田风有 on 2018/8/16.
//  Copyright © 2018年 田风有. All rights reserved.
//

#import "UILabel+TFY_Label.h"
#import <objc/runtime.h>
#import <CoreText/CoreText.h>
#import <Foundation/Foundation.h>

#define WSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface TFY_RichTextModel : NSObject

@property (nonatomic, copy) NSString *str;

@property (nonatomic) NSRange range;

@end

@implementation TFY_RichTextModel

@end

@implementation NSAttributedString (TFY_Chain)

+(NSAttributedString *)getAttributeId:(id)sender string:(NSString *)string orginFont:(CGFloat)orginFont orginColor:(UIColor *)orginColor attributeFont:(CGFloat)attributeFont attributeColor:(UIColor *)attributeColor
{
    __block  NSMutableAttributedString *totalStr = [[NSMutableAttributedString alloc] initWithString:string];
    [totalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:orginFont] range:NSMakeRange(0, string.length)];
    [totalStr addAttribute:NSForegroundColorAttributeName value:orginColor range:NSMakeRange(0, string.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5.0f]; //设置行间距
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    [totalStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [totalStr length])];
    
    if ([sender isKindOfClass:[NSArray class]]) {
        
        __block NSString *oringinStr = string;
        __weak typeof(self) weakSelf = self;
        
        [sender enumerateObjectsUsingBlock:^(NSString *  _Nonnull str, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSRange range = [oringinStr rangeOfString:str];
            [totalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:attributeFont] range:range];
            [totalStr addAttribute:NSForegroundColorAttributeName value:attributeColor range:range];
            oringinStr = [oringinStr stringByReplacingCharactersInRange:range withString:[weakSelf getStringWithRange:range]];
        }];
        
    }else if ([sender isKindOfClass:[NSString class]]) {
        
        NSRange range = [string rangeOfString:sender];
        
        [totalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:attributeFont] range:range];
        [totalStr addAttribute:NSForegroundColorAttributeName value:attributeColor range:range];
    }
    return totalStr;
}

+ (NSString *)getStringWithRange:(NSRange)range
{
    NSMutableString *string = [NSMutableString string];
    for (int i = 0; i < range.length ; i++) {
        [string appendString:@" "];
    }
    return string;
}


@end


@implementation UILabel (TFY_Label)

- (UILabel *(^)(NSString *))tfy_text{
    WSelf(weakSelf);
    return ^(NSString *text){
        weakSelf.text = text;
        return weakSelf;
    };
}

- (UILabel *(^)(id,CGFloat))tfy_textcolor{
    WSelf(weakSelf);
    return ^(id HexString,CGFloat alpha){
        if ([HexString isKindOfClass:[NSString class]]) {
            weakSelf.textColor = [weakSelf colorWithHexString:HexString alpha:alpha];
        }
        if ([HexString isKindOfClass:[UIColor class]]) {
            weakSelf.textColor = HexString;
        }
        return weakSelf;
    };
}

- (UILabel *(^)(UIFont *))tfy_fontSize{
    WSelf(weakSelf);
    return ^(UIFont *fontSize){
        weakSelf.font = fontSize;
        return weakSelf;
    };
}

- (UILabel *(^)(NSInteger))tfy_alignment{
    WSelf(weakSelf);
    return ^(NSInteger alignment){
        if (alignment==0) {
            weakSelf.textAlignment = NSTextAlignmentLeft;
        }
        else if (alignment==1){
            weakSelf.textAlignment = NSTextAlignmentCenter;
        }
        else if (alignment ==2){
            weakSelf.textAlignment = NSTextAlignmentRight;
        }
        return weakSelf;
    };
}

- (UILabel *(^)(NSAttributedString *))tfy_attributrdString{
    WSelf(weakSelf);
    return ^(NSAttributedString *attributrdString){
        weakSelf.attributedText = attributrdString;
        return weakSelf;
    };
}

- (UILabel *(^)(NSInteger))tfy_numberOfLines{
    WSelf(weakSelf);
    return ^(NSInteger numberOfLines){
        weakSelf.numberOfLines = numberOfLines;
        return weakSelf;
    };
}

/**
 * 文字省略格式
 */
- (UILabel *(^)(NSLineBreakMode))tfy_lineBreakMode{
    WSelf(weakSelf);
    return ^(NSLineBreakMode mode){
        weakSelf.lineBreakMode = mode;
        return weakSelf;
    };
}
- (UILabel *(^)(BOOL))tfy_adjustsWidth{
    WSelf(weakSelf);
    return ^(BOOL adjustsWidth){
        weakSelf.adjustsFontSizeToFitWidth = adjustsWidth;
        return weakSelf;
    };
}

-(UILabel *(^)(id,CGFloat))tfy_backgroundColor{
    WSelf(weakSelf);
    return ^(id str,CGFloat alpha){
        if ([str isKindOfClass:[NSString class]]) {
            weakSelf.backgroundColor = [weakSelf colorWithHexString:str alpha:alpha];
        }
        if ([str isKindOfClass:[UIColor class]]) {
            weakSelf.backgroundColor = str;
        }
        return weakSelf;
    };
}

-(UILabel *(^)(CGFloat, id))tfy_borders{
    WSelf(weakSelf);
    return ^(CGFloat borderWidth, id color){
        weakSelf.layer.borderWidth = borderWidth;
        if ([color isKindOfClass:[NSString class]]) {
            weakSelf.layer.borderColor = [weakSelf colorWithHexString:color alpha:1].CGColor;
        }
        if ([color isKindOfClass:[UIColor class]]) {
            weakSelf.layer.borderColor = [(UIColor *)color CGColor];
        }
        return weakSelf;
    };
}
/**
 *  按钮  cornerRadius 圆角
 */
-(UILabel *(^)(CGFloat))tfy_cornerRadius{
    WSelf(myself);
    return ^(CGFloat cornerRadius){
        myself.layer.cornerRadius = cornerRadius;
        myself.layer.masksToBounds = YES;
        return myself;
    };
}

/**
 *  添加指定的View
 */
-(UILabel *(^)(UIView *))tfy_addToSuperView{
    WSelf(myself);
    return ^(UIView *view){
        [view addSubview:myself];
        return myself;
    };
}

/**
 * 隐藏本类
 */
-(UILabel *(^)(BOOL))tfy_hidden{
    WSelf(myself);
    return ^(BOOL hidden){
        myself.hidden = hidden;
        return myself;
    };
}
/**
 * 透明度
 */
-(UILabel *(^)(CGFloat))tfy_alpha{
    WSelf(myself);
    return ^(CGFloat alpha){
        myself.alpha = alpha;
        return myself;
    };
}
/**
 * 交互开关
 */
-(UILabel *(^)(BOOL))tfy_userInteractionEnabled{
    WSelf(myself);
    return ^(BOOL userInteractionEnabled){
        myself.userInteractionEnabled = userInteractionEnabled;
        return myself;
    };
}

-(UILabel *(^)(id, CGFloat))tfy_bordersShadow{
    WSelf(weakSelf);
    return ^(id color_str, CGFloat shadowRadius){
        // 阴影颜色
        if ([color_str isKindOfClass:[NSString class]]) {
            weakSelf.layer.shadowColor = [weakSelf colorWithHexString:color_str alpha:1].CGColor;
        }
        if ([color_str isKindOfClass:[UIColor class]]) {
            weakSelf.layer.shadowColor = [(UIColor *)color_str CGColor];
        }
        // 阴影偏移，默认(0, -3)
        weakSelf.layer.shadowOffset = CGSizeMake(0,0);
        // 阴影透明度，默认0
        weakSelf.layer.shadowOpacity = 0.5;
        // 阴影半径，默认3
        weakSelf.layer.shadowRadius = shadowRadius;
        
        return weakSelf;
    };
}




-(UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
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

#pragma mark - AssociatedObjects

- (NSMutableArray *)attributeStrings
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAttributeStrings:(NSMutableArray *)attributeStrings
{
    objc_setAssociatedObject(self, @selector(attributeStrings), attributeStrings, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)effectDic
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setEffectDic:(NSMutableDictionary *)effectDic
{
    objc_setAssociatedObject(self, @selector(effectDic), effectDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isTapAction
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsTapAction:(BOOL)isTapAction
{
    objc_setAssociatedObject(self, @selector(isTapAction), @(isTapAction), OBJC_ASSOCIATION_ASSIGN);
}

- (void (^)(UILabel *, NSString *, NSRange, NSInteger))tapBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTapBlock:(void (^)(UILabel *, NSString *, NSRange, NSInteger))tapBlock
{
    objc_setAssociatedObject(self, @selector(tapBlock), tapBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (id<TFY_RichTextDelegate>)delegate
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDelegate:(id<TFY_RichTextDelegate>)delegate
{
    objc_setAssociatedObject(self, @selector(delegate), delegate, OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)enabledTapEffect
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setEnabledTapEffect:(BOOL)enabledTapEffect
{
    objc_setAssociatedObject(self, @selector(enabledTapEffect), @(enabledTapEffect), OBJC_ASSOCIATION_ASSIGN);
    self.isTapEffect = enabledTapEffect;
}

- (BOOL)enlargeTapArea
{
    NSNumber * number = objc_getAssociatedObject(self, _cmd);
    if (!number) {
        number = @(YES);
        objc_setAssociatedObject(self, _cmd, number, OBJC_ASSOCIATION_ASSIGN);
    }
    return [number boolValue];
}

- (void)setEnlargeTapArea:(BOOL)enlargeTapArea
{
    objc_setAssociatedObject(self, @selector(enlargeTapArea), @(enlargeTapArea), OBJC_ASSOCIATION_ASSIGN);
}

- (UIColor *)tapHighlightedColor
{
    UIColor * color = objc_getAssociatedObject(self, _cmd);
    if (!color) {
        color = [UIColor lightGrayColor];
        objc_setAssociatedObject(self, _cmd, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return color;
}

- (void)setTapHighlightedColor:(UIColor *)tapHighlightedColor
{
    objc_setAssociatedObject(self, @selector(tapHighlightedColor), tapHighlightedColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isTapEffect
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsTapEffect:(BOOL)isTapEffect
{
    objc_setAssociatedObject(self, @selector(isTapEffect), @(isTapEffect), OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - mainFunction
- (void)tfy_addAttributeTapActionWithStrings:(NSArray <NSString *> *)strings tapClicked:(void (^) (UILabel * label, NSString *string, NSRange range, NSInteger index))tapClick
{
    [self tfy_removeAttributeTapActions];
    [self tfy_getRangesWithStrings:strings];
    self.userInteractionEnabled = YES;
    
    if (self.tapBlock != tapClick) {
        self.tapBlock = tapClick;
    }
}

- (void)tfy_addAttributeTapActionWithStrings:(NSArray <NSString *> *)strings delegate:(id <TFY_RichTextDelegate> )delegate
{
    [self tfy_removeAttributeTapActions];
    [self tfy_getRangesWithStrings:strings];
    self.userInteractionEnabled = YES;
    
    if (self.delegate != delegate) {
        self.delegate = delegate;
    }
}

- (void)tfy_addAttributeTapActionWithRanges:(NSArray<NSString *> *)ranges tapClicked:(void (^)(UILabel *, NSString *, NSRange, NSInteger))tapClick
{
    [self tfy_removeAttributeTapActions];
    [self tfy_getRangesWithRanges:ranges];
    self.userInteractionEnabled = YES;
    
    if (self.tapBlock != tapClick) {
        self.tapBlock = tapClick;
    }
}

- (void)tfy_addAttributeTapActionWithRanges:(NSArray<NSString *> *)ranges delegate:(id<TFY_RichTextDelegate>)delegate
{
    [self tfy_removeAttributeTapActions];
    [self tfy_getRangesWithRanges:ranges];
    self.userInteractionEnabled = YES;
    
    if (self.delegate != delegate) {
        self.delegate = delegate;
    }
}

- (void)tfy_removeAttributeTapActions
{
    self.tapBlock = nil;
    self.delegate = nil;
    self.effectDic = nil;
    self.isTapAction = NO;
    self.attributeStrings = [NSMutableArray array];
}

#pragma mark - touchAction
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.isTapAction) {
        [super touchesBegan:touches withEvent:event];
        return;
    }
    
    if (objc_getAssociatedObject(self, @selector(enabledTapEffect))) {
        self.isTapEffect = self.enabledTapEffect;
    }
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    __weak typeof(self) weakSelf = self;
    
    BOOL ret = [self tfy_getTapFrameWithTouchPoint:point result:^(NSString *string, NSRange range, NSInteger index) {
        
        if (weakSelf.isTapEffect) {
            
            [weakSelf tfy_saveEffectDicWithRange:range];
            
            [weakSelf tfy_tapEffectWithStatus:YES];
        }
        
    }];
    if (!ret) {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.isTapAction) {
        [super touchesEnded:touches withEvent:event];
        return;
    }
    if (self.isTapEffect) {
        [self performSelectorOnMainThread:@selector(tfy_tapEffectWithStatus:) withObject:nil waitUntilDone:NO];
    }
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    __weak typeof(self) weakSelf = self;
    
    BOOL ret = [self tfy_getTapFrameWithTouchPoint:point result:^(NSString *string, NSRange range, NSInteger index) {
        if (weakSelf.tapBlock) {
            weakSelf.tapBlock (weakSelf, string, range, index);
        }
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(tfy_tapAttributeInLabel:string:range:index:)]) {
            [weakSelf.delegate tfy_tapAttributeInLabel:weakSelf string:string range:range index:index];
        }
    }];
    if (!ret) {
        [super touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.isTapAction) {
        [super touchesCancelled:touches withEvent:event];
        return;
    }
    if (self.isTapEffect) {
        [self performSelectorOnMainThread:@selector(tfy_tapEffectWithStatus:) withObject:nil waitUntilDone:NO];
    }
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    __weak typeof(self) weakSelf = self;
    
    BOOL ret = [self tfy_getTapFrameWithTouchPoint:point result:^(NSString *string, NSRange range, NSInteger index) {
        if (weakSelf.tapBlock) {
            weakSelf.tapBlock (weakSelf, string, range, index);
        }
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(tfy_tapAttributeInLabel:string:range:index:)]) {
            [weakSelf.delegate tfy_tapAttributeInLabel:weakSelf string:string range:range index:index];
        }
    }];
    if (!ret) {
        [super touchesCancelled:touches withEvent:event];
    }
}

#pragma mark - getTapFrame
- (BOOL)tfy_getTapFrameWithTouchPoint:(CGPoint)point result:(void (^) (NSString *string , NSRange range , NSInteger index))resultBlock
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedText);
    
    CGMutablePathRef Path = CGPathCreateMutable();
    
    CGPathAddRect(Path, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height + 20));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    
    CFArrayRef lines = CTFrameGetLines(frame);
    
    CGFloat total_height =  [self tfy_textSizeWithAttributedString:self.attributedText width:self.bounds.size.width numberOfLines:0].height;
    
    if (!lines) {
        CFRelease(frame);
        CFRelease(framesetter);
        CGPathRelease(Path);
        return NO;
    }
    
    CFIndex count = CFArrayGetCount(lines);
    
    CGPoint origins[count];
    
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    
    CGAffineTransform transform = [self tfy_transformForCoreText];
    
    for (CFIndex i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        
        CGRect flippedRect = [self tfy_getLineBounds:line point:linePoint];
        
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        
        CGFloat lineOutSpace = (self.bounds.size.height - total_height) / 2;
        
        rect.origin.y = lineOutSpace + [self tfy_getLineOrign:line];
        
        if (self.enlargeTapArea) {
            rect.origin.y -= 5;
            rect.size.height += 10;
        }
        
        if (CGRectContainsPoint(rect, point)) {
            
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect), point.y - CGRectGetMinY(rect));

            CFIndex index = CTLineGetStringIndexForPosition(line, relativePoint);
            
            CGFloat offset;
            
            CTLineGetOffsetForStringIndex(line, index, &offset);
            
            if (offset > relativePoint.x) {
                index = index - 1;
            }
            
            NSInteger link_count = self.attributeStrings.count;
            
            for (int j = 0; j < link_count; j++) {
                
                TFY_RichTextModel *model = self.attributeStrings[j];
                
                NSRange link_range = model.range;
                if (NSLocationInRange(index, link_range)) {
                    if (resultBlock) {
                        resultBlock (model.str , model.range , (NSInteger)j);
                    }
                    CFRelease(frame);
                    CFRelease(framesetter);
                    CGPathRelease(Path);
                    return YES;
                }
            }
        }
    }
    CFRelease(frame);
    CFRelease(framesetter);
    CGPathRelease(Path);
    return NO;
}

- (CGAffineTransform)tfy_transformForCoreText
{
    return CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f);
}

- (CGRect)tfy_getLineBounds:(CTLineRef)line point:(CGPoint)point
{
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = 0.0f;
    
    CFRange range = CTLineGetStringRange(line);
    NSAttributedString * attributedString = [self.attributedText attributedSubstringFromRange:NSMakeRange(range.location, range.length)];
    if ([attributedString.string hasSuffix:@"\n"] && attributedString.string.length > 1) {
        attributedString = [attributedString attributedSubstringFromRange:NSMakeRange(0, attributedString.length - 1)];
    }
    height = [self tfy_textSizeWithAttributedString:attributedString width:self.bounds.size.width numberOfLines:0].height;
    return CGRectMake(point.x, point.y , width, height);
}

- (CGFloat)tfy_getLineOrign:(CTLineRef)line
{
    CFRange range = CTLineGetStringRange(line);
    if (range.location == 0) {
        return 0.;
    }else {
        NSAttributedString * attributedString = [self.attributedText attributedSubstringFromRange:NSMakeRange(0, range.location)];
        if ([attributedString.string hasSuffix:@"\n"] && attributedString.string.length > 1) {
            attributedString = [attributedString attributedSubstringFromRange:NSMakeRange(0, attributedString.length - 1)];
        }
        return [self tfy_textSizeWithAttributedString:attributedString width:self.bounds.size.width numberOfLines:0].height;
    }
}

- (CGSize)tfy_textSizeWithAttributedString:(NSAttributedString *)attributedString width:(float)width numberOfLines:(NSInteger)numberOfLines
{
    @autoreleasepool {
        UILabel *sizeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        sizeLabel.numberOfLines = numberOfLines;
        sizeLabel.attributedText = attributedString;
        CGSize fitSize = [sizeLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)];
        return fitSize;
    }
}

#pragma mark - tapEffect
- (void)tfy_tapEffectWithStatus:(BOOL)status
{
    if (self.isTapEffect) {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        
        NSMutableAttributedString *subAtt = [[NSMutableAttributedString alloc] initWithAttributedString:[[self.effectDic allValues] firstObject]];
        
        NSRange range = NSRangeFromString([[self.effectDic allKeys] firstObject]);
        
        if (status) {
            [subAtt addAttribute:NSBackgroundColorAttributeName value:self.tapHighlightedColor range:NSMakeRange(0, subAtt.string.length)];
            
            [attStr replaceCharactersInRange:range withAttributedString:subAtt];
        }else {
            
            [attStr replaceCharactersInRange:range withAttributedString:subAtt];
        }
        self.attributedText = attStr;
    }
}

- (void)tfy_saveEffectDicWithRange:(NSRange)range
{
    self.effectDic = [NSMutableDictionary dictionary];
    
    NSAttributedString *subAttribute = [self.attributedText attributedSubstringFromRange:range];
    
    [self.effectDic setObject:subAttribute forKey:NSStringFromRange(range)];
}

#pragma mark - getRange
- (void)tfy_getRangesWithStrings:(NSArray <NSString *>  *)strings
{
    if (self.attributedText == nil) {
        self.isTapAction = NO;
        return;
    }
    self.isTapAction = YES;
    self.isTapEffect = YES;
    __block  NSString *totalStr = self.attributedText.string;
    self.attributeStrings = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    
    [strings enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSRange range = [totalStr rangeOfString:obj];
        
        if (range.length != 0) {
            
            totalStr = [totalStr stringByReplacingCharactersInRange:range withString:[weakSelf tfy_getStringWithRange:range]];
            
            TFY_RichTextModel *model = [TFY_RichTextModel new];
            model.range = range;
            model.str = obj;
            [weakSelf.attributeStrings addObject:model];
            
        }
        
    }];
}

- (void)tfy_getRangesWithRanges:(NSArray <NSString *>  *)ranges
{
    if (self.attributedText == nil) {
        self.isTapAction = NO;
        return;
    }
    
    self.isTapAction = YES;
    self.isTapEffect = YES;
    __block  NSString *totalStr = self.attributedText.string;
    self.attributeStrings = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    
    [ranges enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = NSRangeFromString(obj);
        NSAssert(totalStr.length >= range.location + range.length, @"NSRange(%lu,%lu) is out of bounds",(unsigned long)range.location,(unsigned long)range.length);
        NSString * string = [totalStr substringWithRange:range];
        
        TFY_RichTextModel *model = [TFY_RichTextModel new];
        model.range = range;
        model.str = string;
        [weakSelf.attributeStrings addObject:model];
    }];
}

- (NSString *)tfy_getStringWithRange:(NSRange)range
{
    NSMutableString *string = [NSMutableString string];
    
    for (int i = 0; i < range.length ; i++) {
        
        [string appendString:@" "];
    }
    return string;
}

#pragma mark - KVO
- (void)tfy_addObserver
{
    [self addObserver:self forKeyPath:@"attributedText" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
}

- (void)tfy_removeObserver
{
    id info = self.observationInfo;
    NSString * key = @"attributedText";
    NSArray *array = [info valueForKey:@"_observances"];
    for (id objc in array) {
        id Properties = [objc valueForKeyPath:@"_property"];
        NSString *keyPath = [Properties valueForKeyPath:@"_keyPath"];
        if ([key isEqualToString:keyPath]) {
            [self removeObserver:self forKeyPath:@"attributedText" context:nil];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"attributedText"]) {
        if (self.isTapAction) {
            if (![change[NSKeyValueChangeNewKey] isEqual: change[NSKeyValueChangeOldKey]]) {
               
            }
        }
    }
}


@end
