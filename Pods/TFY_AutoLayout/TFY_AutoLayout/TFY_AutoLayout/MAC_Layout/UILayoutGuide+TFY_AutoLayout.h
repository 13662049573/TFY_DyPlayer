//
//  UILayoutGuide+TFY_AutoLayout.h
//  TFY_AutoLayoutModelTools
//
//  Created by 田风有 on 2019/5/1.
//  Copyright © 2019 恋机科技. All rights reserved.
//  https://github.com/13662049573/TFY_AutoLayoutModelTools

#import "TFY_AutoLayoutHerder.h"

NS_ASSUME_NONNULL_BEGIN

typedef TFY_CLASS_LGUIDE * _Nonnull (^LGLessOrEqual)(void) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGGreaterOrEqual)(void) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGResetConstraintAttribute)(void) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGClearConstraintAttribute)(void) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGRemoveConstraintAttribute)(NSLayoutAttribute attributes, ...) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGRemoveConstraintFromViewAttribute)(TFY_CLASS_VIEW * _Nonnull view, NSLayoutAttribute attributes, ...) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGRemoveConstraintToViewAttribute)(TFY_VIEW * _Nonnull toView, NSLayoutAttribute attributes, ...) NS_AVAILABLE(10_11, 9_0);

typedef TFY_CLASS_LGUIDE * _Nonnull (^LGPriorityLow)(void) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGPriorityHigh)(void) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGPriorityRequired)(void) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGPriorityFitting)(void) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGPriorityValue)(CGFloat value) NS_AVAILABLE(10_11, 9_0);

typedef TFY_CLASS_LGUIDE * _Nonnull (^LGLeftSpace)(CGFloat value) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGLeftSpaceToView)(CGFloat value , TFY_VIEW * _Nonnull toView) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGLeftSpaceEqualView)(TFY_VIEW * _Nonnull view) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGLeftSpaceEqualViewOffset)(TFY_VIEW * _Nonnull view, CGFloat offset) NS_AVAILABLE(10_11, 9_0);

typedef TFY_CLASS_LGUIDE * _Nonnull (^LGLeadingSpace)(CGFloat value) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGLeadingSpaceToView)(CGFloat value , TFY_VIEW * _Nonnull toView) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGLeadingSpaceEqualView)(TFY_VIEW * _Nonnull view) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGLeadingSpaceEqualViewOffset)(TFY_VIEW * _Nonnull view, CGFloat offset) NS_AVAILABLE(10_11, 9_0);

typedef TFY_CLASS_LGUIDE * _Nonnull (^LGTrailingSpace)(CGFloat value) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGTrailingSpaceToView)(CGFloat value , TFY_VIEW * _Nonnull toView) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGTrailingSpaceEqualView)(TFY_VIEW * _Nonnull view) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGTrailingSpaceEqualViewOffset)(TFY_VIEW * _Nonnull view, CGFloat offset) NS_AVAILABLE(10_11, 9_0);

typedef TFY_CLASS_LGUIDE * _Nonnull (^LGBaseLineSpace)(CGFloat value) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGBaseLineSpaceToView)(CGFloat value , TFY_VIEW * _Nonnull toView) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGBaseLineSpaceEqualView)(TFY_VIEW * _Nonnull view) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGBaseLineSpaceEqualViewOffset)(TFY_VIEW * _Nonnull view, CGFloat offset) NS_AVAILABLE(10_11, 9_0);

typedef TFY_CLASS_LGUIDE * _Nonnull (^LGRightSpace)(CGFloat value) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGRightSpaceToView)(CGFloat value , TFY_VIEW * _Nonnull toView) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGRightSpaceEqualView)(TFY_VIEW * _Nonnull view) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGRightSpaceEqualViewOffset)(TFY_VIEW * _Nonnull view, CGFloat offset) NS_AVAILABLE(10_11, 9_0);

