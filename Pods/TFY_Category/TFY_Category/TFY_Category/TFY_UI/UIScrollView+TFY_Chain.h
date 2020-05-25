//
//  UIScrollView+TFY_Chain.h
//  TFY_Category
//
//  Created by tiandengyou on 2019/11/4.
//  Copyright © 2019 恋机科技. All rights reserved.
// 
/**
self.tableView.tfy_headerScaleImage = [UIImage imageNamed:@"header"];
self.tableView.tfy_headerScaleImageHeight=200;
// 设置tableView头部视图，必须设置头部视图背景颜色为clearColor,否则会被挡住
UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 200)];
headerView.backgroundColor = [UIColor clearColor];
self.tableView.tableHeaderView = headerView;
*
*/
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static inline UIScrollView * _Nonnull tfy_scrollView(void){
    return [[UIScrollView alloc] init];
}
static inline UIScrollView * _Nonnull tfy_scrollViewframe(CGRect rect){
    return [[UIScrollView alloc] initWithFrame:rect];
}

@interface UIScrollView (TFY_Chain)
/**
 * 锁定垂直或水平
 */
@property(nonatomic, copy, readonly)UIScrollView *_Nonnull(^_Nonnull tfy_directionalLockEnabled)(BOOL);
/**
 * 视图范围内停止
 */
@property(nonatomic, copy, readonly)UIScrollView *_Nonnull(^_Nonnull tfy_pagingEnabled)(BOOL);
/**
 * 默认的是的。暂时关闭所有拖动
 */
@property(nonatomic, copy, readonly)UIScrollView *_Nonnull(^_Nonnull tfy_scrollEnabled)(BOOL);
/**
 * 如果是，反弹是，即使内容小于界限，允许垂直拖动
 */
@property(nonatomic, copy, readonly)UIScrollView *_Nonnull(^_Nonnull tfy_alwaysBounceVertical)(BOOL);
/**
 * 如果是，反弹是，即使内容小于界限，允许水平拖动
 */
@property(nonatomic, copy, readonly)UIScrollView *_Nonnull(^_Nonnull tfy_alwaysBounceHorizontal)(BOOL);
/**
 * 默认的是的。如果是，则跳过内容的边界并返回
 */
@property(nonatomic, copy, readonly)UIScrollView *_Nonnull(^_Nonnull tfy_bounces)(BOOL);
/**
 * 表示位图上下文将绘制完全不透明的图形。preferredFormat将此设置为NO。
 */
@property(nonatomic, copy, readonly)UIScrollView *_Nonnull(^_Nonnull tfy_opaque)(BOOL);
/**
 * 默认的是的。当我们跟踪时显示指示器。跟踪后淡出
 */
@property(nonatomic, copy, readonly)UIScrollView *_Nonnull(^_Nonnull tfy_showsVerticalScrollIndicator)(BOOL);
/**
 * 默认的是的。当我们跟踪时显示指示器。跟踪后淡出
 */
@property(nonatomic, copy, readonly)UIScrollView *_Nonnull(^_Nonnull tfy_showsHorizontalScrollIndicator)(BOOL);
/**
 * 默认是肯定的。如果设置，用户可以通过过去的最小/最大缩放手势和缩放将动画到最小/最大的价值在手势结束
 */
@property(nonatomic, copy, readonly)UIScrollView *_Nonnull(^_Nonnull tfy_bouncesZoom)(BOOL);
/**
 * 偏移量
 */
@property(nonatomic, copy, readonly)UIScrollView *_Nonnull(^_Nonnull tfy_contentOffset)(CGPoint);
/**
 * 容器大小
 */
@property(nonatomic, copy, readonly)UIScrollView *_Nonnull(^_Nonnull tfy_contentSize)(CGSize);
/**
 * 最小的偏移值
 */
@property(nonatomic, copy, readonly)UIScrollView *_Nonnull(^_Nonnull tfy_minimumZoomScale)(CGFloat);
/**
 * 偏移值
 */
@property(nonatomic, copy, readonly)UIScrollView *_Nonnull(^_Nonnull tfy_contentInset)(UIEdgeInsets);
/**
 * 最大的偏移值
 */
@property(nonatomic, copy, readonly)UIScrollView *_Nonnull(^_Nonnull tfy_maximumZoomScale)(CGFloat);
/**
 * 默认是1.0
 */
@property(nonatomic, copy, readonly)UIScrollView *_Nonnull(^_Nonnull tfy_zoomScale)(CGFloat);
/**
 * 代理方法
 */
@property(nonatomic, copy, readonly)UIScrollView *_Nonnull(^_Nonnull tfy_delegate)(id <UIScrollViewDelegate> delegate);
/**
 * 默认是UIScrollViewIndicatorStyleDefault
 */
@property(nonatomic, copy, readonly)UIScrollView *_Nonnull(^_Nonnull tfy_indicatorStyle)(UIScrollViewIndicatorStyle);
/**
 * 竖屏偏移量
 */
@property(nonatomic, copy, readonly)UIScrollView *_Nonnull(^_Nonnull tfy_verticalScrollIndicatorInsets)(UIEdgeInsets) API_AVAILABLE(ios(11.1), tvos(11.1));
/**
 * 横屏偏移量
 */
@property(nonatomic, copy, readonly)UIScrollView *_Nonnull(^_Nonnull tfy_horizontalScrollIndicatorInsets)(UIEdgeInsets) API_AVAILABLE(ios(11.1), tvos(11.1));
/**
 *  滑动偏移量
 */
@property(nonatomic, copy, readonly)UIScrollView *_Nonnull(^_Nonnull tfy_scrollIndicatorInsets)(UIEdgeInsets);
/**
 * 配置系统是否自动调整滚动指示器的insets。默认是肯定的。
 */
@property(nonatomic, copy, readonly)UIScrollView *_Nonnull(^_Nonnull tfy_automaticallyAdjustsScrollIndicatorInsets)(BOOL) API_AVAILABLE(ios(13.0), tvos(13.0));
/**
 *  配置stedcontentinset的行为。默认是UIScrollViewContentInsetAdjustmentAutomatic。
 */
@property(nonatomic, copy, readonly)UIScrollView *_Nonnull(^_Nonnull tfy_contentInsetAdjustmentBehavior)(UIScrollViewContentInsetAdjustmentBehavior) API_AVAILABLE(ios(11.0),tvos(11.0));
/**
 * 头部缩放视图图片
 */
@property (nonatomic, strong)UIImage *_Nonnull tfy_headerScaleImage;
/**
 * 头部缩放视图图片高度 默认200
 */
@property (nonatomic, assign)CGFloat tfy_headerScaleImageHeight;
/**
 * 生成图片
 */
- (void)screenSnapshot:(void(^)(UIImage *snapShotImage))finishBlock;
/**
 * 生成图片
 */
+(UIImage *_Nonnull)screenSnapshotWithSnapshotView:(UIView *_Nonnull)snapshotView;
/**
 * 生成图片
 */
+(UIImage *_Nonnull)screenSnapshotWithSnapshotView:(UIView *_Nonnull)snapshotView snapshotSize:(CGSize)snapshotSize;
@end

NS_ASSUME_NONNULL_END
