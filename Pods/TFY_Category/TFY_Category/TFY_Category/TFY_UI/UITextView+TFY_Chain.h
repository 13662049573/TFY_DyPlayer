//
//  UITextView+TFY_Chain.h
//  TFY_Category
//
//  Created by 田风有 on 2019/7/26.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static inline UITextView * _Nonnull tfy_textView(void){
    return [[UITextView alloc] init];
}
static inline UITextView * _Nonnull tfy_textViewframe(CGRect rect){
    return [[UITextView alloc] initWithFrame:rect];
}

@interface UITextView (TFY_Chain)
/**
 *  文本输入
 */
@property(nonatomic,copy,readonly)UITextView *_Nonnull(^_Nonnull tfy_text)(NSString *_Nonnull);
/**
 *  文本颜色
 */
@property(nonatomic,copy,readonly)UITextView *_Nonnull(^_Nonnull tfy_textcolor)(id _Nonnull);
/**
 *  文本大小
 */
@property(nonatomic,copy,readonly)UITextView *_Nonnull(^_Nonnull tfy_font)(UIFont *_Nonnull);
/**
 *   title_str 文本文字 color_str 文字颜色  font文字大小
 */
@property(nonatomic,copy,readonly)UITextView *_Nonnull(^_Nonnull tfy_title)(NSString *_Nonnull,id _Nonnull,UIFont *_Nonnull);
/**
 *    color 背景颜色
 */
@property(nonatomic,copy,readonly)UITextView *_Nonnull(^_Nonnull tfy_backgroundColor)(id _Nonnull);
/**
 *    alignment 0 左 1 中 2 右
 */
@property(nonatomic,copy,readonly)UITextView *_Nonnull(^_Nonnull tfy_alAlignment)(NSInteger);
/**
 *  添加四边框和color 颜色  borderWidth 宽度
 */
@property(nonatomic,copy,readonly)UITextView *_Nonnull(^_Nonnull tfy_borders)(CGFloat,id _Nonnull);
/**
 *  添加四边 color_str阴影颜色  shadowRadius阴影半径
 */
@property(nonatomic,copy,readonly)UITextView *_Nonnull(^_Nonnull tfy_bordersShadow)(id _Nonnull, CGFloat);
/**
 *  cornerRadius 圆角
 */
@property(nonatomic,copy,readonly)UITextView *_Nonnull(^_Nonnull tfy_cornerRadius)(CGFloat);
/**
 * bool enabled 是否编辑
 */
@property(nonatomic,copy,readonly)UITextView *_Nonnull(^_Nonnull tfy_editable)(bool);
/**
 * 编辑框中的内容密码显示
 */
@property(nonatomic,copy,readonly)UITextView *_Nonnull(^_Nonnull tfy_secureTextEntry)(bool);
/**
 *  自定义键盘  inputView 自定义输入区域
 */
@property(nonatomic,copy,readonly)UITextView *_Nonnull(^_Nonnull tfy_inputView)(UIView *_Nonnull);
/**
 *  自定义键盘 /键盘上加view
 */
@property(nonatomic,copy,readonly)UITextView *_Nonnull(^_Nonnull tfy_inputAccessoryView)(UIView *_Nonnull);
/**
 *  设置键盘类型
 */
@property(nonatomic,copy,readonly)UITextView *_Nonnull(^_Nonnull tfy_keyboardType)(UIKeyboardType);
/**
 *  设置键盘上返回键的类型
 */
@property(nonatomic,copy,readonly)UITextView *_Nonnull(^_Nonnull tfy_returnKeyType)(UIReturnKeyType);
/**
 *  设置键盘的视觉样式
 */
@property(nonatomic,copy,readonly)UITextView *_Nonnull(^_Nonnull tfy_keyboardAppearance)(UIKeyboardAppearance);
/**
 *  设置是否启动自动提醒更新功能
 */
@property(nonatomic,copy,readonly)UITextView *_Nonnull(^_Nonnull tfy_autocorrectionType)(bool);
/**
 *   自动适应高度
 */
@property(nonatomic,copy,readonly)UITextView *_Nonnull(^_Nonnull tfy_autoresizingMask)(UIViewAutoresizing);
/**
 *   是否滑动
 */
@property(nonatomic,copy,readonly)UITextView *_Nonnull(^_Nonnull tfy_scrollEnabled)(bool);
/**
 *  默认为NO,清除之前输入的文本
 */
@property(nonatomic,copy,readonly)UITextView *_Nonnull(^_Nonnull tfy_clearsOnInsertion)(bool);
/**
 *  输入框有值时才能点击键盘上  automatically YES
 */
@property(nonatomic,copy,readonly)UITextView *_Nonnull(^_Nonnull tfy_enablesReturnKeyAutomatically)(bool);
/**
 *  中文输入法上下跳动问题 设置NO
 */
@property(nonatomic,copy,readonly)UITextView *_Nonnull(^_Nonnull tfy_allowsNonContiguousLayout)(bool);
/**
 *  scrollsToTop是UIScrollView的一个属性，主要用于点击设备的状态栏时，是scrollsToTop == YES的控件滚动返回至顶部。 scrolls NO
 */
@property(nonatomic,copy,readonly)UITextView *_Nonnull(^_Nonnull tfy_scrollsToTop)(bool);
/**
 *  高度自适应 解决方案 textContainerInset= UIEdgeInsetsZero lineFragmentPadding 0
 */
@property(nonatomic,copy,readonly)UITextView *_Nonnull(^_Nonnull tfy_textContainerInset)(UIEdgeInsets,CGFloat);
/**
 * 添加指定的View
 */
@property(nonatomic, copy, readonly)UITextView *_Nonnull(^_Nonnull tfy_addToSuperView)(UIView *_Nonnull);
/**
 *   placeholdLabel
 */
@property(nonatomic,readonly)  UILabel * _Nonnull placeholdLabel;
/**
 * placeholder
 */
@property(nonatomic,copy) NSString * _Nonnull placeholder;
/**
 * placeholder颜色
 */
@property(nonatomic,copy) UIColor * _Nonnull placeholderColor;
/**
 * 富文本
 */
@property(nonatomic,strong) NSAttributedString *_Nonnull attributePlaceholder;
/**
 * 位置
 */
@property(nonatomic,assign) CGPoint location;

@end

NS_ASSUME_NONNULL_END
