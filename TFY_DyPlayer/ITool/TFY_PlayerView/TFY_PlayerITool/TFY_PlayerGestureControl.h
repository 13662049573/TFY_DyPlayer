//
//  TFY_PlayerGestureControl.h
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/30.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PlayerGestureType) {
    PlayerGestureTypeUnknown,
    PlayerGestureTypeSingleTap,
    PlayerGestureTypeDoubleTap,
    PlayerGestureTypePan,
    PlayerGestureTypePinch
};

typedef NS_ENUM(NSUInteger, PanDirection) {
    PanDirectionUnknown,
    PanDirectionV,
    PanDirectionH,
};

typedef NS_ENUM(NSUInteger, PanLocation) {
    PanLocationUnknown,
    PanLocationLeft,
    PanLocationRight,
};

typedef NS_ENUM(NSUInteger, PanMovingDirection) {
    PanMovingDirectionUnkown,
    PanMovingDirectionTop,
    PanMovingDirectionLeft,
    PanMovingDirectionBottom,
    PanMovingDirectionRight,
};

/// 此枚举列出了默认情况下播放器具有的一些手势类型。
typedef NS_OPTIONS(NSUInteger, PlayerDisableGestureTypes) {
    PlayerDisableGestureTypesNone         = 0,
    PlayerDisableGestureTypesSingleTap    = 1 << 0,
    PlayerDisableGestureTypesDoubleTap    = 1 << 1,
    PlayerDisableGestureTypesPan          = 1 << 2,
    PlayerDisableGestureTypesPinch        = 1 << 3,
    PlayerDisableGestureTypesAll          = (PlayerDisableGestureTypesSingleTap | PlayerDisableGestureTypesDoubleTap | PlayerDisableGestureTypesPan | PlayerDisableGestureTypesPinch)
};

/// 该枚举列出了播放不支持的一些平移手势移动方向。
typedef NS_OPTIONS(NSUInteger, PlayerDisablePanMovingDirection) {
    PlayerDisablePanMovingDirectionNone         = 0,       /// 不禁用平移方向。
    PlayerDisablePanMovingDirectionVertical     = 1 << 0,  ///禁用平移移动垂直方向。
    PlayerDisablePanMovingDirectionHorizontal   = 1 << 1,  /// 禁用平移移动水平方向。
    PlayerDisablePanMovingDirectionAll          = (PlayerDisablePanMovingDirectionVertical | PlayerDisablePanMovingDirectionHorizontal)  /// 禁用平移所有方向。
};

NS_ASSUME_NONNULL_BEGIN

@interface TFY_PlayerGestureControl : NSObject
/**
 *  手势条件回调。
 */
@property (nonatomic, copy, nullable) BOOL(^triggerCondition)(TFY_PlayerGestureControl *control, PlayerGestureType type, UIGestureRecognizer *gesture, UITouch *touch);

/**
 *  单击手势回调。
 */
@property (nonatomic, copy, nullable) void(^singleTapped)(TFY_PlayerGestureControl *control);

/**
 *  双击手势回调。
 */
@property (nonatomic, copy, nullable) void(^doubleTapped)(TFY_PlayerGestureControl *control);

/**
 *  开始泛手势回调。
 */
@property (nonatomic, copy, nullable) void(^beganPan)(TFY_PlayerGestureControl *control, PanDirection direction, PanLocation location);
/**
 *  平移手势改变回调。
 */
@property (nonatomic, copy, nullable) void(^changedPan)(TFY_PlayerGestureControl *control, PanDirection direction, PanLocation location, CGPoint velocity);

/**
 *  结束Pan手势回调。
 */
@property (nonatomic, copy, nullable) void(^endedPan)(TFY_PlayerGestureControl *control, PanDirection direction, PanLocation location);

/**
 *  捏手势回调。
 */
@property (nonatomic, copy, nullable) void(^pinched)(TFY_PlayerGestureControl *control, float scale);

/**
 *  单击手势。
 */
@property (nonatomic, strong, readonly) UITapGestureRecognizer *singleTap;

/**
 *  双击手势。
 */
@property (nonatomic, strong, readonly) UITapGestureRecognizer *doubleTap;

/**
 * 平移点击手势。
 */
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGR;

/**
 *  捏水龙头手势。
 */
@property (nonatomic, strong, readonly) UIPinchGestureRecognizer *pinchGR;
/**
 * 平移手势方向。
 */
@property (nonatomic, readonly) PanDirection panDirection;

@property (nonatomic, readonly) PanLocation panLocation;

@property (nonatomic, readonly) PanMovingDirection panMovingDirection;

/**
 * 播放器不支持的手势类型。
 */
@property (nonatomic) PlayerDisableGestureTypes disableTypes;

/**
 * 平移手势移动方向，播放不支持。
 */
@property (nonatomic) PlayerDisablePanMovingDirection disablePanMovingDirection;

/**
 * 向视图添加手势。
 */
- (void)addGestureToView:(UIView *)view;

/**
 * 从视图中删除手势。
 */
- (void)removeGestureToView:(UIView *)view;


@end

NS_ASSUME_NONNULL_END
