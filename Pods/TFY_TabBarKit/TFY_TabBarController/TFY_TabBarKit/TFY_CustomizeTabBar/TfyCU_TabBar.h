//
//  TfyCU_TabBar.h
//  TFY_TabBarController
//
//  Created by tiandengyou on 2019/11/28.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TfyCU_TabBarItem.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TabBarIndicatorAnimationStyle) {
    TabBarIndicatorAnimationStyleDefault = 0,
    TabBarIndicatorAnimationStyle1,
};


@class TfyCU_TabBar,TfyCU_TabBarItem;

@protocol TfyCU_TabBarDelegate <NSObject>
@optional
/**
 *  是否能切换到指定index
 */
- (BOOL)tfy_tabBar:(TfyCU_TabBar *)tabBar shouldSelectItemAtIndex:(NSUInteger)index;

/**
 *  将要切换到指定index
 */
- (void)tfy_tabBar:(TfyCU_TabBar *)tabBar willSelectItemAtIndex:(NSUInteger)index;

/**
 *  已经切换到指定index
 */
- (void)tfy_tabBar:(TfyCU_TabBar *)tabBar didSelectedItemAtIndex:(NSUInteger)index;

@end


@interface TfyCU_TabBar : UIView
/**
 *  TabItems，提供给YPTabBarController使用，一般不手动设置此属性
 */
@property (nonatomic, copy) NSArray <TfyCU_TabBarItem *> *items;

@property (nonatomic, strong) UIColor *indicatorColor;         // item指示器颜色
@property (nonatomic, strong) UIImage *indicatorImage;         // item指示器图像
@property (nonatomic, assign) CGFloat indicatorCornerRadius;   // item指示器圆角
@property (nonatomic, assign) TabBarIndicatorAnimationStyle indicatorAnimationStyle;

@property (nonatomic, strong) UIColor *itemTitleColor;              // 标题颜色
@property (nonatomic, strong) UIColor *itemTitleSelectedColor;      // 选中时标题的颜色
@property (nonatomic, strong) UIFont  *itemTitleFont;               // 标题字体
@property (nonatomic, strong) UIFont  *itemTitleSelectedFont;       // 选中时标题的字体

@property (nonatomic, strong) UIColor *badgeBackgroundColor;        // Badge背景颜色
@property (nonatomic, strong) UIImage *badgeBackgroundImage;        // Badge背景图像
@property (nonatomic, strong) UIColor *badgeTitleColor;             // Badge标题颜色
@property (nonatomic, strong) UIFont  *badgeTitleFont;              // Badge标题字体

@property (nonatomic, assign) CGFloat leadingSpace;                 // 第一个item与左边或者上边的距离
@property (nonatomic, assign) CGFloat trailingSpace;                // 最后一个item与右边或者下边的距离

@property (nonatomic, assign) NSUInteger selectedItemIndex;          // 选中某一个item

/**
 *  拖动内容视图时，item的颜色是否根据拖动位置显示渐变效果，默认为YES
 */
@property (nonatomic, assign, getter = isItemColorChangeFollowContentScroll) BOOL itemColorChangeFollowContentScroll;

/**
 *  拖动内容视图时，item的字体是否根据拖动位置显示渐变效果，默认为NO
 */
@property (nonatomic, assign, getter = isItemFontChangeFollowContentScroll) BOOL itemFontChangeFollowContentScroll;

/**
 *  TabItem的选中背景是否随contentView滑动而移动
 */
@property (nonatomic, assign, getter = isIndicatorScrollFollowContent) BOOL indicatorScrollFollowContent;

/**
 *  将Image和Title设置为水平居中，默认为YES
 */
@property (nonatomic, assign, getter = isItemContentHorizontalCenter) BOOL itemContentHorizontalCenter;

/**
 *  TabItem选中切换时，指示器是否有动画
 */
@property (nonatomic, assign) BOOL indicatorSwitchAnimated;

@property (nonatomic, weak) id<TfyCU_TabBarDelegate> delegate;

/**
 *  返回已选中的item
 */
- (TfyCU_TabBarItem *)selectedItem;

/**
 *  根据titles创建item
 */
- (void)setTitles:(NSArray <NSString *> *)titles;

- (void)setSelectedItemIndex:(NSUInteger)selectedItemIndex animated:(BOOL)animated;

/**
 *  设置选中的index
 *  selectedItemIndex 选中的index
 *  animated          指示器是否有动画
 *  callDelegate      是否调用代理方法
 */
- (void)setSelectedItemIndex:(NSUInteger)selectedItemIndex animated:(BOOL)animated callDelegate:(BOOL)callDelegate;

/**
 *  设置tabBar为竖向且支持滚动，tabItem的高度根据tabBar高度和leadingSpace、trailingSpace属性计算
 *  一旦调用此方法，所有跟横向相关的效果将失效，例如内容视图滚动，指示器切换动画等
 */
- (void)layoutTabItemsVertical;

/**
 *  设置tabBar为竖向且支持滚动，一旦调用此方法，所有跟横向相关的效果将失效，例如内容视图滚动，指示器切换动画等
 *  一旦调用此方法，所有跟横向相关的效果将失效，例如内容视图滚动，指示器切换动画等
 *
 *  height 单个tabItem的高度
 */
- (void)layoutTabItemsVerticalWithItemHeight:(CGFloat)height;