typedef TFY_CLASS_LGUIDE * _Nonnull (^LGTopSpace)(CGFloat value) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGTopSpaceToView)(CGFloat value , TFY_VIEW * _Nonnull toView) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGTopSpaceEqualView)(TFY_VIEW * _Nonnull view) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGTopSpaceEqualViewOffset)(TFY_VIEW * _Nonnull view, CGFloat offset) NS_AVAILABLE(10_11, 9_0);

typedef TFY_CLASS_LGUIDE * _Nonnull (^LGBottomSpace)(CGFloat value) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGBottomSpaceToView)(CGFloat value , TFY_VIEW * _Nonnull toView) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGBottomSpaceEqualView)(TFY_VIEW * _Nonnull view) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGBottomSpaceEqualViewOffset)(TFY_VIEW * _Nonnull view, CGFloat offset) NS_AVAILABLE(10_11, 9_0);

typedef TFY_CLASS_LGUIDE * _Nonnull (^LGWidth)(CGFloat value) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGWidthAuto)(void) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGWidthEqualView)(TFY_VIEW * _Nonnull view) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGWidthEqualViewRatio)(TFY_VIEW * _Nonnull view, CGFloat ratio) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGWidthHeightRatio)(CGFloat ratio) NS_AVAILABLE(10_11, 9_0);

typedef TFY_CLASS_LGUIDE * _Nonnull (^LGHeight)(CGFloat value) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGHeightAuto)(void) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGHeightEqualView)(TFY_VIEW * _Nonnull view) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGHeightEqualViewRatio)(TFY_VIEW * _Nonnull view, CGFloat ratio) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGHeightWidthRatio)(CGFloat ratio);

typedef TFY_CLASS_LGUIDE * _Nonnull (^LGCenterX)(CGFloat value) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGCenterXToView)(CGFloat value, TFY_VIEW * _Nonnull toView) NS_AVAILABLE(10_11, 9_0);

typedef TFY_CLASS_LGUIDE * _Nonnull (^LGCenterY)(CGFloat value) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGCenterYToView)(CGFloat value, TFY_VIEW * _Nonnull toView) NS_AVAILABLE(10_11, 9_0);

typedef TFY_CLASS_LGUIDE * _Nonnull (^LGCenter)(CGFloat x, CGFloat y) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGCenterToView)(CGPoint center, TFY_VIEW * _Nonnull toView) NS_AVAILABLE(10_11, 9_0);

typedef TFY_CLASS_LGUIDE * _Nonnull (^LGsize)(CGFloat width, CGFloat height) NS_AVAILABLE(10_11, 9_0);
typedef TFY_CLASS_LGUIDE * _Nonnull (^LGSizeEqual)(TFY_VIEW * _Nonnull view) NS_AVAILABLE(10_11, 9_0);

typedef TFY_CLASS_LGUIDE * _Nonnull (^LGFrameEqual)(TFY_VIEW * _Nonnull view) NS_AVAILABLE(10_11, 9_0);

NS_AVAILABLE(10_11, 9_0)
@interface TFY_CLASS_LGUIDE (TFY_AutoLayout)
/**
 * 当前约束小于等于
 */
