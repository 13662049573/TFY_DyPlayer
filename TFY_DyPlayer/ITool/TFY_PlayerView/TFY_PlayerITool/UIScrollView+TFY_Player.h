//
//  UIScrollView+TFY_Player.h
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/30.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * scrollView的滚动方向。
 */
typedef NS_ENUM(NSUInteger, PlayerScrollDirection) {
    PlayerScrollDirectionNone,
    PlayerScrollDirectionUp,         // 向上滑动
    PlayerScrollDirectionDown,       // 向下滚动
    PlayerScrollDirectionLeft,       // 向左滚动
    PlayerScrollDirectionRight       // 向右滚动
};

/*
 * scrollView方向。
 */
typedef NS_ENUM(NSInteger, PlayerScrollViewDirection) {
    PlayerScrollViewDirectionVertical,
    PlayerScrollViewDirectionHorizontal
};

/*
 * 播放器容器类型
 */
typedef NS_ENUM(NSInteger, PlayerContainerType) {
    PlayerContainerTypeCell,
    PlayerContainerTypeView
};


NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (TFY_Player)

/// 当ZFPlayerScrollViewDirection是ZFPlayerScrollViewDirectionVertical时，该属性具有值。
@property (nonatomic, readonly) CGFloat tfy_lastOffsetY;

/// 当ZFPlayerScrollViewDirection是ZFPlayerScrollViewDirectionHorizo​​ntal时，该属性具有值。
@property (nonatomic, readonly) CGFloat tfy_lastOffsetX;

///indexPath正在播放。
@property (nonatomic, nullable) NSIndexPath *tfy_playingIndexPath;

/// 应该播放的indexPath，一个亮起来的。
@property (nonatomic, nullable) NSIndexPath *tfy_shouldPlayIndexPath;

/// WWANA网络自动播放，默认为NO。
@property (nonatomic, getter=tfy_isWWANAutoPlay) BOOL tfy_WWANAutoPlay;

/// 播放器应该是自动播放器，默认为YES。
@property (nonatomic) BOOL tfy_shouldAutoPlay;

/// 播放器在scrollView中显示的视图标记。
@property (nonatomic) NSInteger tfy_containerViewTag;

/// scrollView滚动方向，默认为ZFPlayerScrollViewDirectionVertical。
@property (nonatomic) PlayerScrollViewDirection tfy_scrollViewDirection;

///滚动时scrollView的滚动方向。
///当ZFPlayerScrollViewDirection为ZFPlayerScrollViewDirectionVertical时，此值只能是ZFPlayerScrollDirectionUp或ZFPlayerScrollDirectionDown。
///当ZFPlayerScrollViewDirection为ZFPlayerScrollViewDirectionVertical时，此值只能是ZFPlayerScrollDirectionLeft或ZFPlayerScrollDirectionRight。
@property (nonatomic, readonly) PlayerScrollDirection tfy_scrollDirection;

/// 视频contrainerView类型。
@property (nonatomic, assign) PlayerContainerType tfy_containerType;

/// 正常模型中的视频contrainerView。
@property (nonatomic, strong) UIView *tfy_containerView;

/// 当单元格离开屏幕时，当前正在播放的单元格停止播放，默认为YES。
@property (nonatomic, assign) BOOL tfy_stopWhileNotVisible;

/// 已经停止了比赛
@property (nonatomic, assign) BOOL tfy_stopPlay;

/// 调用的块当播放停止滚动时。
@property (nonatomic, copy, nullable) void(^tfy_scrollViewDidStopScrollCallback)(NSIndexPath *indexPath);

/// 调用的块当播放应该玩的时候。
@property (nonatomic, copy, nullable) void(^tfy_shouldPlayIndexPathCallback)(NSIndexPath *indexPath);

/// 过滤滚动停止时应播放的单元格（滚动停止时播放）。
- (void)tfy_filterShouldPlayCellWhileScrolled:(void (^ __nullable)(NSIndexPath *indexPath))handler;

/// 过滤滚动时应播放的单元格（可以使用此过滤器突出显示的单元格）。
- (void)tfy_filterShouldPlayCellWhileScrolling:(void (^ __nullable)(NSIndexPath *indexPath))handler;

/// 根据indexPath获取单元格。
- (UIView *)tfy_getCellForIndexPath:(NSIndexPath *)indexPath;

/// 使用动画滚动到indexPath。
- (void)tfy_scrollToRowAtIndexPath:(NSIndexPath *)indexPath completionHandler:(void (^ __nullable)(void))completionHandler;

///使用动画滚动到indexPath。
- (void)tfy_scrollToRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated completionHandler:(void (^ __nullable)(void))completionHandler;

///滚动到带有动画持续时间的indexPath。
- (void)tfy_scrollToRowAtIndexPath:(NSIndexPath *)indexPath animateWithDuration:(NSTimeInterval)duration completionHandler:(void (^ __nullable)(void))completionHandler;

///------------------------------------
/// 必须在UIScrollViewDelegate中实现以下方法。
///------------------------------------

- (void)tfy_scrollViewDidEndDecelerating;

- (void)tfy_scrollViewDidEndDraggingWillDecelerate:(BOOL)decelerate;

- (void)tfy_scrollViewDidScrollToTop;

- (void)tfy_scrollViewDidScroll;

- (void)tfy_scrollViewWillBeginDragging;

///------------------------------------
/// end
///------------------------------------


@end

@interface UIScrollView (PlayerCannotCalled)

/// 当播放出现时调用该块。
@property (nonatomic, copy, nullable) void(^tfy_playerAppearingInScrollView)(NSIndexPath *indexPath, CGFloat playerApperaPercent);

/// 当播放消失时调用该块。
@property (nonatomic, copy, nullable) void(^tfy_playerDisappearingInScrollView)(NSIndexPath *indexPath, CGFloat playerDisapperaPercent);

/// 调用块当播放器出现时。
@property (nonatomic, copy, nullable) void(^tfy_playerWillAppearInScrollView)(NSIndexPath *indexPath);

/// 当播放出现时，调用该块。
@property (nonatomic, copy, nullable) void(^tfy_playerDidAppearInScrollView)(NSIndexPath *indexPath);

/// 调用的块当播放消失时。
@property (nonatomic, copy, nullable) void(^tfy_playerWillDisappearInScrollView)(NSIndexPath *indexPath);

/// 调用的块当播放消失时。
@property (nonatomic, copy, nullable) void(^tfy_playerDidDisappearInScrollView)(NSIndexPath *indexPath);

///当前播放器滚动滑出屏幕百分比。
///当`stopWhileNotVisible`为YES时使用的属性，停止当前播放的播放器。
///当`stopWhileNotVisible`为NO时使用的属性，当前播放的播放器添加到小容器视图。
/// 0.0~1.0，defalut为0.5。
/// 0.0是播放将消失。
/// 1.0是播放确实消失了。
@property (nonatomic) CGFloat tfy_playerDisapperaPercent;

///当前播放器滚动到屏幕百分比以播放视频。
/// 0.0~1.0，默认值为0.0。
/// 0.0是播放将出现的。
/// 1.0是播放确实出现的。
@property (nonatomic) CGFloat tfy_playerApperaPercent;

/// 当前的播放控制器消失了，而不是dealloc
@property (nonatomic) BOOL tfy_viewControllerDisappear;


@end

NS_ASSUME_NONNULL_END
