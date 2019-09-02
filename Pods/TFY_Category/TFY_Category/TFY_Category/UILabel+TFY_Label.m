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

@property (nonatomic, copy) NSString *tfy_str;

@property (nonatomic, assign) NSRange tfy_range;

@end

@implementation TFY_RichTextModel

@end


@implementation UILabel (TFY_Label)

/**
 *  初始化Label
 */
UILabel *tfy_label(void){
    return [UILabel new];
}

- (UILabel *(^)(NSString *text))tfy_text{
    WSelf(weakSelf);
    return ^(NSString *text){
        weakSelf.text = text;
        return weakSelf;
    };
}

- (UILabel *(^)(NSString *HexString,CGFloat alpha))tfy_textcolor{
    WSelf(weakSelf);
    return ^(NSString *HexString,CGFloat alpha){
        weakSelf.textColor = [weakSelf colorWithHexString:HexString alpha:alpha];
        return weakSelf;
    };
}

- (UILabel *(^)(CGFloat fontSize))tfy_fontSize{
    WSelf(weakSelf);
    return ^(CGFloat fontSize){
        weakSelf.font = [UIFont systemFontOfSize:fontSize];
        return weakSelf;
    };
}

- (UILabel *(^)(NSInteger alignment))tfy_alignment{
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

- (UILabel *(^)(NSAttributedString *attributrdString))tfy_attributrdString{
    WSelf(weakSelf);
    return ^(NSAttributedString *attributrdString){
        weakSelf.attributedText = attributrdString;
        return weakSelf;
    };
}

- (UILabel *(^)(NSInteger numberOfLines))tfy_numberOfLines{
    WSelf(weakSelf);
    return ^(NSInteger numberOfLines){
        weakSelf.numberOfLines = numberOfLines;
        return weakSelf;
    };
}

- (UILabel *(^)(BOOL adjustsWidth))tfy_adjustsWidth{
    WSelf(weakSelf);
    return ^(BOOL adjustsWidth){
        weakSelf.adjustsFontSizeToFitWidth = adjustsWidth;
        return weakSelf;
    };
}

-(UILabel *(^)(NSString *HexString,CGFloat alpha))tfy_backgroundColor{
    WSelf(weakSelf);
    return ^(NSString *str,CGFloat alpha){
        weakSelf.backgroundColor = [weakSelf colorWithHexString:str alpha:alpha];
        return weakSelf;
    };
}

-(UILabel *(^)(CGFloat borderWidth, NSString *color))tfy_borders{
    WSelf(weakSelf);
    return ^(CGFloat borderWidth, NSString *color){
        weakSelf.layer.borderWidth = borderWidth;
        weakSelf.layer.borderColor = [weakSelf colorWithHexString:color alpha:1].CGColor;
        return weakSelf;
    };
}
/**
 *  按钮  cornerRadius 圆角
 */
-(UILabel *(^)(CGFloat cornerRadius))tfy_cornerRadius{
    WSelf(myself);
    return ^(CGFloat cornerRadius){
        myself.layer.cornerRadius = cornerRadius;
        myself.layer.masksToBounds = YES;
        return myself;
    };
}
-(UILabel *(^)(NSString *color_str, CGFloat shadowRadius))tfy_bordersShadow{
    WSelf(weakSelf);
    return ^(NSString *color_str, CGFloat shadowRadius){
        // 阴影颜色
        weakSelf.layer.shadowColor = [weakSelf colorWithHexString:color_str alpha:1].CGColor;
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

- (NSMutableArray *)tfy_attributeStrings {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTfy_attributeStrings:(NSMutableArray *)tfy_attributeStrings {
    
    objc_setAssociatedObject(self, @selector(tfy_attributeStrings), tfy_attributeStrings, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)tfy_effectDic {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTfy_effectDic:(NSMutableDictionary *)tfy_effectDic {
    
    objc_setAssociatedObject(self, @selector(tfy_effectDic), tfy_effectDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)tfy_isClickAction {
    
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setTfy_isClickAction:(BOOL)tfy_isClickAction {
    
    objc_setAssociatedObject(self, @selector(tfy_isClickAction), @(tfy_isClickAction), OBJC_ASSOCIATION_ASSIGN);
}

- (void (^)(NSString * _Nonnull, NSRange, NSInteger))tfy_clickBlock {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTfy_clickBlock:(void (^)(NSString * _Nonnull, NSRange, NSInteger))tfy_clickBlock {
    
    objc_setAssociatedObject(self, @selector(tfy_clickBlock), tfy_clickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (id<TFY_RichTextDelegate>)delegate {
    
    return objc_getAssociatedObject(self, _cmd);
}

-(BOOL)tfy_enabledClickEffect {
    
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setTfy_enabledClickEffect:(BOOL)tfy_enabledClickEffect {
    
    objc_setAssociatedObject(self, @selector(tfy_enabledClickEffect), @(tfy_enabledClickEffect), OBJC_ASSOCIATION_ASSIGN);
    self.tfy_isClickEffect = tfy_enabledClickEffect;
}

- (UIColor *)tfy_clickEffectColor {
    
    UIColor *obj = objc_getAssociatedObject(self, _cmd);
    if(obj == nil) {obj = [UIColor lightGrayColor];}
    return obj;
}

- (void)setTfy_clickEffectColor:(UIColor *)tfy_clickEffectColor {
    
    objc_setAssociatedObject(self, @selector(tfy_clickEffectColor), tfy_clickEffectColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)tfy_isClickEffect {
    
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setTfy_isClickEffect:(BOOL)tfy_isClickEffect {
    
    objc_setAssociatedObject(self, @selector(tfy_isClickEffect), @(tfy_isClickEffect), OBJC_ASSOCIATION_ASSIGN);
}

- (void)setDelegate:(id<TFY_RichTextDelegate>)delegate {
    
    objc_setAssociatedObject(self, @selector(delegate), delegate, OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - mainFunction
- (void)tfy_clickRichTextWithStrings:(NSArray<NSString *> *)strings clickAction:(void (^)(NSString *, NSRange, NSInteger))clickAction {
    
    [self tfy_richTextRangesWithStrings:strings];
    
    if (self.tfy_clickBlock != clickAction) {
        self.tfy_clickBlock = clickAction;
    }
}

- (void)tfy_clickRichTextWithStrings:(NSArray<NSString *> *)strings delegate:(id<TFY_RichTextDelegate>)delegate {
    
    [self tfy_richTextRangesWithStrings:strings];
    
    if ([self delegate] != delegate) {
        
        [self setDelegate:delegate];
    }
}

#pragma mark - touchAction
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.tfy_isClickAction) {
        return;
    }
    
    if (objc_getAssociatedObject(self, @selector(tfy_enabledClickEffect))) {
        self.tfy_isClickEffect = self.tfy_enabledClickEffect;
    }
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    WSelf(weakself);
    [self tfy_richTextFrameWithTouchPoint:point result:^(NSString *string, NSRange range, NSInteger index) {
        
        if (weakself.tfy_clickBlock) {
            weakself.tfy_clickBlock (string , range , index);
        }
        
        if ([weakself delegate] && [[weakself delegate] respondsToSelector:@selector(tfy_didClickRichText:range:index:)]) {
            [[weakself delegate] tfy_didClickRichText:string range:range index:index];
        }
        
        if (weakself.tfy_isClickEffect) {
            
            [weakself tfy_saveEffectDicWithRange:range];
            
            [weakself tfy_clickEffectWithStatus:YES];
        }
    }];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if((self.tfy_isClickAction) && ([self tfy_richTextFrameWithTouchPoint:point result:nil])) {
        
        return self;
    }
    return [super hitTest:point withEvent:event];
}

#pragma mark - getClickFrame
- (BOOL)tfy_richTextFrameWithTouchPoint:(CGPoint)point result:(void (^) (NSString *string , NSRange range , NSInteger index))resultBlock
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedText);
    
    CGMutablePathRef Path = CGPathCreateMutable();
    
    CGPathAddRect(Path, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    
    CFRange range = CTFrameGetVisibleStringRange(frame);
    
    if (self.attributedText.length > range.length) {
        
        UIFont *font ;
        
        if ([self.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:nil]) {
            
            font = [self.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:nil];
            
        }else if (self.font){
            font = self.font;
            
        }else {
            font = [UIFont systemFontOfSize:17];
        }
        
        CGPathRelease(Path);
        
        Path = CGPathCreateMutable();
        
        CGPathAddRect(Path, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height + font.lineHeight));
        
        frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    
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
    
    CGFloat verticalOffset = 0;
    
    for (CFIndex i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        
        CGRect flippedRect = [self tfy_getLineBounds:line point:linePoint];
        
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        
        rect = CGRectInset(rect, 0, 0);
        
        rect = CGRectOffset(rect, 0, verticalOffset);
        
        NSParagraphStyle *style = [self.attributedText attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:nil];
        
        CGFloat lineSpace;
        
        if (style) {
            lineSpace = style.lineSpacing;
        }else {
            lineSpace = 0;
        }
        
        CGFloat lineOutSpace = (self.bounds.size.height - lineSpace * (count - 1) -rect.size.height * count) / 2;
        
        rect.origin.y = lineOutSpace + rect.size.height * i + lineSpace * i;
        
        if (CGRectContainsPoint(rect, point)) {
            
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect), point.y - CGRectGetMinY(rect));
            
            CFIndex index = CTLineGetStringIndexForPosition(line, relativePoint);
            
            CGFloat offset;
            
            CTLineGetOffsetForStringIndex(line, index, &offset);
            
            if (offset > relativePoint.x) {
                index = index - 1;
            }
            
            NSInteger link_count = self.tfy_attributeStrings.count;
            
            for (int j = 0; j < link_count; j++) {
                
                TFY_RichTextModel *model = self.tfy_attributeStrings[j];
                
                NSRange link_range = model.tfy_range;
                if (NSLocationInRange(index, link_range)) {
                    if (resultBlock) {
                        resultBlock (model.tfy_str , model.tfy_range , (NSInteger)j);
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

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.tfy_isClickEffect) {
        
        [self performSelectorOnMainThread:@selector(tfy_clickEffectWithStatus:) withObject:nil waitUntilDone:NO];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.tfy_isClickEffect) {
        
        [self performSelectorOnMainThread:@selector(tfy_clickEffectWithStatus:) withObject:nil waitUntilDone:NO];
    }
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
    CGFloat height = ascent + fabs(descent) + leading;
    
    return CGRectMake(point.x, point.y , width, height);
}

#pragma mark - clickEffect
- (void)tfy_clickEffectWithStatus:(BOOL)status
{
    if (self.tfy_isClickEffect) {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        
        NSMutableAttributedString *subAtt = [[NSMutableAttributedString alloc] initWithAttributedString:[[self.tfy_effectDic allValues] firstObject]];
        
        NSRange range = NSRangeFromString([[self.tfy_effectDic allKeys] firstObject]);
        
        if (status) {
            [subAtt addAttribute:NSBackgroundColorAttributeName value:self.tfy_clickEffectColor range:NSMakeRange(0, subAtt.string.length)];
            
            [attStr replaceCharactersInRange:range withAttributedString:subAtt];
        }else {
            
            [attStr replaceCharactersInRange:range withAttributedString:subAtt];
        }
        self.attributedText = attStr;
    }
}

- (void)tfy_saveEffectDicWithRange:(NSRange)range
{
    self.tfy_effectDic = [NSMutableDictionary dictionary];
    
    NSAttributedString *subAttribute = [self.attributedText attributedSubstringFromRange:range];
    
    [self.tfy_effectDic setObject:subAttribute forKey:NSStringFromRange(range)];
}

#pragma mark - getRange
- (void)tfy_richTextRangesWithStrings:(NSArray <NSString *>  *)strings
{
    if (self.attributedText == nil) {
        self.tfy_isClickAction = NO;
        return;
    }
    
    self.tfy_isClickAction = YES;
    
    self.tfy_isClickEffect = YES;
    
    __block  NSString *totalStr = self.attributedText.string;
    
    self.tfy_attributeStrings = [NSMutableArray array];
    
    WSelf(weakself);
    [strings enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSRange range = [totalStr rangeOfString:obj];
        
        if (range.length != 0) {
            
            totalStr = [totalStr stringByReplacingCharactersInRange:range withString:[weakself tfy_getStringWithRange:range]];
            
            TFY_RichTextModel *model = [[TFY_RichTextModel alloc]init];
            
            model.tfy_range = range;
            
            model.tfy_str = obj;
            
            [weakself.tfy_attributeStrings addObject:model];
        }
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

@end
