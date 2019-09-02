//
//  UINavigationController+TFY_Extension.h
//  WYBasisKit
//
//  Created by 田风有 on 2019/03/27.
//  Copyright © 2019 恋机科技. All rights reserved.
//  https://github.com/13662049573/TFY_AutoLayoutModelTools

/*
 如果设置了导航栏的translucent = YES这时在添加子视图的坐标原点相对屏幕坐标是(0,0).如果设置了translucent = NO这时添加子视图的坐标原点相对屏幕坐标就是(0, navViewHeight)
 */

#import <UIKit/UIKit.h>


@interface UINavigationController (TFY_Extension)

/**
 * 导航栏标题字体颜色
 */
@property (nonatomic, strong) UIColor *tfy_titleColor;
/**
 * 导航栏标题字号
 */
@property (nonatomic, strong) UIFont *tfy_titleFont;
/**
 * 导航栏背景色
 */
@property (nonatomic, strong) UIColor *tfy_barBackgroundColor;
/**
 * 导航栏背景图片
 */
@property (nonatomic, strong) UIImage *tfy_barBackgroundImage;
/**
 *  导航栏左侧返回按钮背景图片
 */
@property (nonatomic, strong) UIImage *tfy_barReturnButtonImage;
/**
 * 导航栏左侧返回按钮背景颜色
 */
@property (nonatomic, strong) UIColor *tfy_barReturnButtonColor;
/**
 * 设置导航栏完全透明  会设置translucent = YES
 */
- (void)tfy_navigationBarTransparent;
/**
 * 让导航栏完全不透明 会设置translucent = NO
 */
- (void)tfy_navigationBarOpaque;
/**
 *  设置导航栏上滑收起,下滑显示(iOS8及以后有效)
 */
- (void)tfy_hidesNavigationBarsOnSwipe;

@end
