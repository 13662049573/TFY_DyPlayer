//
//  UITextView+TFY_Chain.m
//  TFY_Category
//
//  Created by 田风有 on 2019/7/26.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "UITextView+TFY_Chain.h"
#import <objc/runtime.h>

#define WSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;

static char *labelKey = "placeholderKey";
static char *needAdjust = "needAdjust";
static char *changeLocation = "location";

@implementation UITextView (TFY_Chain)
/**
 *  按钮初始化
 */
UITextView *tfy_textView(void){
    return [[UITextView alloc] init];
}
/**
 *  文本输入
 */
-(UITextView *(^)(NSString *title_str))tfy_text{
    WSelf(myself);
    return ^(NSString *title_str){
        myself.text = title_str;
        return myself;
    };
}
/**
 *  文本颜色
 */
-(UITextView *(^)(UIColor *color_str))tfy_textcolor{
    WSelf(myself);
    return ^(UIColor *color_str){
        myself.textColor = color_str;
        return myself;
    };
}
/**
 *  文本大小
 */
-(UITextView *(^)(CGFloat font))tfy_font{
    WSelf(myself);
    return ^(CGFloat font){
        myself.font = [UIFont systemFontOfSize:font];
        return myself;
    };
}

/**
 *  按钮 title_str 文本文字 color_str 文字颜色  font文字大小
 */
-(UITextView *(^)(NSString *title_str,UIColor *color_str,CGFloat font))tfy_title{
    WSelf(myself);
    return ^(NSString *title_str,UIColor *color_str,CGFloat font){
        myself.text = title_str;
        myself.textColor = color_str;
        myself.font = [UIFont systemFontOfSize:font];
        return myself;
    };
}
/**
 *  按钮  HexString 背景颜色 alpha 背景透明度
 */
-(UITextView *(^)(UIColor *color))tfy_backgroundColor{
    WSelf(myself);
    return ^(UIColor *color){
        myself.backgroundColor = color;
        return myself;
    };
}
/**
 *  按钮  alignment 0 左 1 中 2 右
 */
-(UITextView *(^)(NSInteger alignment))tfy_alAlignment{
    WSelf(myself);
    return ^(NSInteger alignment){
        switch (alignment) {
            case 0:
                myself.textAlignment = NSTextAlignmentLeft;
                break;
            case 1:
                myself.textAlignment =NSTextAlignmentCenter;
                break;
            case 2:
                myself.textAlignment =NSTextAlignmentRight;
                break;
        }
        return myself;
    };
}
/**
 *  添加四边框和color 颜色  borderWidth 宽度
 */
-(UITextView *(^)(CGFloat borderWidth, UIColor *color))tfy_borders{
    WSelf(myself);
    return ^(CGFloat borderWidth, UIColor *color){
        myself.layer.borderWidth = borderWidth;
        myself.layer.borderColor = color.CGColor;
        return myself;
    };
}
/**
 *  添加四边 color_str阴影颜色  shadowRadius阴影半径
 */
