//
//  UITextView+TFY_Chain.h
//  TFY_Category
//
//  Created by 田风有 on 2019/7/26.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (TFY_Chain)
/**
 *  按钮初始化
 */
UITextView *tfy_textView(void);
/**
 *  文本输入
 */
@property(nonatomic,copy,readonly)UITextView *(^tfy_text)(NSString *title_str);
/**
 *  文本颜色
 */
@property(nonatomic,copy,readonly)UITextView *(^tfy_textcolor)(UIColor *color_str);
/**
 *  文本大小
 */
@property(nonatomic,copy,readonly)UITextView *(^tfy_font)(CGFloat font_str);
/**
 *   title_str 文本文字 color_str 文字颜色  font文字大小
 */
@property(nonatomic,copy,readonly)UITextView *(^tfy_title)(NSString *title_str,UIColor *color_str,CGFloat font);
/**
 *    color 背景颜色
 */
@property(nonatomic,copy,readonly)UITextView *(^tfy_backgroundColor)(UIColor *color);
/**
 *    alignment 0 左 1 中 2 右
 */
@property(nonatomic,copy,readonly)UITextView *(^tfy_alAlignment)(NSInteger alignment);
/**
 *  添加四边框和color 颜色  borderWidth 宽度
 */
@property(nonatomic,copy,readonly)UITextView *(^tfy_borders)(CGFloat borderWidth,UIColor *color);
/**
 *  添加四边 color_str阴影颜色  shadowRadius阴影半径
 */
@property(nonatomic,copy,readonly)UITextView *(^tfy_bordersShadow)(UIColor *color, CGFloat shadowRadius);
/**
 *  cornerRadius 圆角
 */
@property(nonatomic,copy,readonly)UITextView *(^tfy_cornerRadius)(CGFloat cornerRadius);
/**
 * bool enabled 是否编辑
 */
@property(nonatomic,copy,readonly)UITextView *(^tfy_editable)(bool editable);
/**
 * 编辑框中的内容密码显示
 */
@property(nonatomic,copy,readonly)UITextView *(^tfy_secureTextEntry)(bool secure);
/**
 *  自定义键盘  inputView 自定义输入区域
 */
@property(nonatomic,copy,readonly)UITextView *(^tfy_inputView)(UIView *inputView);
/**
 *  自定义键盘 /键盘上加view
 */
@property(nonatomic,copy,readonly)UITextView *(^tfy_inputAccessoryView)(UIView *inputAccessoryView);
/**
 *  设置键盘类型
 */
@property(nonatomic,copy,readonly)UITextView *(^tfy_keyboardType)(UIKeyboardType tpye);
/**
 *  设置键盘上返回键的类型
 */
@property(nonatomic,copy,readonly)UITextView *(^tfy_returnKeyType)(UIReturnKeyType returnKeyType);
/**
 *  设置键盘的视觉样式
 */
@property(nonatomic,copy,readonly)UITextView *(^tfy_keyboardAppearance)(UIKeyboardAppearance keyboardAppearance);
/**
 *  设置是否启动自动提醒更新功能
 */
@property(nonatomic,copy,readonly)UITextView *(^tfy_autocorrectionType)(bool autocorrection);
/**
 *   自动适应高度
 */
@property(nonatomic,copy,readonly)UITextView *(^tfy_autoresizingMask)(UIViewAutoresizing autoresizingMask);
/**
 *   是否滑动
 */
@property(nonatomic,copy,readonly)UITextView *(^tfy_scrollEnabled)(bool scroll);
/**
 *  默认为NO,清除之前输入的文本
 */
@property(nonatomic,copy,readonly)UITextView *(^tfy_clearsOnInsertion)(bool clears);
/**
 *  输入框有值时才能点击键盘上  automatically YES
 */
@property(nonatomic,copy,readonly)UITextView *(^tfy_enablesReturnKeyAutomatically)(bool automatically);
/**
 *  中文输入法上下跳动问题 设置NO
 */
@property(nonatomic,copy,readonly)UITextView *(^tfy_allowsNonContiguousLayout)(bool allows);
/**
 *  scrollsToTop是UIScrollView的一个属性，主要用于点击设备的状态栏时，是scrollsToTop == YES的控件滚动返回至顶部。 scrolls NO
 */
@property(nonatomic,copy,readonly)UITextView *(^tfy_scrollsToTop)(bool scrolls);
/**
 *  高度自适应 解决方案 textContainerInset= UIEdgeInsetsZero lineFragmentPadding 0
 */
@property(nonatomic,copy,readonly)UITextView *(^tfy_textContainerInset)(UIEdgeInsets textContainerInset,CGFloat lineFragmentPadding);
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
@property(nonnull,strong) NSAttributedString *attributePlaceholder;
/**
 * 位置
 */
@property(nonatomic,assign) CGPoint location;

@end

NS_ASSUME_NONNULL_END