@property (nonatomic ,copy , readonly)LGLessOrEqual _Nonnull tfy_LessOrEqual;
/**
*  当前约束大于等于
*/
@property (nonatomic ,copy , readonly)LGGreaterOrEqual _Nonnull tfy_GreaterOrEqual;
/**
*  重置缓存约束
*/
@property (nonatomic ,copy , readonly)LGResetConstraintAttribute _Nonnull tfy_ResetConstraint;
/**
*  清除所有约束
*/
@property (nonatomic ,copy , readonly)LGClearConstraintAttribute _Nonnull tfy_ClearLayoutAttr;
/**
*  移除约束(NSLayoutAttribute attributes, ...)
*/
@property (nonatomic ,copy , readonly)LGRemoveConstraintAttribute _Nonnull tfy_RemoveLayoutAttrs;
/**
* 移除约束从指定视图上(TFY_VIEW * view, NSLayoutAttribute attributes, ...)
*/
@property (nonatomic ,copy , readonly)LGRemoveConstraintFromViewAttribute _Nonnull tfy_RemoveFromLayoutAttrs;
/**
* 移除约束从关联视图上(TFY_VIEW * toView, NSLayoutAttribute attributes, ...)
*/
@property (nonatomic ,copy , readonly)LGRemoveConstraintToViewAttribute _Nonnull tfy_RemoveToLayoutAttrs;
/**
*  设置当前约束的低优先级
*/
@property (nonatomic ,copy , readonly)LGPriorityLow _Nonnull tfy_PriorityLow;
/**
*  设置当前约束的高优先级
*/
@property (nonatomic ,copy , readonly)LGPriorityHigh _Nonnull tfy_PriorityHigh;
/**
*  设置当前约束的默认优先级
*/
@property (nonatomic ,copy , readonly)LGPriorityRequired _Nonnull tfy_PriorityRequired;
/**
*  设置当前约束的合适优先级
*/
@property (nonatomic ,copy , readonly)LGPriorityFitting _Nonnull tfy_PriorityFitting;
/**
*  设置当前约束的优先级 (CGFloat value): 优先级大小(0-1000)
*/
@property (nonatomic ,copy , readonly)LGPriorityValue _Nonnull tfy_Priority;
/**
*   与父视图左边间距(CGFloat value)
*/
@property (nonatomic ,copy , readonly)LGLeftSpace _Nonnull tfy_LeftSpace;
/**
*  与相对视图toView左边间距(CGFloat value,TFY_VIEW * toView)
*/
@property (nonatomic ,copy , readonly)LGLeftSpaceToView _Nonnull tfy_LeftSpaceToView;
/**
*  与视图view左边间距相等(TFY_VIEW * view)
*/
@property (nonatomic ,copy , readonly)LGLeftSpaceEqualView _Nonnull tfy_LeftSpaceEqualView;
/**
* 与视图view左边间距相等并偏移offset(TFY_VIEW * view, CGFloat offset)
*/
@property (nonatomic ,copy , readonly)LGLeftSpaceEqualViewOffset _Nonnull tfy_LeftSpaceEqualViewOffset;
/**
*  与父视图左边间距(CGFloat value)
*/
@property (nonatomic ,copy , readonly)LGLeadingSpace _Nonnull tfy_LeadingSpace;
/**
* 与相对视图toView左边间距(CGFloat value,TFY_VIEW * toView)
*/
@property (nonatomic ,copy , readonly)LGLeadingSpaceToView _Nonnull tfy_LeadingSpaceToView;
/**
*  与视图view左边间距相等(TFY_VIEW * view)
*/
@property (nonatomic ,copy , readonly)LGLeadingSpaceEqualView _Nonnull tfy_LeadingSpaceEqualView;
/**
*  与视图view左边间距相等并偏移offset (TFY_VIEW * view, CGFloat offset)
*/
@property (nonatomic ,copy , readonly)LGLeadingSpaceEqualViewOffset _Nonnull tfy_LeadingSpaceEqualViewOffset;
/**
*  与父视图右边间距(CGFloat value)
*/
@property (nonatomic ,copy , readonly)LGTrailingSpace _Nonnull tfy_TrailingSpace;
/**
*  与相对视图toView右边间距(CGFloat value,TFY_VIEW * toView)
*/
@property (nonatomic ,copy , readonly)LGTrailingSpaceToView _Nonnull tfy_TrailingSpaceToView;
/**
*  与视图view右边间距相等(TFY_VIEW * view)
*/
@property (nonatomic ,copy , readonly)LGTrailingSpaceEqualView _Nonnull tfy_TrailingSpaceEqualView;
/**
*  与视图view右边间距相等并偏移offset(TFY_VIEW * view, CGFloat offset)
*/
@property (nonatomic ,copy , readonly)LGTrailingSpaceEqualViewOffset _Nonnull tfy_TrailingSpaceEqualViewOffset;

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
/**
*  与父视图底边间距Y(CGFloat value)
*/
@property (nonatomic ,copy , readonly)LGBaseLineSpace _Nonnull tfy_FirstBaseLine;
/**
*  与相对视图toView底边间距Y(CGFloat value,TFY_VIEW * toView)
*/
@property (nonatomic ,copy , readonly)LGBaseLineSpaceToView _Nonnull tfy_FirstBaseLineToView;
/**
*  与视图view底边间距Y相等(TFY_VIEW * view)
*/
@property (nonatomic ,copy , readonly)LGBaseLineSpaceEqualView _Nonnull tfy_FirstBaseLineEqualView;
/**
*  与视图view底边间距Y相等并偏移offset(TFY_VIEW * view, CGFloat offset)
*/
@property (nonatomic ,copy , readonly)LGBaseLineSpaceEqualViewOffset _Nonnull tfy_FirstBaseLineEqualViewOffset;
#endif
/**
*  与父视图底边间距Y(CGFloat value)
*/
@property (nonatomic ,copy , readonly)LGBaseLineSpace _Nonnull tfy_LastBaseLine;
/**
*  与相对视图toView底边间距Y(CGFloat value,TFY_VIEW * toView)
*/
@property (nonatomic ,copy , readonly)LGBaseLineSpaceToView _Nonnull tfy_LastBaseLineToView;
/**
*  与视图view底边间距Y相等(TFY_VIEW * view)
*/
@property (nonatomic ,copy , readonly)LGBaseLineSpaceEqualView _Nonnull tfy_LastBaseLineEqualView;
/**
*  与视图view底边间距Y相等并偏移offset(TFY_VIEW * view, CGFloat offset)
*/
@property (nonatomic ,copy , readonly)LGBaseLineSpaceEqualViewOffset _Nonnull tfy_LastBaseLineEqualViewOffset;
/**
*  与父视图右边间距(CGFloat value)
*/
@property (nonatomic ,copy , readonly)LGRightSpace _Nonnull tfy_RightSpace;
/**
*  与相对视图toView右边间距(CGFloat value,TFY_VIEW * toView)
*/
@property (nonatomic ,copy , readonly)LGRightSpaceToView _Nonnull tfy_RightSpaceToView;
/**
*  与相对视图toView右边间距相等(TFY_VIEW toView)
*/
@property (nonatomic ,copy , readonly)LGRightSpaceEqualView _Nonnull tfy_RightSpaceEqualView;
/**
*  与相对视图toView右边间距相等并偏移offset(TFY_VIEW toView, CGFloat offset)
*/
@property (nonatomic ,copy , readonly)LGRightSpaceEqualViewOffset _Nonnull tfy_RightSpaceEqualViewOffset;
/**
*  与父视图顶边间距(CGFloat value)
*/
@property (nonatomic ,copy , readonly)LGTopSpace _Nonnull tfy_TopSpace;
/**
*  与相对视图toView顶边间距(CGFloat value,TFY_VIEW * toView)
*/
@property (nonatomic ,copy , readonly)LGTopSpaceToView _Nonnull tfy_TopSpaceToView;
/**
*  与视图view顶边间距相等(TFY_VIEW * view)
*/
@property (nonatomic ,copy , readonly)LGTopSpaceEqualView _Nonnull tfy_TopSpaceEqualView;
/**
*  与视图view顶边间距相等并偏移offset(TFY_VIEW * view, CGFloat offset)
*/
@property (nonatomic ,copy , readonly)LGTopSpaceEqualViewOffset _Nonnull tfy_TopSpaceEqualViewOffset;
/**
*  与父视图底边间距(CGFloat value)
*/
@property (nonatomic ,copy , readonly)LGBottomSpace _Nonnull tfy_BottomSpace;
/**
*  与相对视图toView底边间距(CGFloat value,TFY_VIEW * toView)
*/
@property (nonatomic ,copy , readonly)LGBottomSpaceToView _Nonnull tfy_BottomSpaceToView;
/**
*  与相对视图toView底边间距相等(TFY_VIEW * toView)
*/
@property (nonatomic ,copy , readonly)LGBottomSpaceEqualView _Nonnull tfy_BottomSpaceEqualView;
/**
*  与相对视图toView底边间距相等并偏移offset(TFY_VIEW * toView, CGFloat offset)
*/
@property (nonatomic ,copy , readonly)LGBottomSpaceEqualViewOffset _Nonnull tfy_BottomSpaceEqualViewOffset;
/**
*  宽度(CGFloat value)
*/
@property (nonatomic ,copy , readonly)LGWidth _Nonnull tfy_Width;
/**
*  宽度自动()
*/
@property (nonatomic ,copy , readonly)LGWidthAuto _Nonnull tfy_WidthAuto;
/**
*  宽度等于视图view(TFY_VIEW * view)
*/
@property (nonatomic ,copy , readonly)LGWidthEqualView _Nonnull tfy_WidthEqualView;
/**
*  宽度等于视图view 参照比例Ratio(TFY_VIEW * view ,CGFloat ratio)
*/
@property (nonatomic ,copy , readonly)LGWidthEqualViewRatio _Nonnull tfy_WidthEqualViewRatio;
/**
*  视图自身宽度与高度的比(CGFloat Ratio)
*/
@property (nonatomic ,copy , readonly)LGWidthHeightRatio _Nonnull tfy_WidthHeightRatio;
/**
*  高度(CGFloat value)
*/
@property (nonatomic ,copy , readonly)LGHeight _Nonnull tfy_Height;
/**
*  高度自动()
*/
@property (nonatomic ,copy , readonly)LGHeightAuto _Nonnull tfy_HeightAuto;
/**
*  高度等于视图view(TFY_VIEW * view)
*/
@property (nonatomic ,copy , readonly)LGHeightEqualView _Nonnull tfy_HeightEqualView;
/**
*  高度等于视图view 参照比例Ratio(TFY_VIEW * view ,CGFloat ratio)
*/
@property (nonatomic ,copy , readonly)LGHeightEqualViewRatio _Nonnull tfy_HeightEqualViewRatio;
/**
*  视图自身高度与宽度的比(CGFloat Ratio)
*/
@property (nonatomic ,copy , readonly)LGHeightWidthRatio _Nonnull tfy_HeightWidthRatio;
/**
*  中心X与父视图偏移(CGFloat value)
*/
@property (nonatomic ,copy , readonly)LGCenterX _Nonnull tfy_CenterX;
/**
*  中心X与视图view偏移(CGFloat value , TFY_VIEW * toView)
*/
@property (nonatomic ,copy , readonly)LGCenterXToView _Nonnull tfy_CenterXToView;
/**
*  中心Y与父视图偏移(CGFloat value)
*/
@property (nonatomic ,copy , readonly)LGCenterY _Nonnull tfy_CenterY;
/**
*  中心Y与视图view偏移(CGFloat value , TFY_VIEW * toView)
*/
@property (nonatomic ,copy , readonly)LGCenterYToView _Nonnull tfy_CenterYToView;
/**
*  中心与父视图偏移(CGFloat value)
*/
@property (nonatomic ,copy , readonly)LGCenter _Nonnull tfy_Center;
/**
*  中心与视图view偏移(CGFloat value , TFY_VIEW * toView)
*/
@property (nonatomic ,copy , readonly)LGCenterToView _Nonnull tfy_CenterToView;
/**
*  size设置(CGFloat width, CGFloat height)
*/
@property (nonatomic ,copy , readonly)LGsize _Nonnull tfy_Size;
/**
*  size设置(TFY_VIEW * view)
*/
@property (nonatomic ,copy , readonly)LGSizeEqual _Nonnull tfy_SizeEqualView;
/**
*  frame设置(TFY_VIEW * view)
*/
@property (nonatomic ,copy , readonly)LGFrameEqual _Nonnull tfy_FrameEqualView;


