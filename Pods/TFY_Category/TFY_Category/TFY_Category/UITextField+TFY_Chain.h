//
//  UITextField+TFY_Chain.h
//  TFY_Category
//
//  Created by 田风有 on 2019/7/24.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (TFY_Chain)
/**
 *  按钮初始化
 */
UITextField *tfy_textField(void);
/**
 *  文本输入
 */
@property(nonatomic,copy,readonly)UITextField *(^tfy_text)(NSString *title_str);
/**
 *  占位文本文本输入
 */
@property(nonatomic,copy,readonly)UITextField *(^tfy_placeholder)(NSString *title_str,CGFloat font,UIColor *color);
/**
 *  文本颜色
 */
@property(nonatomic,copy,readonly)UITextField *(^tfy_textcolor)(UIColor *color_str);
/**
 *  文本大小
 */
@property(nonatomic,copy,readonly)UITextField *(^tfy_font)(CGFloat font_str);
/**
 *   title_str 文本文字 color_str 文字颜色  font文字大小
 */
@property(nonatomic,copy,readonly)UITextField *(^tfy_title)(NSString *title_str,UIColor *color_str,CGFloat font);
/**
 *    color 背景颜色
 */
@property(nonatomic,copy,readonly)UITextField *(^tfy_backgroundColor)(UIColor *color);
/**
 *    alignment 0 左 1 中 2 右
 */
@property(nonatomic,copy,readonly)UITextField *(^tfy_alAlignment)(NSInteger alignment);
/**
 *  添加四边框和color 颜色  borderWidth 宽度
 */
@property(nonatomic,copy,readonly)UITextField *(^tfy_borders)(CGFloat borderWidth,UIColor *color);
/**
 *  添加四边 color_str阴影颜色  shadowRadius阴影半径
 */
@property(nonatomic,copy,readonly)UITextField *(^tfy_bordersShadow)(UIColor *color, CGFloat shadowRadius);
/**
 *  cornerRadius 圆角
 */
@property(nonatomic,copy,readonly)UITextField *(^tfy_cornerRadius)(CGFloat cornerRadius);
/**
 * bool enabled 是否编辑
 */
@property(nonatomic,copy,readonly)UITextField *(^tfy_enabled)(bool enabled);
/**
 * 编辑框中的内容密码显示
 */
@property(nonatomic,copy,readonly)UITextField *(^tfy_secureTextEntry)(bool secure);
/**
 *  设置边框样式（更多边框样式到补充说明中查看）默认的样式
 */
@property(nonatomic,copy,readonly)UITextField *(^tfy_borderStyle)(UITextBorderStyle borderStyle);
/**
 *  设置清除按钮的模式(更多清除按钮的模式到补充说明中查看)默认样式
 */
@property(nonatomic,copy,readonly)UITextField *(^tfy_clearButtonMode)(UITextFieldViewMode  clearButtonMode);
/**
 *  设置键盘类型
 */
@property(nonatomic,copy,readonly)UITextField *(^tfy_keyboardType)(UIKeyboardType tpye);
/**
 *  设置键盘上返回键的类型
 */
@property(nonatomic,copy,readonly)UITextField *(^tfy_returnKeyType)(UIReturnKeyType returnKeyType);
/**
 *  设置键盘的视觉样式
 */
@property(nonatomic,copy,readonly)UITextField *(^tfy_keyboardAppearance)(UIKeyboardAppearance keyboardAppearance);
/**
 *  设置是否启动自动提醒更新功能
 */
@property(nonatomic,copy,readonly)UITextField *(^tfy_autocorrectionType)(bool autocorrection);
/**
 *   自动适应高度
 */
@property(nonatomic,copy,readonly)UITextField *(^tfy_autoresizingMask)(UIViewAutoresizing autoresizingMask);
/**
 *   输入的对其方法  0 中  1 上  2 下  3 自适
 */
@property(nonatomic,copy,readonly)UITextField *(^tfy_contentVerticalAlignment)(NSInteger contentVerticalAlignment);
/**
 *  最右侧加图片 title_str 图片字符 frame 图片大小
 */
@property(nonatomic,copy,readonly)UITextField *(^tfy_lefimage)(NSString *title_str,CGRect frame);
/**
 *  最左侧加图片 title_str 图片字符 frame 图片大小
 */
@property(nonatomic,copy,readonly)UITextField *(^tfy_rightimage)(NSString *title_str,CGRect frame);
/**
 *  文本输入监听方法
 */
@property(nonatomic,copy,readonly)UITextField *(^tfy_action)(id object, SEL action,UIControlEvents controlEvents);

@end

NS_ASSUME_NONNULL_END
