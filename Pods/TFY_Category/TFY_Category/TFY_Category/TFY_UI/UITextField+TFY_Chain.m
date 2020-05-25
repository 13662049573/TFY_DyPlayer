//
//  UITextField+TFY_Chain.m
//  TFY_Category
//
//  Created by 田风有 on 2019/7/24.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "UITextField+TFY_Chain.h"

#define WSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@implementation UITextField (TFY_Chain)

/**
 *  占位文本文本输入
 */
-(UITextField *(^)(NSString *,UIFont *,id))tfy_placeholder{
    WSelf(myself);
    return ^(NSString *title_str,UIFont *font,id color){
        myself.placeholder = title_str;
        if ([color isKindOfClass:[NSString class]]) {
            myself.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: [self btncolorWithHexString:color alpha:1] ,NSFontAttributeName:font}];
        }
        if ([color isKindOfClass:[UIColor class]]) {
           myself.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: color ,NSFontAttributeName:font}];
        }
        return myself;
    };
}
/**
 *  文本输入
 */
-(UITextField *(^)(NSString *))tfy_text{
    WSelf(myself);
    return ^(NSString *title_str){
        myself.text = title_str;
        return myself;
    };
}
/**
 *  文本颜色
 */
-(UITextField *(^)(id))tfy_textcolor{
    WSelf(myself);
    return ^(id color_str){
        if ([color_str isKindOfClass:[NSString class]]) {
            myself.textColor = [self btncolorWithHexString:color_str alpha:1];
        }
        if ([color_str isKindOfClass:[UIColor class]]) {
            myself.textColor = color_str;
        }
        return myself;
    };
}
/**
 *  文本大小
 */
-(UITextField *(^)(UIFont *))tfy_font{
    WSelf(myself);
    return ^(UIFont *font){
        myself.font = font;
        return myself;
    };
}

/**
 *  按钮 title_str 文本文字 color_str 文字颜色  font文字大小
 */
-(UITextField *(^)(NSString *,id,UIFont *))tfy_title{
    WSelf(myself);
    return ^(NSString *title_str,id color_str,UIFont *font){
        myself.text = title_str;
        if ([color_str isKindOfClass:[NSString class]]) {
             myself.textColor = [self btncolorWithHexString:color_str alpha:1];
        }
        if ([color_str isKindOfClass:[UIColor class]]) {
             myself.textColor = color_str;
        }
        myself.font = font;
        return myself;
    };
}
/**
 *  按钮  HexString 背景颜色 alpha 背景透明度
 */
-(UITextField *(^)(id))tfy_backgroundColor{
    WSelf(myself);
    return ^(id color){
        if ([color isKindOfClass:[NSString class]]) {
            myself.backgroundColor = [self btncolorWithHexString:color alpha:1];
        }
        if ([color isKindOfClass:[UIColor class]]) {
            myself.backgroundColor = color;
        }
        return myself;
    };
}
/**
 *  按钮  alignment 0 左 1 中 2 右
 */