/**
 *  设置tabItem的选中背景，这个背景可以是一个横条。
 *  此方法与setIndicatorWidthFixTextWithTop方法互斥，后调用者生效
 *  insets       选中背景的insets
 *  animated     点击item进行背景切换的时候，是否支持动画
 */
- (void)setIndicatorInsets:(UIEdgeInsets)insets tapSwitchAnimated:(BOOL)animated;

/**
 *  设置指示器的宽度根据title宽度来匹配
 *  此方法与setIndicatorInsets方法互斥，后调用者生效
 *  top 指示器与tabItem顶部的距离
 *  bottom 指示器与tabItem底部的距离
 *  additional 指示器与文字宽度匹配后额外增加或减少的长度，0表示相等，正数表示较长，负数表示较短
 *  animated 点击item进行背景切换的时候，是否支持动画
 */
- (void)setIndicatorWidthFitTextAndMarginTop:(CGFloat)top marginBottom:(CGFloat)bottom widthAdditional:(CGFloat)additional tapSwitchAnimated:(BOOL)animated;
/**
 *  设置指示器固定宽度
 *  width 指示器宽度，如果kua
 *  top 指示器与tabItem顶部的距离
 *  bottom 指示器与tabItem底部的距离
 *  animated 点击item进行背景切换的时候，是否支持动画
 */
- (void)setIndicatorWidth:(CGFloat)width marginTop:(CGFloat)top marginBottom:(CGFloat)bottom tapSwitchAnimated:(BOOL)animated;


/**
 *  设置tabBar可以左右滑动
 *  此方法与setScrollEnabledAndItemFitTextWidthWithSpacing这个方法是两种模式，哪个后调用哪个生效
 *  width 每个tabItem的宽度
 */
- (void)setScrollEnabledAndItemWidth:(CGFloat)width;

- (void)setScrollEnabledAndItemFitTextWidthWithSpacing:(CGFloat)spacing;

/**
 *  设置tabBar可以左右滑动，并且item的宽度根据标题的宽度来匹配
 *  此方法与setScrollEnabledAndItemWidth这个方法是两种模式，哪个后调用哪个生效
 *  spacing item的宽度 = 文字宽度 + spacing
 *  minWidth item的最小宽度
 */
- (void)setScrollEnabledAndItemFitTextWidthWithSpacing:(CGFloat)spacing minWidth:(CGFloat)minWidth;

/**
 *  将tabItem的image和title设置为居中，并且调整其在竖直方向的位置
 *  marginTop  与顶部的距离
 *  spacing    image和title的距离
 */
- (void)setItemContentHorizontalCenterAndMarginTop:(CGFloat)marginTop spacing:(CGFloat)spacing;

/**
 *  设置数字Badge的位置与大小。
 *  默认marginTop = 2，centerMarginRight = 30，titleHorizonalSpace = 8，titleVerticalSpace = 2。
 *  marginTop            与TabItem顶部的距离，默认为：2
 *  centerMarginRight    中心与TabItem右侧的距离，默认为：30
 *  titleHorizonalSpace  标题水平方向的空间，默认为：8
 *  titleVerticalSpace   标题竖直方向的空间，默认为：2
 */
- (void)setNumberBadgeMarginTop:(CGFloat)marginTop centerMarginRight:(CGFloat)centerMarginRight titleHorizonalSpace:(CGFloat)titleHorizonalSpace titleVerticalSpace:(CGFloat)titleVerticalSpace;
/**
 *  设置小圆点Badge的位置与大小。
 *  默认marginTop = 5，centerMarginRight = 25，sideLength = 10。
 *  marginTop            与TabItem顶部的距离，默认为：5
 *  centerMarginRight    中心与TabItem右侧的距离，默认为：25
 *  sideLength           小圆点的边长，默认为：10
 */
- (void)setDotBadgeMarginTop:(CGFloat)marginTop centerMarginRight:(CGFloat)centerMarginRight sideLength:(CGFloat)sideLength;

/**
 *  设置分割线
 *  itemSeparatorColor   分割线颜色
 *  thickness            分割线的粗细
 *  leading              与tabBar顶部或者左侧的距离
 *  trailing             与tabBar底部或者右侧距离
 */
- (void)setItemSeparatorColor:(UIColor *)itemSeparatorColor thickness:(CGFloat)thickness leading:(CGFloat)leading trailing:(CGFloat)trailing;

- (void)setItemSeparatorColor:(UIColor *)itemSeparatorColor leading:(CGFloat)leading trailing:(CGFloat)trailing;

/**
 *  添加一个特殊的YPTabItem到tabBar上，此TabItem不包含在tabBar的items数组里
 *  主要用于有的项目需要在tabBar的中间放置一个单独的按钮，类似于新浪微博等。
 *  此方法仅适用于不可滚动类型的tabBar
 *  item    TFY_TabBarItem对象
 *  index   将其放在此index的item后面
 *  handler 点击事件回调
 */
- (void)setSpecialItem:(TfyCU_TabBarItem *)item afterItemWithIndex:(NSUInteger)index tapHandler:(void (^)(TfyCU_TabBarItem *item))handler;

/**
 *  当TFY_TabBar所属的TFY_TabBarController内容视图支持拖动切换时，
 *  此方法用于同步内容视图scrollView拖动的偏移量，以此来改变TFY_TabBar内控件的状态
 */
- (void)updateSubViewsWhenParentScrollViewScroll:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
