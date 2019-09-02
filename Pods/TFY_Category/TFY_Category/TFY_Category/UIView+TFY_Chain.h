//
//  UIView+TFY_Chain.h
//  TFY_Category
//
//  Created by 田风有 on 2019/6/11.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (TFY_Chain)
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
 *  获取当前控制器
 */
- (UIViewController *_Nonnull)viewController;
/**
 *  获取当前navigationController
 */
- (UINavigationController *_Nonnull)navigationController;
/**
 *  获取当前tabBarController
 */
- (UITabBarController *_Nonnull)tabBarController;
/**
 *  添加四边阴影 shadowColor 颜色  shadowRadius 半径 shadowOpacity 透明度  setShadow 大小
 */
-(void)tfy_setShadow:(CGSize)size shadowOpacity:(CGFloat)opacity shadowRadius:(CGFloat)radius shadowColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