-(UITextField *(^)(NSInteger))tfy_alAlignment{
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
-(UITextField *(^)(CGFloat, id))tfy_borders{
    WSelf(myself);
    return ^(CGFloat borderWidth, id color){
        myself.layer.borderWidth = borderWidth;
        if ([color isKindOfClass:[NSString class]]) {
            myself.layer.borderColor = [self btncolorWithHexString:color alpha:1].CGColor;
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
-(UITextField *(^)(id, CGFloat))tfy_bordersShadow{
    WSelf(myself);
    return ^(id color, CGFloat shadowRadius){
        // 阴影颜色
        if ([color isKindOfClass:[NSString class]]) {
            myself.layer.shadowColor = [self btncolorWithHexString:color alpha:1].CGColor;
        }
        if ([color isKindOfClass:[UIColor class]]) {
            myself.layer.shadowColor = [(UIColor *)color CGColor];
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
-(UITextField *(^)(CGFloat))tfy_cornerRadius{
    WSelf(myself);
    return ^(CGFloat cornerRadius){
        myself.layer.cornerRadius = cornerRadius;
        return myself;
    };
}
/**
 *  按钮  image_str 图片字符串
 */
-(UITextField *(^)(bool))tfy_enabled{
    WSelf(myself);
    return ^(bool enabled){
        [myself setEnabled:enabled];
        return myself;
    };
}
/**
 * 编辑框中的内容密码显示
 */
-(UITextField *(^)(bool))tfy_secureTextEntry{
    WSelf(myself);
    return ^(bool secure){
        myself.secureTextEntry = secure;
        return myself;
    };
}

/**
 *  设置边框样式（更多边框样式到补充说明中查看）默认的样式
 */
-(UITextField *(^)(UITextBorderStyle))tfy_borderStyle{
    WSelf(myself);
    return ^(UITextBorderStyle borderStyle){
        myself.borderStyle =  borderStyle;
        return myself;
    };
}
/**
 *  设置清除按钮的模式(更多清除按钮的模式到补充说明中查看)默认样式
 */
-(UITextField *(^)(UITextFieldViewMode))tfy_clearButtonMode{
    WSelf(myself);
    return ^(UITextFieldViewMode  clearButtonMode){
        myself.clearButtonMode = clearButtonMode;
        return myself;
    };
}

/**
 *  设置键盘类型
 */
-(UITextField *(^)(UIKeyboardType))tfy_keyboardType{
    WSelf(myself);
    return ^(UIKeyboardType tpye){
        myself.keyboardType = tpye;
        return myself;
    };
}
/**
 *  设置键盘上返回键的类型
 */
-(UITextField *(^)(UIReturnKeyType))tfy_returnKeyType{
    WSelf(myself);
    return ^(UIReturnKeyType returnKeyType){
        myself.returnKeyType = returnKeyType;
        return myself;
    };
}
/**
 *  设置键盘的视觉样式
 */
-(UITextField *(^)(UIKeyboardAppearance))tfy_keyboardAppearance{
    WSelf(myself);
    return ^(UIKeyboardAppearance keyboardAppearance){
        myself.keyboardAppearance = keyboardAppearance;
        return myself;
    };
}
/**
 *  设置是否启动自动提醒更新功能
 */
-(UITextField *(^)(bool))tfy_autocorrectionType{
    WSelf(myself);
    return ^(bool autocorrection){
        myself.autocorrectionType = autocorrection;
        return myself;
    };
}
/**
 *   自动适应高度
 */
-(UITextField *(^)(UIViewAutoresizing))tfy_autoresizingMask{
    WSelf(myself);
    return ^(UIViewAutoresizing autoresizingMask){
        myself.autoresizingMask = autoresizingMask;
        return myself;
    };
}
/**
 *   输入的对其方法  0 中  1 上  2 下  3 自适
 */
-(UITextField *(^)(NSInteger))tfy_contentVerticalAlignment{
    WSelf(myself);
    return ^(NSInteger contentVerticalAlignment){
        switch (contentVerticalAlignment) {
            case 0:
                myself.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                break;
            case 1:
                myself.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
                break;
            case 2:
                myself.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
                break;
            case 3:
                myself.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
                break;
        }
        return myself;
    };
}
/**
 *  最右侧加图片 title_str 图片字符 frame 图片大小
 */
-(UITextField *(^)(NSString *,CGRect))tfy_lefimage{
    WSelf(myself);
    return ^(NSString *title_str,CGRect frame){
        
        UIImageView *image = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:title_str] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        image.frame = frame;
        myself.leftView = image;
        myself.leftViewMode = UITextFieldViewModeAlways;
        return myself;
    };
}

/**
 *  最左侧加图片 title_str 图片字符 frame 图片大小
 */
-(UITextField *(^)(NSString *,CGRect))tfy_rightimage{
    WSelf(myself);
    return ^(NSString *title_str,CGRect frame){
        UIImageView *image = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:title_str] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        image.frame = frame;
        myself.rightView = image;
        myself.rightViewMode = UITextFieldViewModeAlways;
        return myself;
    };
}

/**
 *  文本输入监听方法
 */
-(UITextField *(^)(id, SEL,UIControlEvents))tfy_action{
    WSelf(myself);
    return ^(id object, SEL action,UIControlEvents controlEvents){
        [myself addTarget:object action:action forControlEvents:controlEvents];
        return myself;
    };
}
/**
 * 添加指定的View
 */
-(UITextField *(^)(UIView *))tfy_addToSuperView{
    WSelf(myself);
    return ^(UIView *view){
        [view addSubview:myself];
        return myself;
    };
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
@end
