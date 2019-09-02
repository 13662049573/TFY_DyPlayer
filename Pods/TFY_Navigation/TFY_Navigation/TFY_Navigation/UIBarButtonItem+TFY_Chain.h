//
//  UIBarButtonItem+TFY_Chain.h
//  TFY_Navigation
//
//  Created by 田风有 on 2019/6/6.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (TFY_Chain)
/**
 *  按钮初始化 也是隐藏返回按钮
 */
UIBarButtonItem *tfy_barbtnItem(void);
/**
 *  初始一个Lable 可以随自己更改
 */
@property(nonatomic,strong)UILabel *tfy_bgdge;
/**
 *  显示的个数
 */
@property(nonatomic,copy)NSString *tfy_badgeValue;
/**
 * 徽章的背景色
 */
@property(nonatomic,strong)UIColor *tfy_badgeBGColor;
/**
 *  徽章的文字颜色
 */
@property(nonatomic,strong)UIColor *tfy_badgeTextColor;
/**
 *  标志字体
 */
@property(nonatomic,strong)UIFont *tfy_badgeFont;
/**
 *  徽章的填充值
 */
@property(nonatomic,assign)CGFloat tfy_badgePadding;
/**
 *  最小尺寸小徽章
 */
@property(nonatomic,assign)CGFloat tfy_badgeMinSize;
/**
 *  X barbuttonitem你选值
 */
@property(nonatomic,assign)CGFloat tfy_badgeOriginX;
/**
 *  Y barbuttonitem你选值
 */
@property(nonatomic,assign)CGFloat tfy_badgeOriginY;
/**
 *  删除徽章时达到零
 */
@property(nonatomic,assign)BOOL tfy_shouldHideBadgeAtZero;
/**
 *  当价值变化时，徽章有一个反弹动画
 */
@property(nonatomic,assign)BOOL tfy_shouldAnimateBadge;
/**
 *  添加图片 image_str 图片字符串 object self  action 点击方法
 */
@property(nonatomic,copy,readonly)UIBarButtonItem *(^tfy_imageItem)(NSString *image_str,id object, SEL action);
/**
 *  添加 title_str 字体文本  fontOfSize字体大小  color 字体颜色 object self  action 点击方法
 */
@property(nonatomic,copy,readonly)UIBarButtonItem *(^tfy_titleItem)(NSString *title_str,CGFloat fontOfSize,UIColor *color,id object, SEL action);

@end

NS_ASSUME_NONNULL_END
