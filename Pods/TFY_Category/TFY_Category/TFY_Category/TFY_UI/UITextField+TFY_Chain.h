//
//  UITextField+TFY_Chain.h
//  TFY_Category
//
//  Created by 田风有 on 2019/7/24.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static inline UITextField * _Nonnull tfy_textField(void){
    return [[UITextField alloc] init];
}
static inline UITextField * _Nonnull tfy_textFieldframe(CGRect rect){
    return [[UITextField alloc] initWithFrame:rect];
}

@interface UITextField (TFY_Chain)

/**
 *  文本输入
 */
@property(nonatomic,copy,readonly)UITextField *_Nonnull(^_Nonnull tfy_text)(NSString *_Nonnull);
/**
 *  占位文本文本输入
 */
@property(nonatomic,copy,readonly)UITextField *_Nonnull(^_Nonnull tfy_placeholder)(NSString *_Nonnull,UIFont *_Nonnull,id _Nonnull);
/**
 *  文本颜色
 */
@property(nonatomic,copy,readonly)UITextField *_Nonnull(^_Nonnull tfy_textcolor)(id _Nonnull);
/**
 *  文本大小
 */
@property(nonatomic,copy,readonly)UITextField *_Nonnull(^_Nonnull tfy_font)(UIFont *_Nonnull);
/**
 *   title_str 文本文字 color_str 文字颜色  font文字大小
 */
@property(nonatomic,copy,readonly)UITextField *_Nonnull(^_Nonnull tfy_title)(NSString *_Nonnull,id _Nonnull,UIFont *_Nonnull);
/**
 *    color 背景颜色
 */
@property(nonatomic,copy,readonly)UITextField *_Nonnull(^_Nonnull tfy_backgroundColor)(id _Nonnull);
/**
 *    alignment 0 左 1 中 2 右
 */
@property(nonatomic,copy,readonly)UITextField *_Nonnull(^_Nonnull tfy_alAlignment)(NSInteger);
/**
 *  添加四边框和color 颜色  borderWidth 宽度
 */
@property(nonatomic,copy,readonly)UITextField *_Nonnull(^_Nonnull tfy_borders)(CGFloat,id _Nonnull);
/**
 *  添加四边 color_str阴影颜色  shadowRadius阴影半径
 */
@property(nonatomic,copy,readonly)UITextField *_Nonnull(^_Nonnull tfy_bordersShadow)(id _Nonnull, CGFloat);
/**
 *  cornerRadius 圆角
 */
@property(nonatomic,copy,readonly)UITextField *_Nonnull(^_Nonnull tfy_cornerRadius)(CGFloat);
/**
 * bool enabled 是否编辑
 */
@property(nonatomic,copy,readonly)UITextField *_Nonnull(^_Nonnull tfy_enabled)(bool);
/**
 * 编辑框中的内容密码显示
 */
@property(nonatomic,copy,readonly)UITextField *_Nonnull(^_Nonnull tfy_secureTextEntry)(bool);
/**
 *  设置边框样式（更多边框样式到补充说明中查看）默认的样式
 */
@property(nonatomic,copy,readonly)UITextField *_Nonnull(^_Nonnull tfy_borderStyle)(UITextBorderStyle);
/**
 *  设置清除按钮的模式(更多清除按钮的模式到补充说明中查看)默认样式
 */
@property(nonatomic,copy,readonly)UITextField *_Nonnull(^_Nonnull tfy_clearButtonMode)(UITextFieldViewMode);
/**
 *  设置键盘类型
 */
@property(nonatomic,copy,readonly)UITextField *_Nonnull(^_Nonnull tfy_keyboardType)(UIKeyboardType);
/**
 *  设置键盘上返回键的类型
 */
@property(nonatomic,copy,readonly)UITextField *_Nonnull(^_Nonnull tfy_returnKeyType)(UIReturnKeyType);
/**
 *  设置键盘的视觉样式
 */
@property(nonatomic,copy,readonly)UITextField *_Nonnull(^_Nonnull tfy_keyboardAppearance)(UIKeyboardAppearance);
/**
 *  设置是否启动自动提醒更新功能
 */
@property(nonatomic,copy,readonly)UITextField *_Nonnull(^_Nonnull tfy_autocorrectionType)(bool);
/**
 *   自动适应高度
 */
@property(nonatomic,copy,readonly)UITextField *_Nonnull(^_Nonnull tfy_autoresizingMask)(UIViewAutoresizing);
/**
 *   输入的对其方法  0 中  1 上  2 下  3 自适
 */
@property(nonatomic,copy,readonly)UITextField *_Nonnull(^_Nonnull tfy_contentVerticalAlignment)(NSInteger);
/**
 *  最右侧加图片 title_str 图片字符 frame 图片大小
 */
@property(nonatomic,copy,readonly)UITextField *_Nonnull(^_Nonnull tfy_lefimage)(NSString *_Nonnull,CGRect);
/**
 *  最左侧加图片 title_str 图片字符 frame 图片大小
 */
@property(nonatomic,copy,readonly)UITextField *_Nonnull(^_Nonnull tfy_rightimage)(NSString *_Nonnull,CGRect);
/**
 *  文本输入监听方法
 */
@property(nonatomic,copy,readonly)UITextField *_Nonnull(^_Nonnull tfy_action)(id _Nonnull, SEL,UIControlEvents);
/**
 * 添加指定的View
 */
@property(nonatomic, copy, readonly)UITextField *_Nonnull(^_Nonnull tfy_addToSuperView)(UIView *_Nonnull);
@end

NS_ASSUME_NONNULL_END