#pragma **************************** 方法展示 ****************************
/**
*  重置缓存的约束,该方法在当前视图对象移除从父视图上可能需要调用清除与父视图之前旧约束缓存对象
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_ResetConstraints;
/**
*  清除所有布局属性
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_ClearLayoutAttrs;
/**
*  移除一个或者一组约束 attributes 约束类型（可变参数）
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_RemoveLayoutAttr:(NSLayoutAttribute)attributes, ...;
/**
*  移除一个单个属性  attribute 约束类型
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_RemoveLayoutOneAttr:(NSLayoutAttribute)attribute;
/**
*  移除一个或者一组约束从指定的视图上 view 指定视图  attributes 约束类型（可变参数）
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_RemoveFrom:(TFY_CLASS_LGUIDE * _Nonnull)view layoutAttrs:(NSLayoutAttribute)attributes, ...;
/**
*  移除一个约束从指定的视图上 view 指定视图  attribute 约束类型
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_RemoveFrom:(TFY_CLASS_LGUIDE * _Nonnull)view layoutAttr:(NSLayoutAttribute)attribute;
/**
*  移除一个约束从关联的视图  view 关联的视图 attribute 移除的约束
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_RemoveTo:(TFY_VIEW * _Nonnull)view attr:(NSLayoutAttribute)attribute;
/**
*  移除多个约束从关联的视图 view 关联的视图  attributes 移除的约束
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_RemoveTo:(TFY_VIEW * _Nonnull)view layoutAttrs:(NSLayoutAttribute)attributes, ... ;
/**
*  设置当前约束的低优先级
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_priorityLow;
/**
*  设置当前约束的高优先级
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_priorityHigh;
/**
*  设置当前约束的默认优先级
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_priorityRequired;
/**
*  设置当前约束的合适优先级
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_priorityFitting;
/**
*  设置当前约束的优先级 value 优先级大小(0-1000)
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_priority:(CGFloat)value;
/**
*  设置左边距(默认相对父视图) leftSpace 左边距
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_LeftSpace:(CGFloat)leftSpace;
/**
* 设置左边距 leftSpace 左边距 toView 相对视图
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_LeftSpace:(CGFloat)leftSpace toView:(TFY_VIEW * _Nonnull)toView;
/**
*  设置左边距与视图view左边距相等 view 相对视图
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_LeftSpaceEqualView:(TFY_VIEW * _Nonnull)view;
/**
*  设置左边距与视图view左边距相等并偏移offset view 相对视图 offset 偏移量
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_LeftSpaceEqualView:(TFY_VIEW * _Nonnull)view offset:(CGFloat)offset;
/**
*  设置右边距(默认相对父视图) rightSpace 右边距
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_RightSpace:(CGFloat)rightSpace;
/**
*  设置右边距 rightSpace 右边距 toView 相对视图
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_RightSpace:(CGFloat)rightSpace toView:(TFY_VIEW * _Nonnull)toView;
/**
*  设置右边距与视图view左对齐边距相等 view 相对视图
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_RightSpaceEqualView:(TFY_VIEW * _Nonnull)view;
/**
*  设置右边距与视图view左对齐边距相等并偏移offset view 相对视图 offset 偏移量
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_RightSpaceEqualView:(TFY_VIEW * _Nonnull)view offset:(CGFloat)offset;
/**
*  设置左对齐(默认相对父视图) leadingSpace 左边距
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_LeadingSpace:(CGFloat)leadingSpace;
/**
*  设置左对齐 leadingSpace 左边距 toView 相对视图
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_LeadingSpace:(CGFloat)leadingSpace toView:(TFY_VIEW * _Nonnull)toView;
/**
*  设置左对齐边距与某视图左对齐边距相等 view 相对视图
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_LeadingSpaceEqualView:(TFY_VIEW * _Nonnull)view;
/**
*  设置左对齐边距与某视图左对齐边距相等并偏移offset view 相对视图 offset 偏移量
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_LeadingSpaceEqualView:(TFY_VIEW * _Nonnull)view offset:(CGFloat)offset;
/**
*  设置右对齐(默认相对父视图) trailingSpace 右边距
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_TrailingSpace:(CGFloat)trailingSpace;
/**
*  设置右对齐 trailingSpace 右边距 toView 相对视图
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_TrailingSpace:(CGFloat)trailingSpace toView:(TFY_VIEW * _Nonnull)toView;
/**
*  设置右对齐边距与某视图右对齐边距相等 view 相对视图
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_TrailingSpaceEqualView:(TFY_VIEW * _Nonnull)view;
/**
*  设置右对齐边距与某视图右对齐边距相等并偏移offset view 相对视图 offset 偏移量
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_TrailingSpaceEqualView:(TFY_VIEW * _Nonnull)view offset:(CGFloat)offset;
/**
*  设置顶边距(默认相对父视图) topSpace 顶边距
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_TopSpace:(CGFloat)topSpace;
/**
*  设置顶边距 topSpace 顶边距 toView 相对视图
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_TopSpace:(CGFloat)topSpace toView:(TFY_VIEW * _Nonnull)toView;
/**
*  设置顶边距与视图view顶边距相等 view 相对视图
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_TopSpaceEqualView:(TFY_VIEW * _Nonnull)view;
/**
*  设置顶边距与视图view顶边距相等并偏移offset view 相对视图 offset 偏移量
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_TopSpaceEqualView:(TFY_VIEW * _Nonnull)view offset:(CGFloat)offset;
/**
*  设置底边距(默认相对父视图) bottomSpace 底边距
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_BottomSpace:(CGFloat)bottomSpace;
/**
*  设置底边距  bottomSpace 底边距 toView 相对视图
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_BottomSpace:(CGFloat)bottomSpace toView:(TFY_VIEW * _Nonnull)toView;
/**
*  设置底边距与视图view底边距相等 view 相对视图
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_BottomSpaceEqualView:(TFY_VIEW * _Nonnull)view;
/**
*  设置底边距与视图view底边距相等并偏移offset view 相对视图 offset 偏移量
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_BottomSpaceEqualView:(TFY_VIEW * _Nonnull)view offset:(CGFloat)offset;
/**
*  设置宽度 width 宽度
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_Width:(CGFloat)width;
/**
*  设置宽度与某个视图相等 view 相对视图
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_WidthEqualView:(TFY_VIEW * _Nonnull)view;
/**
*  设置宽度与视图view相等 view 相对视图 ratio 比例
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_WidthEqualView:(TFY_VIEW * _Nonnull)view ratio:(CGFloat)ratio;
/**
*  设置自动宽度
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_AutoWidth;
/**
*  设置视图自身宽度与高度的比 ratio 比例
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_WidthHeightRatio:(CGFloat)ratio;
/**
*  设置高度  height 高度
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_Height:(CGFloat)height;
/**
*  设置高度与视图view相等  view 相对视图
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_HeightEqualView:(TFY_VIEW * _Nonnull)view;
/**
*  设置高度与视图view相等 view 相对视图 ratio 比例
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_HeightEqualView:(TFY_VIEW * _Nonnull)view ratio:(CGFloat)ratio;
/**
*  设置自动高度
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_AutoHeight;
/**
*  设置视图自身高度与宽度的比 ratio 比例
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_HeightWidthRatio:(CGFloat)ratio;
/**
*  设置中心x与父视图中心的偏移 centerX = 0 与父视图中心x重合 centerX 中心x坐标偏移
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_CenterX:(CGFloat)centerX;
/**
*  设置中心x与相对视图中心的偏移 centerX = 0 与相对视图中心x重合 centerX 中心x坐标偏移 toView 相对视图
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_CenterX:(CGFloat)centerX toView:(TFY_VIEW * _Nonnull)toView;
/**
*  设置中心y与父视图中心的偏移 centerY = 0 与父视图中心y重合 centerY 中心y坐标偏移
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_CenterY:(CGFloat)centerY;
/**
* 设置中心y与相对视图中心的偏移 centerY = 0 与相对视图中心y重合 centerY 中心y坐标偏移 toView 相对视图
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_CenterY:(CGFloat)centerY toView:(TFY_VIEW * _Nonnull)toView;

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
/**
*  设置顶部基线偏移(默认相对父视图) space 间隙
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_FirstBaseLine:(CGFloat)space;
/**
*  设置顶部基线与对象视图底部基线偏移 space 间隙 toView 相对视图
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_FirstBaseLine:(CGFloat)space toView:(TFY_VIEW * _Nonnull)toView;
/**
*  设置顶部基线与相对视图顶部基线相等 view 相对视图
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_FirstBaseLineEqualView:(TFY_VIEW * _Nonnull)view;
/**
*  设置顶部基线与相对视图顶部基线相等并偏移offset view 相对视图 offset 偏移量
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_FirstBaseLineEqualView:(TFY_VIEW * _Nonnull)view offset:(CGFloat)offset;

#endif
/**
*  设置底部基线偏移(默认相对父视图)  space 间隙
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_LastBaseLine:(CGFloat)space;
/**
*  设置底部基线与对象视图顶部基线偏移 space 间隙 toView 相对视图
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_LastBaseLine:(CGFloat)space toView:(TFY_VIEW * _Nonnull)toView;
/**
*  设置底部基线与相对视图底部基线相等 view 相对视图
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_LastBaseLineEqualView:(TFY_VIEW * _Nonnull)view;
/**
* 设置底部基线与相对视图底部基线相等并偏移offset view 相对视图  offset 偏移量
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_LastBaseLineEqualView:(TFY_VIEW * _Nonnull)view offset:(CGFloat)offset;
/**
*  设置中心偏移(默认相对父视图)center = CGPointZero 与父视图中心重合 center 中心偏移xy
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_Center:(CGPoint)center;
/**
*  设置中心偏移(默认相对父视图)center = CGPointZero 与父视图中心重合 center 中心偏移xy toView 相对视图
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_Center:(CGPoint)center toView:(TFY_VIEW * _Nonnull)toView;
/**
* 设置frame(默认相对父视图) left 左边距 top 顶边距 width 宽度 height 高度
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_Frame:(CGFloat)left top:(CGFloat)top width:(CGFloat)width height:(CGFloat)height;
/**
* 设置frame (默认相对父视图) left 左边距 top 顶边距 right 右边距 bottom 底边距
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_AutoSize:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom;
/**
 * 设置frame left 左边距 top 顶边距 width 宽度 height 高度 toView 相对视图
 */
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_Frame:(CGFloat)left top:(CGFloat)top width:(CGFloat)width height:(CGFloat)height toView:(TFY_VIEW * _Nonnull)toView;
/**
 * 设置frame (默认相对父视图) left 左边距 top 顶边距 right 右边距 height 高度
 */
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_AutoWidth:(CGFloat)left top:(CGFloat)top right:(CGFloat)right height:(CGFloat)height;
/**
 *  设置frame (默认相对父视图) left 左边距 top 顶边距 width 宽度 bottom 底边距
 */
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_AutoHeight:(CGFloat)left top:(CGFloat)top width:(CGFloat)width bottom:(CGFloat)bottom;
/**
 *  设置frame left 左边距 top 顶边距 right 右边距 bottom 底边距 toView 相对视图
 */
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_AutoSize:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom toView:(TFY_VIEW * _Nonnull)toView;
/**
* 设置frame left 左边距 top 顶边距 right 右边距 height 高度 toView 相对视图
*/
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_AutoWidth:(CGFloat)left top:(CGFloat)top right:(CGFloat)right height:(CGFloat)height toView:(TFY_VIEW * _Nonnull)toView;
/**
 *  设置frame (默认相对父视图) left 左边距 top 顶边距 width 宽度 bottom 底边距
 */

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_AutoHeight:(CGFloat)left top:(CGFloat)top width:(CGFloat)width bottom:(CGFloat)bottom toView:(TFY_VIEW * _Nonnull)toView;
/**
 *  设置视图显示宽高 size 视图宽高
 */
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_Size:(CGSize)size;
/**
 *  设置视图size等于view view 相对视图
 */
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_SizeEqualView:(TFY_VIEW * _Nonnull)view;
/**
 *  设置视图frame等于view view 相对视图
 */
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_FrameEqualView:(TFY_VIEW * _Nonnull)view;

@end

NS_ASSUME_NONNULL_END
