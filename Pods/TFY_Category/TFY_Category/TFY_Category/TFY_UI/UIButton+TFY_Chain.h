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

static inline UIButton * _Nonnull tfy_buttontype(UIButtonType type){
    return [UIButton buttonWithType:type];
}
static inline UIButton * _Nonnull tfy_button(void){
    return [[UIButton alloc] init];
}
static inline UIButton * _Nonnull tfy_buttonframe(CGRect rect){
    return [[UIButton alloc] initWithFrame:rect];
}
NS_ASSUME_NONNULL_BEGIN

typedef void (^ActionBlock)(UIButton * _Nonnull button);
typedef void(^ButtonLimitTimesTapBlock)(NSUInteger time, BOOL *stop, UIButton *button);

@interface UIButton (TFY_Chain)
/**
 *  文本输入
 */
@property(nonatomic,copy,readonly)UIButton *(^tfy_text)(NSString *_Nonnull,UIControlState);
/**
 *  文本颜色 color_str 字符串或者 UIColor
 */
@property(nonatomic,copy,readonly)UIButton *(^tfy_textcolor)(id,UIControlState);
/**
 *  文本大小 font_str 表示UIFont
 */
@property(nonatomic,copy,readonly)UIButton *(^tfy_font)(UIFont *_Nonnull);
/**
 *  按钮 title_str 文本文字 color_str 文字颜色  font文字大小
 */
@property(nonatomic,copy,readonly)UIButton *(^tfy_title)(NSString *_Nonnull,UIControlState,id,UIControlState,UIFont *);
/**
 *  按钮  HexString 背景颜色 alpha 背景透明度
 */
@property(nonatomic,copy,readonly)UIButton *(^tfy_backgroundColor)(id,CGFloat);
/**
 *  按钮  alignment 0 左 1 中 2 右
 */
@property(nonatomic,copy,readonly)UIButton *(^tfy_alAlignment)(NSInteger);
/**
 *  添加四边框和color 颜色  borderWidth 宽度
 */
@property(nonatomic,copy,readonly)UIButton *(^tfy_borders)(CGFloat, id);
/**
 *  添加四边 color_str阴影颜色  shadowRadius阴影半径
 */
@property(nonatomic,copy,readonly)UIButton *(^tfy_bordersShadow)(id, CGFloat);
/**
 *  按钮  cornerRadius 圆角
 */
@property(nonatomic,copy,readonly)UIButton *(^tfy_cornerRadius)(CGFloat);
/**
 *  按钮  image_str 图片字符串  state 状态
 */
@property(nonatomic,copy,readonly)UIButton *(^tfy_image)(id,UIControlState);
/**
 *  按钮  backimage_str 背景图片 state 状态
 */
@property(nonatomic,copy,readonly)UIButton *(^tfy_backgroundImage)(id,UIControlState);
/**
 *  按钮 点击方法
 */
@property(nonatomic,copy,readonly)UIButton *(^tfy_action)(id, SEL,UIControlEvents);
/**
 *  文本可变字符串输入
 */
@property(nonatomic,copy,readonly)UIButton *(^tfy_attributrdString)(NSAttributedString *_Nonnull,UIControlState);
/**
 *  文本是否开启随宽度文字超出自动缩小
 */
@property(nonatomic,copy,readonly)UIButton *(^tfy_adjustsWidth)(BOOL);
/**
 * 点击次数
 */
@property (nonatomic, copy, readonly) UIButton * (^ buttonTapTime) (ButtonLimitTimesTapBlock block);

/**
 * 时间间隔
 */
@property (nonatomic, copy, readonly) UIButton* (^ tapSpaceTime) (NSTimeInterval);
/**
 *  文本的字体是否开始换行 0 自动换行
 */
@property(nonatomic, copy, readonly)UIButton *(^tfy_numberOfLines)(NSInteger);
/**
 * 文字省略格式
 */
@property(nonatomic, copy, readonly)UIButton *(^tfy_lineBreakMode)(NSLineBreakMode);
/**
 * 添加指定的View
 */
@property(nonatomic, copy, readonly)UIButton *(^tfy_addToSuperView)(UIView *_Nonnull);
/**
 * 隐藏本类
 */
@property(nonatomic, copy, readonly)UIButton *(^tfy_hidden)(BOOL);
/**
 * 透明度
 */
@property(nonatomic, copy, readonly)UIButton *(^tfy_alpha)(CGFloat);
/**
 * 交互开关
 */
@property(nonatomic, copy, readonly)UIButton *(^tfy_userInteractionEnabled)(BOOL);
/**
 *  位置偏移量
 */
@property(nonatomic,copy,readonly)UIButton *(^tfy_contentEdgeInsets)(UIEdgeInsets);
/**
 *  文字偏移量
 */
@property(nonatomic,copy,readonly)UIButton *(^tfy_titleEdgeInsets)(UIEdgeInsets);
/**
 *  图片偏移量
 */
@property(nonatomic,copy,readonly)UIButton *(^tfy_imageEdgeInsets)(UIEdgeInsets);
/**
 *  添加图片的位置和文字距离
 */
@property(nonatomic,copy,readonly)UIButton *(^tfy_layouEdgeInsetsPosition)(ButtonPosition,CGFloat);
/**
 * 取消之前de
 */
- (void)cancelRecordTime;
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

/**
 *  绑定button
 **/
-(void)BindingBtnactionBlock:(ActionBlock _Nonnull)actionBlock;
/**
 *  加载完毕停止旋转
 *  title:停止后button的文字
 *  textColor :字体色 如果颜色不变就为nil
 *  backgroundColor :背景色 如果颜色不变就为nil
 **/
-(void)stopLoading:(NSString*_Nullable)title textColor:(UIColor*_Nullable)textColor backgroundColor:(UIColor*_Nullable)backColor;
/**
 *  设置加载圆圈的宽度 默认是5
 **/
@property(nonatomic,assign)NSInteger lineWidths;
/**
 *  设置加载圆圈距离上下边距的宽度 默认是5
 **/
@property(nonatomic,assign)NSInteger topHeight;
/**
 *  设置开始加载时候的圆圈颜色渐变值 1
 **/
@property(nonatomic,strong)UIColor * _Nullable startColorOne;
/**
 *  设置开始加载时候的圆圈颜色渐变值 2
 **/
@property(nonatomic,strong)UIColor * _Nullable startColorTwo;
@end

NS_ASSUME_NONNULL_END
