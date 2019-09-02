//
//  TFY_TabBarController.h
//  TFY_AutoLayoutModelTools
//
//  Created by 田风有 on 2019/5/14.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFY_TabBar.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TFY_TabBarControllerDelegate;
@interface TFY_TabBarController : UIViewController<TFY_TabBarDelegate>

/**
 *   标签栏控制器的委托对象。
 */
@property (nonatomic, weak) id<TFY_TabBarControllerDelegate> delegate;

/**
 *  选项卡栏界面显示的根视图控制器的数组。
 */
@property (nonatomic, copy)NSArray<UIViewController *> *viewControllers;

/**
 * 与此控制器关联的选项卡栏视图。（只读）
 */
@property (nonatomic,strong,readonly)TFY_TabBar *tabBar;

/**
 * 与当前选定选项卡项关联的视图控制器。
 */
@property (nonatomic, weak)UIViewController *selectedViewController;

/**
 * 与当前选定选项卡项关联的视图控制器的索引。
 */
@property (nonatomic)NSUInteger selectedIndex;

/**
 * 布尔值，该值确定选项卡栏是否隐藏。
 */
@property (nonatomic, getter=isTabBarHidden) BOOL tabBarHidden;

/**
 * 更改选项卡栏的可见性。
 */
-(void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated Hidden:(BOOL)hid_den;


@end

@protocol TFY_TabBarControllerDelegate <NSObject>
@optional
/**
 *  询问委托是否应该指定指定的视图控制器。
 */
- (BOOL)tabBarController:(TFY_TabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;

/**
 *  告诉委托用户在选项卡栏中选择项。
 */
- (void)tabBarController:(TFY_TabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;

@end

@interface UIViewController (TFY_TabBarControllerItem)

/**
 * 当添加到选项卡栏控制器时表示视图控制器的选项卡栏项。
 */
@property(nonatomic, setter = tfy_setTabBarItem:) TFY_TabBarItem *tfy_tabBarItem;

/**
 * 视图控制器层次结构中最接近的祖先，它是标签栏控制器。（只读）
 */
@property(nonatomic,strong,readonly)TFY_TabBarController *tfy_tabBarController;

@end

NS_ASSUME_NONNULL_END