-(UITextView *(^)(UIColor *color, CGFloat shadowRadius))tfy_bordersShadow{
    WSelf(myself);
    return ^(UIColor *color, CGFloat shadowRadius){
        // 阴影颜色
        myself.layer.shadowColor = color.CGColor;
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
-(UITextView *(^)(CGFloat cornerRadius))tfy_cornerRadius{
    WSelf(myself);
    return ^(CGFloat cornerRadius){
        myself.layer.cornerRadius = cornerRadius;
        return myself;
    };
}
/**
 *  按钮  image_str 图片字符串
 */
-(UITextView *(^)(bool editable))tfy_editable{
    WSelf(myself);
    return ^(bool editable){
        myself.editable = editable;
        return myself;
    };
}
/**
 * 编辑框中的内容密码显示
 */
-(UITextView *(^)(bool secure))tfy_secureTextEntry{
    WSelf(myself);
    return ^(bool secure){
        myself.secureTextEntry = secure;
        return myself;
    };
}

/**
 *  自定义键盘  inputView 自定义输入区域
 */
-(UITextView *(^)(UIView *inputView))tfy_inputView{
    WSelf(myself);
    return ^(UIView *inputView){
        myself.inputView =  inputView;
        return myself;
    };
}
/**
 *  自定义键盘 /键盘上加view
 */
-(UITextView *(^)(UIView *inputAccessoryView))tfy_inputAccessoryView{
    WSelf(myself);
    return ^(UIView *inputAccessoryView){
        myself.inputAccessoryView = inputAccessoryView;
        return myself;
    };
}

/**
 *  设置键盘类型
 */
-(UITextView *(^)(UIKeyboardType tpye))tfy_keyboardType{
    WSelf(myself);
    return ^(UIKeyboardType tpye){
        myself.keyboardType = tpye;
        return myself;
    };
}
/**
 *  设置键盘上返回键的类型
 */
-(UITextView *(^)(UIReturnKeyType returnKeyType))tfy_returnKeyType{
    WSelf(myself);
    return ^(UIReturnKeyType returnKeyType){
        myself.returnKeyType = returnKeyType;
        return myself;
    };
}
/**
 *  设置键盘的视觉样式
 */
-(UITextView *(^)(UIKeyboardAppearance keyboardAppearance))tfy_keyboardAppearance{
    WSelf(myself);
    return ^(UIKeyboardAppearance keyboardAppearance){
        myself.keyboardAppearance = keyboardAppearance;
        return myself;
    };
}
/**
 *  设置是否启动自动提醒更新功能
 */
-(UITextView *(^)(bool autocorrection))tfy_autocorrectionType{
    WSelf(myself);
    return ^(bool autocorrection){
        myself.autocorrectionType = autocorrection;
        return myself;
    };
}
/**
 *   自动适应高度
 */
-(UITextView *(^)(UIViewAutoresizing autoresizingMask))tfy_autoresizingMask{
    WSelf(myself);
    return ^(UIViewAutoresizing autoresizingMask){
        myself.autoresizingMask = autoresizingMask;
        return myself;
    };
}
/**
 *   是否滑动
 */
-(UITextView *(^)(bool scroll))tfy_scrollEnabled{
    WSelf(myself);
    return ^(bool scroll){
        myself.scrollEnabled = scroll;
        return myself;
    };
}
/**
 *  默认为NO,清除之前输入的文本
 */
-(UITextView *(^)(bool clears))tfy_clearsOnInsertion{
    WSelf(myself);
    return ^(bool clears){
        myself.clearsOnInsertion = clears;
        return myself;
    };
}

/**
 *  添加自定义键盘需要开启 设置YES
 */
-(UITextView *(^)(bool automatically))tfy_enablesReturnKeyAutomatically{
    WSelf(myself);
    return ^(bool automatically){
        myself.enablesReturnKeyAutomatically = automatically;
        return myself;
    };
}

/**
 *  中文输入法上下跳动问题 设置NO
 */
-(UITextView *(^)(bool allows))tfy_allowsNonContiguousLayout{
    WSelf(myself);
    return ^(bool allows){
        myself.layoutManager.allowsNonContiguousLayout = allows;
        return myself;
    };
}

/**
 *  scrollsToTop是UIScrollView的一个属性，主要用于点击设备的状态栏时，是scrollsToTop == YES的控件滚动返回至顶部。
 */
-(UITextView *(^)(bool scrolls))tfy_scrollsToTop{
    WSelf(myself);
    return ^(bool scrolls){
        myself.scrollsToTop = scrolls;
        return myself;
    };
}

/**
 *  高度自适应 解决方案
 */
-(UITextView *(^)(UIEdgeInsets textContainerInset,CGFloat lineFragmentPadding))tfy_textContainerInset{
    WSelf(myself);
    return ^(UIEdgeInsets textContainerInset,CGFloat lineFragmentPadding){
        myself.textContainerInset = textContainerInset;
        myself.textContainer.lineFragmentPadding = lineFragmentPadding;
        return myself;
    };
}

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self.class,NSSelectorFromString(@"dealloc") ),class_getInstanceMethod(self.class, NSSelectorFromString(@"swizzledDealloc")));
}

