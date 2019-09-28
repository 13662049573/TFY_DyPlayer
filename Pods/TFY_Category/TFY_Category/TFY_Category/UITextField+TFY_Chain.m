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
 *  按钮初始化
 */
UITextField *tfy_textField(void){
    return [[UITextField alloc] init];
}
/**
 *  占位文本文本输入
 */
-(UITextField *(^)(NSString *title_str,CGFloat font,UIColor *color))tfy_placeholder{
    WSelf(myself);
    return ^(NSString *title_str,CGFloat font,UIColor *color){
        myself.placeholder = title_str;
        myself.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: color ,NSFontAttributeName:[UIFont systemFontOfSize:font]}];
        return myself;
    };
}
/**
 *  文本输入
 */
-(UITextField *(^)(NSString *title_str))tfy_text{
    WSelf(myself);
    return ^(NSString *title_str){
        myself.text = title_str;
        return myself;
    };
}
/**
 *  文本颜色
 */
-(UITextField *(^)(UIColor *color_str))tfy_textcolor{
    WSelf(myself);
    return ^(UIColor *color_str){
        myself.textColor = color_str;
        return myself;
    };
}
/**
 *  文本大小
 */
-(UITextField *(^)(CGFloat font))tfy_font{
    WSelf(myself);
    return ^(CGFloat font){
        myself.font = [UIFont systemFontOfSize:font];
        return myself;
    };
}

/**
 *  按钮 title_str 文本文字 color_str 文字颜色  font文字大小
 */
-(UITextField *(^)(NSString *title_str,UIColor *color_str,CGFloat font))tfy_title{
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
-(UITextField *(^)(UIColor *color))tfy_backgroundColor{
    WSelf(myself);
    return ^(UIColor *color){
        myself.backgroundColor = color;
        return myself;
    };
}
/**
 *  按钮  alignment 0 左 1 中 2 右
 */
-(UITextField *(^)(NSInteger alignment))tfy_alAlignment{
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
-(UITextField *(^)(CGFloat borderWidth, UIColor *color))tfy_borders{
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
-(UITextField *(^)(UIColor *color, CGFloat shadowRadius))tfy_bordersShadow{
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
-(UITextField *(^)(CGFloat cornerRadius))tfy_cornerRadius{
    WSelf(myself);
    return ^(CGFloat cornerRadius){
        myself.layer.cornerRadius = cornerRadius;
        return myself;
    };
}
/**
 *  按钮  image_str 图片字符串
 */
-(UITextField *(^)(bool enabled))tfy_enabled{
    WSelf(myself);
    return ^(bool enabled){
        [myself setEnabled:enabled];
        return myself;
    };
}
/**
 * 编辑框中的内容密码显示
 */
-(UITextField *(^)(bool secure))tfy_secureTextEntry{
    WSelf(myself);
    return ^(bool secure){
        myself.secureTextEntry = secure;
        return myself;
    };
}

/**
 *  设置边框样式（更多边框样式到补充说明中查看）默认的样式
 */
-(UITextField *(^)(UITextBorderStyle borderStyle))tfy_borderStyle{
    WSelf(myself);
    return ^(UITextBorderStyle borderStyle){
        myself.borderStyle =  borderStyle;
        return myself;
    };
}
/**
 *  设置清除按钮的模式(更多清除按钮的模式到补充说明中查看)默认样式
 */
-(UITextField *(^)(UITextFieldViewMode  clearButtonMode))tfy_clearButtonMode{
    WSelf(myself);
    return ^(UITextFieldViewMode  clearButtonMode){
        myself.clearButtonMode = clearButtonMode;
        return myself;
    };
}

/**
 *  设置键盘类型
 */
-(UITextField *(^)(UIKeyboardType tpye))tfy_keyboardType{
    WSelf(myself);
    return ^(UIKeyboardType tpye){
        myself.keyboardType = tpye;
        return myself;
    };
}
/**
 *  设置键盘上返回键的类型
 */
-(UITextField *(^)(UIReturnKeyType returnKeyType))tfy_returnKeyType{
    WSelf(myself);
    return ^(UIReturnKeyType returnKeyType){
        myself.returnKeyType = returnKeyType;
        return myself;
    };
}
/**
 *  设置键盘的视觉样式
 */
-(UITextField *(^)(UIKeyboardAppearance keyboardAppearance))tfy_keyboardAppearance{
    WSelf(myself);
    return ^(UIKeyboardAppearance keyboardAppearance){
        myself.keyboardAppearance = keyboardAppearance;
        return myself;
    };
}
/**
 *  设置是否启动自动提醒更新功能
 */
-(UITextField *(^)(bool autocorrection))tfy_autocorrectionType{
    WSelf(myself);
    return ^(bool autocorrection){
        myself.autocorrectionType = autocorrection;
        return myself;
    };
}
/**
 *   自动适应高度
 */
-(UITextField *(^)(UIViewAutoresizing autoresizingMask))tfy_autoresizingMask{
    WSelf(myself);
    return ^(UIViewAutoresizing autoresizingMask){
        myself.autoresizingMask = autoresizingMask;
        return myself;
    };
}
/**
 *   输入的对其方法  0 中  1 上  2 下  3 自适
 */
-(UITextField *(^)(NSInteger contentVerticalAlignment))tfy_contentVerticalAlignment{
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
-(UITextField *(^)(NSString *title_str,CGRect frame))tfy_lefimage{
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
-(UITextField *(^)(NSString *title_str,CGRect frame))tfy_rightimage{
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
-(UITextField *(^)(id object, SEL action,UIControlEvents controlEvents))tfy_action{
    WSelf(myself);
    return ^(id object, SEL action,UIControlEvents controlEvents){
        [myself addTarget:object action:action forControlEvents:controlEvents];
        return myself;
    };
}
@end
