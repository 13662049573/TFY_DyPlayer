//
//  UILabel+TFY_Label.h
//  TFY_CHESHI
//
//  Created by 田风有 on 2018/8/16.
//  Copyright © 2018年 田风有. All rights reserved.
//  https://github.com/13662049573/TFY_AutoLayoutModelTools

#import <UIKit/UIKit.h>

@protocol TFY_RichTextDelegate <NSObject>
@optional
/**
 *  RichTextDelegate  string  点击的字符串  range   点击的字符串range  index   点击的字符在数组中的index
 */
- (void)tfy_didClickRichText:(NSString *)string range:(NSRange)range index:(NSInteger)index;
@end

@interface UILabel (TFY_Label)

/**
 *  是否打开点击效果，默认是打开
 */
@property (nonatomic, assign) BOOL tfy_enabledClickEffect;

/**
 *  点击效果颜色 默认lightGrayColor
 */
@property (nonatomic, strong) UIColor *tfy_clickEffectColor;
/**
 *  初始化Label
 */
UILabel *tfy_label(void);
/**
 *  文本输入
 */
@property(nonatomic,copy,readonly)UILabel *(^tfy_text)(NSString *text);
/**
 *  文本输入颜色和透明度
 */
@property(nonatomic,copy,readonly)UILabel *(^tfy_textcolor)(NSString *HexString,CGFloat alpha);
/**
 *  文本字体大小
 */
@property(nonatomic,copy,readonly)UILabel *(^tfy_fontSize)(CGFloat fontSize);
/**
 *  文本字体位置 0 左 1 中 2 右
 */
@property(nonatomic,copy,readonly)UILabel *(^tfy_alignment)(NSInteger alignment);
/**
 *  文本可变字符串输入
 */
@property(nonatomic,copy,readonly)UILabel *(^tfy_attributrdString)(NSAttributedString *attributrdString);
/**
 *  文本的字体是否开始换行 0 自动换行
 */
@property(nonatomic,copy,readonly)UILabel *(^tfy_numberOfLines)(NSInteger numberOfLines);
/**
 *  文本是否开启随宽度文字超出自动缩小
 */
@property(nonatomic,copy,readonly)UILabel *(^tfy_adjustsWidth)(BOOL adjustsWidth);
/**
 *  背景颜色和 alpha透明度  HexString 字符串颜色
 */
@property(nonatomic,copy,readonly)UILabel *(^tfy_backgroundColor)(NSString *HexString,CGFloat alpha);
/**
 *  按钮  cornerRadius 圆角
 */
@property(nonatomic,copy,readonly)UILabel *(^tfy_cornerRadius)(CGFloat cornerRadius);
/**
 *  添加四边框和color 颜色  borderWidth 宽度
 */
@property(nonatomic,copy,readonly)UILabel *(^tfy_borders)(CGFloat borderWidth, NSString *color);
/**
 *  添加四边 color_str阴影颜色  shadowRadius阴影半径
 */
@property(nonatomic,copy,readonly)UILabel *(^tfy_bordersShadow)(NSString *color_str, CGFloat shadowRadius);


/**
 *  给文本添加Block点击事件回调 strings  需要添加的字符串数组  clickAction 点击事件回调
 */
- (void)tfy_clickRichTextWithStrings:(NSArray <NSString *> *)strings clickAction:(void (^) (NSString *string, NSRange range, NSInteger index))clickAction;

/**
 *  给文本添加点击事件delegate回调 strings  需要添加的字符串数组  delegate 富文本代理
 */
- (void)tfy_clickRichTextWithStrings:(NSArray <NSString *> *)strings delegate:(id <TFY_RichTextDelegate> )delegate;

@end