- (void)swizzledDealloc {
    // 移除观察
    [self removeObserver:self forKeyPath:@"font"];
    //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self swizzledDealloc];
}

#pragma mark -   设置placeholderLabel
- (UILabel *)placeholdLabel{
    
    UILabel *label = objc_getAssociatedObject(self, labelKey);
    if (!label) {
        label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        label.textColor = [self.class defaultColor];
        
        objc_setAssociatedObject(self, labelKey, label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        //添加通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabel) name:UITextViewTextDidChangeNotification object:nil];
        //监听font的变化
        [self addObserver:self forKeyPath:@"font" options:NSKeyValueObservingOptionNew context:nil];
    }
    return label;
}

#pragma mark -  设置默认颜色
+ (UIColor *)defaultColor{
    
    static UIColor *color = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        UITextField *textField = [[UITextField alloc] init];
        textField.placeholder = @" ";
        color = [UIColor lightTextColor];
    });
    return color;
}

#pragma mark - set get methods
- (void)setPlaceholder:(NSString *)placeholder{
    
    self.placeholdLabel.text = placeholder;
    [self updateLabel];
}

- (NSString *)placeholder{
    
    return self.placeholdLabel.text;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    
    self.placeholdLabel.textColor = placeholderColor;
    [self updateLabel];
}

- (UIColor *)placeholderColor{
    
    return self.placeholdLabel.textColor;
}

- (void)setAttributePlaceholder:(NSAttributedString *)attributePlaceholder{
    
    self.placeholdLabel.attributedText = attributePlaceholder;
    [self updateLabel];
}

- (NSAttributedString *)attributePlaceholder{
    
    return self.placeholdLabel.attributedText;
}

- (void)setLocation:(CGPoint)location{
    
    objc_setAssociatedObject(self, changeLocation,NSStringFromCGPoint(location), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateLabel];
}

- (CGPoint)location{
    
    return CGPointFromString(objc_getAssociatedObject(self, changeLocation));
}

#pragma mark - 是否需要调整字体
- (BOOL)needAdjustFont{
    
    return [objc_getAssociatedObject(self, needAdjust) boolValue];
}

- (void)setNeedAdjustFont:(BOOL)needAdjustFont{
    
    objc_setAssociatedObject(self, needAdjust, @(needAdjustFont), OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - observer font KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"font"]){
        
        self.needAdjustFont = YES;
        [self updateLabel];
    }
}

#pragma mark -  更新label信息
- (void)updateLabel{
    
    if (self.text.length) {
        [self.placeholdLabel removeFromSuperview];
        return;
    }
    
    //显示label
    [self insertSubview:self.placeholdLabel atIndex:0];
    
    // 是否需要更新字体（NO 采用默认字体大小）
    if (self.needAdjustFont) {
        self.placeholdLabel.font = self.font;
        self.needAdjustFont = NO;
    }
    
    CGFloat lineFragmentPadding =  self.textContainer.lineFragmentPadding;  //边距
    UIEdgeInsets contentInset = self.textContainerInset;
    
    //设置label frame
    CGFloat labelX = lineFragmentPadding + contentInset.left;
    CGFloat labelY = contentInset.top;
    
    if (self.location.x != 0 || self.location.y != 0) {
        if (self.location.x < 0 || self.location.x > CGRectGetWidth(self.bounds) - lineFragmentPadding - contentInset.right || self.location.y< 0) {
            // 不做处理
        }else{
            labelX += self.location.x;
            labelY += self.location.y;
        }
    }
    
    CGFloat labelW = CGRectGetWidth(self.bounds) - contentInset.right - labelX;
    CGFloat labelH = [self.placeholdLabel sizeThatFits:CGSizeMake(labelW, MAXFLOAT)].height;
    self.placeholdLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
}
@end
