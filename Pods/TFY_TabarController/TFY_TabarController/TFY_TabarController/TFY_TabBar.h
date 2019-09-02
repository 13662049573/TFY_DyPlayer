//
//  TFY_TabBar.h
//  TFY_AutoLayoutModelTools
//
//  Created by 田风有 on 2019/5/14.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TFY_TabBar,TFY_TabBarItem;

@protocol TFY_TabBarDelegate <NSObject>

/**
 * 如果指定的选项卡栏项应被选中，请委托。
 */
- (BOOL)tabBar:(TFY_TabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index tabBarItem:(TFY_TabBarItem *)item addWithisMenuShow:(BOOL)isMenuShow;

/**
 * 告诉委托指定的选项卡栏项已被选中。
 */
- (void)tabBar:(TFY_TabBar *)tabBar didSelectItemAtIndex:(NSInteger)index tabBarItem:(TFY_TabBarItem *)item addWithisMenuShow:(BOOL)isMenuShow;

@end


@interface TFY_TabBar : UIView
/**
 * 标签栏的委托对象。
 */
@property (nonatomic, weak)id <TFY_TabBarDelegate> delegate;

/**
 * 标签栏上显示的项目。
 */
@property (nonatomic, copy)NSArray *items;

/**
 * 选项卡上当前选定的项。
 */
@property (nonatomic, weak)TFY_TabBarItem *selectedItem;

/**
 * backgroundview留下tabbar的物品。如果要添加其他视图，
 *把它们作为子视图backgroundview。
 */
@property (nonatomic, strong)UIView *backgroundView;

/*
 * contentedgeinsets可用于中心在tabbar中间的项目。
 */
@property UIEdgeInsets contentEdgeInsets;

/**
 * 设置标签栏的高度。
 */
- (void)setHeight:(CGFloat)height;

/**
 * 返回选项卡栏项的最小高度。
 */
- (CGFloat)minimumContentHeight;

/*
 * 启用或禁用TabBar半透明。默认是否定的。
 */
@property (nonatomic, getter=isTranslucent) BOOL translucent;

@end

NS_ASSUME_NONNULL_END
