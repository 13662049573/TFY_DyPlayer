//
//  UIButton+TFY_Chain.h
//  TFY_CHESHI
//
//  Created by 田风有 on 2019/6/5.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ButtonPosition) {
    
    /** 图片在左，文字在右，默认 */
    ButtonPositionImageLeft_titleRight = 0,
    /** 图片在右，文字在左 */
    ButtonPositionImageRight_titleLeft = 1,
    /** 图片在上，文字在下 */
    ButtonPositionImageTop_titleBottom = 2,
    /** 图片在下，文字在上 */
    ButtonPositionImageBottom_titleTop = 3,
};

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (TFY_Chain)
/**
 *  按钮初始化
 */
UIButton *tfy_button(void);
/**
 *  文本输入
 */
@property(nonatomic,copy,readonly)UIButton *(^tfy_text)(NSString *title_str);
/**
 *  文本颜色
 */
@property(nonatomic,copy,readonly)UIButton *(^tfy_textcolor)(NSString *color_str);
/**
 *  文本大小
 */
@property(nonatomic,copy,readonly)UIButton *(^tfy_font)(CGFloat font_str);
/**
 *  按钮 title_str 文本文字 color_str 文字颜色  font文字大小
 */
@property(nonatomic,copy,readonly)UIButton *(^tfy_title)(NSString *title_str,NSString *color_str,CGFloat font);
/**
 *  按钮  HexString 背景颜色 alpha 背景透明度
 */
@property(nonatomic,copy,readonly)UIButton *(^tfy_backgroundColor)(NSString *HexString,CGFloat alpha);
/**
 *  按钮  alignment 0 左 1 中 2 右
 */
@property(nonatomic,copy,readonly)UIButton *(^tfy_alAlignment)(NSInteger alignment);
/**
 *  添加四边框和color 颜色  borderWidth 宽度
 */
@property(nonatomic,copy,readonly)UIButton *(^tfy_borders)(CGFloat borderWidth, NSString *color);
/**
 *  添加四边 color_str阴影颜色  shadowRadius阴影半径
 */
@property(nonatomic,copy,readonly)UIButton *(^tfy_bordersShadow)(NSString *color_str, CGFloat shadowRadius);
/**
 *  按钮  cornerRadius 圆角
 */
@property(nonatomic,copy,readonly)UIButton *(^tfy_cornerRadius)(CGFloat cornerRadius);
/**
 *  按钮  image_str 图片字符串  state 状态
 */
@property(nonatomic,copy,readonly)UIButton *(^tfy_image)(NSString *image_str,UIControlState state);
/**
 *  按钮  backimage_str 背景图片 state 状态
 */
@property(nonatomic,copy,readonly)UIButton *(^tfy_backgroundImage)(NSString *backimage_str,UIControlState state);
/**
 *  按钮 点击方法
 */
@property(nonatomic,copy,readonly)UIButton *(^tfy_action)(id object, SEL action);
/**
 *  文本可变字符串输入
 */
@property(nonatomic,copy,readonly)UIButton *(^tfy_attributrdString)(NSAttributedString *attributrdString);
/**
 *  文本是否开启随宽度文字超出自动缩小
 */
@property(nonatomic,copy,readonly)UIButton *(^tfy_adjustsWidth)(BOOL adjustsWidth);
/**
 *  button的大小要大于 图片大小+文字大小+spacing   spacing 图片和文字的间隔
 */
-(void)tfy_layouEdgeInsetsPosition:(ButtonPosition)postion spacing:(CGFloat)spacing;
/**
 *  🐶计时时间    👇
 */
@property(nonatomic,assign,readwrite)NSInteger time;
/**
 *  🐶format   👇
 */
@property(nonatomic,copy)NSString *  format;
/**
 * 开启计时器
 */
- (void)startTimer;
/**
 * 干掉计时器
 */
- (void)endTimer;
/**
 * 倒计时完成后的回调
 */
@property(nonatomic,copy)void(^CompleteBlock)(void);
/**
 *  动画启动
 */
- (void)show;
/**
 *  动画结束
 */
- (void)hide;
@end

NS_ASSUME_NONNULL_END
