//
//  TfyCU_TabBarView.h
//  TFY_TabBarController
//
//  Created by tiandengyou on 2019/11/28.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+TfyCU_Tab.h"
#import "TfyCU_TabBar.h"
#import "TfyCU_TabBarItem.h"

typedef NS_ENUM(NSInteger, TabHeaderStyle) {
    TabHeaderStyleStretch,
    TabHeaderStyleFollow
};

@class TfyCU_TabBarView;

NS_ASSUME_NONNULL_BEGIN

@interface TfyCU_TabBarTableView : UITableView

@end

@protocol TfyCU_TabBarViewDelegate <NSObject>

@optional

/**
 *  是否能切换到指定index
 */
- (BOOL)tabContentView:(TfyCU_TabBarView *)tabConentView shouldSelectTabAtIndex:(NSUInteger)index;

/**
 *  将要切换到指定index
 */
- (void)tabContentView:(TfyCU_TabBarView *)tabConentView willSelectTabAtIndex:(NSUInteger)index;

/**
 *  已经切换到指定index
 */
- (void)tabContentView:(TfyCU_TabBarView *)tabConentView didSelectedTabAtIndex:(NSUInteger)index;

/**
 *  当设置headerView时，内容视图竖向滚动时的y坐标偏移量
 */
- (void)tabContentView:(TfyCU_TabBarView *)tabConentView didChangedContentOffsetY:(CGFloat)offsetY;

@end


@interface TfyCU_TabBarView : UIView<TfyCU_TabBarDelegate>

@property (nonatomic, strong, readonly) TfyCU_TabBar *tabBar;

@property (nonatomic, copy) NSArray <UIViewController *> *viewControllers;

@property (nonatomic, weak) id<TfyCU_TabBarViewDelegate> delegate;

@property (nonatomic, strong, readonly) UIView *headerView;

/**
 *  第一次显示时，默认被选中的Tab的Index，在viewWillAppear方法被调用前设置有效
 */
@property (nonatomic, assign) NSUInteger defaultSelectedTabIndex;

/**
 *  设置被选中的Tab的Index，界面会自动切换
 */
@property (nonatomic, assign) NSUInteger selectedTabIndex;

/**
 *  此属性仅在内容视图支持滑动时有效，它控制child view controller调用viewDidLoad方法的时机
 *  1. 值为YES时，拖动内容视图，一旦拖动到该child view controller所在的位置，立即加载其view
 *  2. 值为NO时，拖动内容视图，拖动到该child view controller所在的位置，不会立即展示其view，而是要等到手势结束，scrollView停止滚动后，再加载其view
 *  3. 默认值为NO
 */
@property (nonatomic, assign) BOOL loadViewOfChildContollerWhileAppear;

/**
 *  在此属性仅在内容视图支持滑动时有效，它控制chile view controller未选中时，是否将其从父view上面移除
 *  默认为YES
 */
@property (nonatomic, assign) BOOL removeViewOfChildContollerWhileDeselected;

/**
 *  鉴于有些项目集成了左侧或者右侧侧边栏，当内容视图支持滑动切换时，不能实现在第一页向右滑动和最后一页向左滑动呼出侧边栏的功能，
 *  此2个属性则可以拦截第一页向右滑动和最后一页向左滑动的手势，实现呼出侧边栏的功能
 */
@property (nonatomic, assign) BOOL interceptRightSlideGuetureInFirstPage;
@property (nonatomic, assign) BOOL interceptLeftSlideGuetureInLastPage;

@property (nonatomic, strong) TfyCU_TabBarTableView *containerTableView;

/**
 *  设置HeaderView
 *  headerView UIView
 *  style 头部拉伸样式
 *  headerHeight headerView的默认高度
 *  tabBarHeight tabBar的高度
 *  tabBarStopOnTopHeight 当内容视图向上滚动时，TabBar停止移动的位置
 *  frame 整个界面的frame，一般来说是[UIScreen mainScreen].bounds
 */
- (void)setHeaderView:(UIView *)headerView style:(TabHeaderStyle)style headerHeight:(CGFloat)headerHeight tabBarHeight:(CGFloat)tabBarHeight tabBarStopOnTopHeight:(CGFloat)tabBarStopOnTopHeight frame:(CGRect)frame;

/**
 *  设置内容视图支持滑动切换，以及点击item切换时是否有动画
 *  enabled   是否支持滑动切换
 *  animated  点击切换时是否支持动画
 */
- (void)setContentScrollEnabled:(BOOL)enabled tapSwitchAnimated:(BOOL)animated;

/**
 *  获取被选中的ViewController
 */
- (UIViewController *)selectedController;

/**
 *  管理内容视图的ScrollView
 */
- (UIScrollView *)containerScrollView;

@end

@interface UIScrollView (TfyCU_TabBar)

@property (nonatomic, copy) void(^tfy_didScrollHandler)(UIScrollView *scrollView);
@end

NS_ASSUME_NONNULL_END
