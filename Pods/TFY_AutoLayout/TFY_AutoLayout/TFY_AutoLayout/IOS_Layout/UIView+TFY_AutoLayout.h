//
//  UIView+TFY_AutoLayout.h
//  TFY_AutoLayoutModelTools
//
//  Created by 田风有 on 2019/4/30.
//  Copyright © 2019 恋机科技. All rights reserved.
//  https://github.com/13662049573/TFY_AutoLayoutModelTools

#import "TFY_AutoLayoutHerder.h"

NS_ASSUME_NONNULL_BEGIN
/**
 *  布局方向
 */
typedef NS_OPTIONS(NSUInteger, TFY_LayoutOrientationOptions) {
    /// 垂直布局
    Vertical = 1 << 0,
    /// 横向布局
    Horizontal = 1 << 1,
    /// 垂直布局和横向布局
    All = 1 << 2
};

@interface TFY_CLASS_VIEW (TFY_StackViewCategory)
/**
 控件横向和垂直布局宽度或者高度权重比例
 */
@property (nonatomic , assign)CGFloat tfy_WidthWeight;

@property (nonatomic , assign)CGFloat tfy_HeightWeight;

@end

typedef TFY_CLASS_VIEW * _Nonnull (^IsSafe)(BOOL);
typedef TFY_CLASS_VIEW * _Nonnull (^LessOrEqual)(void);
typedef TFY_CLASS_VIEW * _Nonnull (^GreaterOrEqual)(void);
typedef TFY_CLASS_VIEW * _Nonnull (^ResetConstraintAttribute)(void);
typedef TFY_CLASS_VIEW * _Nonnull (^ClearConstraintAttribute)(void);
typedef TFY_CLASS_VIEW * _Nonnull (^RemoveConstraintAttribute)(NSLayoutAttribute attributes, ...);
typedef TFY_CLASS_VIEW * _Nonnull (^RemoveConstraintFromViewAttribute)(TFY_CLASS_VIEW * _Nonnull view,NSLayoutAttribute attributes, ...);
typedef TFY_CLASS_VIEW * _Nonnull (^RemoveConstraintToViewAttribute)(TFY_VIEW * _Nonnull toView,NSLayoutAttribute attributes, ...);

typedef TFY_CLASS_VIEW * _Nonnull (^PriorityLow)(void);
typedef TFY_CLASS_VIEW * _Nonnull (^PriorityHigh)(void);
typedef TFY_CLASS_VIEW * _Nonnull (^PriorityRequired)(void);
typedef TFY_CLASS_VIEW * _Nonnull (^PriorityFitting)(void);
typedef TFY_CLASS_VIEW * _Nonnull (^PriorityValue)(CGFloat value);

typedef TFY_CLASS_VIEW * _Nonnull (^ContentHuggingPriority)(TFY_LayoutPriority,TFY_ConstraintAxis);
typedef TFY_CLASS_VIEW * _Nonnull (^ContentCompressionResistancePriority)(TFY_LayoutPriority,TFY_ConstraintAxis);

typedef TFY_CLASS_VIEW * _Nonnull (^LeftSpace)(CGFloat value);
typedef TFY_CLASS_VIEW * _Nonnull (^LeftSpaceToView)(CGFloat value,TFY_VIEW * _Nonnull toView);
typedef TFY_CLASS_VIEW * _Nonnull (^LeftSpaceEqualView)(TFY_VIEW * _Nonnull view);
typedef TFY_CLASS_VIEW * _Nonnull (^LeftSpaceEqualViewOffset)(TFY_VIEW * _Nonnull view,CGFloat offset);

typedef TFY_CLASS_VIEW * _Nonnull (^LeadingSpace)(CGFloat value);
typedef TFY_CLASS_VIEW * _Nonnull (^LeadingSpaceToView)(CGFloat value,TFY_VIEW * _Nonnull toView);
typedef TFY_CLASS_VIEW * _Nonnull (^LeadingSpaceEqualView)(TFY_VIEW * _Nonnull view);
typedef TFY_CLASS_VIEW * _Nonnull (^LeadingSpaceEqualViewOffset)(TFY_VIEW * _Nonnull view,CGFloat offset);

typedef TFY_CLASS_VIEW * _Nonnull (^TrailingSpace)(CGFloat value);
typedef TFY_CLASS_VIEW * _Nonnull (^TrailingSpaceToView)(CGFloat value,TFY_VIEW * _Nonnull toView);
typedef TFY_CLASS_VIEW * _Nonnull (^TrailingSpaceEqualView)(TFY_VIEW * _Nonnull view);
typedef TFY_CLASS_VIEW * _Nonnull (^TrailingSpaceEqualViewOffset)(TFY_VIEW * _Nonnull view,CGFloat offset);

typedef TFY_CLASS_VIEW * _Nonnull (^BaseLineSpace)(CGFloat value);
typedef TFY_CLASS_VIEW * _Nonnull (^BaseLineSpaceToView)(CGFloat value,TFY_VIEW * _Nonnull toView);
typedef TFY_CLASS_VIEW * _Nonnull (^BaseLineSpaceEqualView)(TFY_VIEW * _Nonnull view);
typedef TFY_CLASS_VIEW * _Nonnull (^BaseLineSpaceEqualViewOffset)(TFY_VIEW * _Nonnull view,CGFloat offset);

typedef TFY_CLASS_VIEW * _Nonnull (^RightSpace)(CGFloat value);
typedef TFY_CLASS_VIEW * _Nonnull (^RightSpaceToView)(CGFloat value,TFY_VIEW * _Nonnull toView);
typedef TFY_CLASS_VIEW * _Nonnull (^RightSpaceEqualView)(TFY_VIEW * _Nonnull view);
typedef TFY_CLASS_VIEW * _Nonnull (^RightSpaceEqualViewOffset)(TFY_VIEW * _Nonnull view,CGFloat offset);

typedef TFY_CLASS_VIEW * _Nonnull (^TopSpace)(CGFloat value);
typedef TFY_CLASS_VIEW * _Nonnull (^TopSpaceToView)(CGFloat value,TFY_VIEW * _Nonnull toView);
typedef TFY_CLASS_VIEW * _Nonnull (^TopSpaceEqualView)(TFY_VIEW * _Nonnull view);
typedef TFY_CLASS_VIEW * _Nonnull (^TopSpaceEqualViewOffset)(TFY_VIEW * _Nonnull view,CGFloat offset);

typedef TFY_CLASS_VIEW * _Nonnull (^BottomSpace)(CGFloat value);
typedef TFY_CLASS_VIEW * _Nonnull (^BottomSpaceToView)(CGFloat value,TFY_VIEW * _Nonnull toView);
typedef TFY_CLASS_VIEW * _Nonnull (^BottomSpaceEqualView)(TFY_VIEW * _Nonnull view);
typedef TFY_CLASS_VIEW * _Nonnull (^BottomSpaceEqualViewOffset)(TFY_VIEW * _Nonnull view,CGFloat offset);

typedef TFY_CLASS_VIEW * _Nonnull (^Width)(CGFloat value);
typedef TFY_CLASS_VIEW * _Nonnull (^WidthAuto)(void);
typedef TFY_CLASS_VIEW * _Nonnull (^WidthEqualView)(TFY_VIEW * _Nonnull view);
typedef TFY_CLASS_VIEW * _Nonnull (^WidthEqualViewRatio)(TFY_VIEW * _Nonnull view,CGFloat ratio);
typedef TFY_CLASS_VIEW * _Nonnull (^WidthHeightRatio)(CGFloat ratio);

typedef TFY_CLASS_VIEW * _Nonnull (^Height)(CGFloat value);
typedef TFY_CLASS_VIEW * _Nonnull (^HeightAuto)(void);
typedef TFY_CLASS_VIEW * _Nonnull (^HeightEqualView)(TFY_VIEW * _Nonnull view);
typedef TFY_CLASS_VIEW * _Nonnull (^HeightEqualViewRatio)(TFY_VIEW * _Nonnull view,CGFloat ratio);
typedef TFY_CLASS_VIEW * _Nonnull (^HeightWidthRatio)(CGFloat ratio);

typedef TFY_CLASS_VIEW * _Nonnull (^CenterX)(CGFloat value);
typedef TFY_CLASS_VIEW * _Nonnull (^CenterXToView)(CGFloat value,TFY_VIEW * _Nonnull toView);

typedef TFY_CLASS_VIEW * _Nonnull (^CenterY)(CGFloat value);
typedef TFY_CLASS_VIEW * _Nonnull (^CenterYToView)(CGFloat value,TFY_VIEW * _Nonnull toView);

typedef TFY_CLASS_VIEW * _Nonnull (^Center)(CGFloat x,CGFloat y);
typedef TFY_CLASS_VIEW * _Nonnull (^CenterToView)(CGPoint center,TFY_VIEW * _Nonnull toView);

typedef TFY_CLASS_VIEW * _Nonnull (^size)(CGFloat width,CGFloat height);
typedef TFY_CLASS_VIEW * _Nonnull (^SizeEqual)(TFY_VIEW * _Nonnull view);

typedef TFY_CLASS_VIEW * _Nonnull (^FrameEqual)(TFY_VIEW * _Nonnull view);

@interface TFY_CLASS_VIEW (TFY_AutoLayout)
/**
 *  是否安全布局
 */
@property (nonatomic , copy , readonly)IsSafe _Nonnull tfy_IsSafe;
/**
 *  当前约束小于等于
 */
@property (nonatomic , copy , readonly)LessOrEqual _Nonnull tfy_LeseOrEqual;
/**
 *  当前约束大于等于
 */
@property (nonatomic , copy , readonly)GreaterOrEqual _Nonnull tfy_GreaterOrEqual;
/**
 *  重置缓存约束
 */
@property (nonatomic , copy , readonly)ResetConstraintAttribute _Nonnull tfy_ResetConstraint;
/**
 *  清除所有约束
 */
@property (nonatomic , copy , readonly)ClearConstraintAttribute _Nonnull tfy_ClearLayoutAttr;
/**
 *   移除约束(NSLayoutAttribute attributes, ...)
 */
@property (nonatomic , copy , readonly)RemoveConstraintAttribute _Nonnull tfy_RemoveLayoutAttrs;
/**
 *  移除约束从指定视图上(TFY_VIEW * view, NSLayoutAttribute attributes, ...)
 */
@property (nonatomic , copy , readonly)RemoveConstraintFromViewAttribute _Nonnull tfy_RemoveFromLayoutAttrs;
/**
 *  移除约束从关联视图上(TFY_VIEW * toView, NSLayoutAttribute attributes, ...)
 */
@property (nonatomic , copy , readonly)RemoveConstraintToViewAttribute _Nonnull tfy_RemoveToLayoutAttrs;

#pragma --------- 第一个分割点 --------
/**
 *   设置当前约束的低优先级
 */
@property (nonatomic , copy , readonly)PriorityLow _Nonnull tfy_PriorityLow;
/**
 *   设置当前约束的高优先级
 */
@property (nonatomic , copy , readonly)PriorityHigh _Nonnull tfy_PriorityHigh;
/**
 *   设置当前约束的默认优先级
 */
@property (nonatomic , copy , readonly)PriorityRequired _Nonnull tfy_PriorityRequired;
/**
 *   设置当前约束的合适优先级
 */
@property (nonatomic , copy , readonly)PriorityFitting _Nonnull tfy_PriorityFitting;
/**
 *   设置当前约束的优先级 (CGFloat value): 优先级大小(0-1000)
 */
@property (nonatomic , copy , readonly)PriorityValue _Nonnull tfy_Priority;

#pragma --------- 第二个分割点 --------
/**
 *  设置视图抗拉伸优先级,优先级越高越不容易被拉伸(UILayoutPriority, UILayoutConstraintAxis)
 */
@property (nonatomic , copy , readonly)ContentHuggingPriority _Nonnull tfy_ContentHuggingPriority;
/**
 *  设置视图抗压缩优先级,优先级越高越不容易被压缩(UILayoutPriority, UILayoutConstraintAxis)
 */
@property (nonatomic , copy , readonly)ContentCompressionResistancePriority _Nonnull tfy_ContentCompressionResistancePriority;

#pragma --------- 第三个分割点 --------
/**
 *  与父视图左边间距(CGFloat value)
 */
@property (nonatomic , copy , readonly)LeftSpace _Nonnull tfy_LeftSpace;
/**
 *  与相对视图toView左边间距(CGFloat value,TFY_VIEW * toView)
 */
@property (nonatomic , copy , readonly)LeftSpaceToView _Nonnull tfy_LeftSpaceToView;
/**
 *  与视图view左边间距相等(TFY_VIEW * view)
 */
@property (nonatomic , copy , readonly)LeftSpaceEqualView _Nonnull tfy_LeftSpaceEqualView;
/**
 *  与视图view左边间距相等并偏移offset(TFY_VIEW * view, CGFloat offset)
 */
@property (nonatomic , copy , readonly)LeftSpaceEqualViewOffset _Nonnull tfy_LeftSpaceEqualViewOffset;

#pragma --------- 第四个分割点 --------
/**
 *  与父视图左边间距(CGFloat value)
 */
@property (nonatomic , copy , readonly)LeadingSpace _Nonnull tfy_LeadingSpace;
/**
 *  与相对视图toView左边间距(CGFloat value,TFY_VIEW * toView)
 */
@property (nonatomic , copy , readonly)LeadingSpaceToView _Nonnull tfy_LeadingSpaceToView;
/**
 *  与视图view左边间距相等(TFY_VIEW * view)
 */
@property (nonatomic , copy , readonly)LeadingSpaceEqualView _Nonnull tfy_LeadingSpaceEqualView;
/**
 *  与视图view左边间距相等并偏移offset (TFY_VIEW * view, CGFloat offset)
 */
@property (nonatomic , copy , readonly)LeadingSpaceEqualViewOffset _Nonnull tfy_LeadingSpaceEqualViewOffset;


#pragma --------- 第五个分割点 --------
/**
 *  与父视图右边间距(CGFloat value)
 */
@property (nonatomic , copy , readonly)TrailingSpace _Nonnull tfy_TrailingSpace;
/**
 *  与相对视图toView右边间距(CGFloat value,TFY_VIEW * toView)
 */
@property (nonatomic , copy , readonly)TrailingSpaceToView _Nonnull tfy_TrailingSpaceToView;
/**
 *  与视图view右边间距相等(TFY_VIEW * view)
 */
@property (nonatomic , copy , readonly)TrailingSpaceEqualView _Nonnull tfy_TrailingSpaceEqualView;
/**
 *  与视图view右边间距相等并偏移offset(TFY_VIEW * view, CGFloat offset)
 */
@property (nonatomic , copy , readonly)TrailingSpaceEqualViewOffset _Nonnull tfy_TrailingSpaceEqualViewOffset;

#pragma --------- 第六个分割点 --------
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
/**
 *  与父视图底边间距Y(CGFloat value)
 */
@property (nonatomic , copy , readonly)BaseLineSpace _Nonnull tfy_FirstBaseLine;
/**
 *  与相对视图toView底边间距Y(CGFloat value,TFY_VIEW * toView)
 */
@property (nonatomic , copy , readonly)BaseLineSpaceToView _Nonnull tfy_FirstBaseLineToView;
/**
 *  与视图view底边间距Y相等(TFY_VIEW * view)
 */
@property (nonatomic , copy , readonly)BaseLineSpaceEqualView _Nonnull tfy_FirstBaseLineEqualView;
/**
 *  与视图view底边间距Y相等并偏移offset(TFY_VIEW * view, CGFloat offset)
 */
@property (nonatomic , copy , readonly)BaseLineSpaceEqualViewOffset _Nonnull tfy_FirstBaseLineEqualViewOffset;
#endif
/**
 *   与父视图底边间距Y(CGFloat value)
 */
@property (nonatomic , copy , readonly)BaseLineSpace _Nonnull tfy_LastBaseLine;
/**
 *  与相对视图toView底边间距Y(CGFloat value,TFY_VIEW * toView)
 */
@property (nonatomic , copy , readonly)BaseLineSpaceToView _Nonnull tfy_LastBaseLineToView;
/**
 *  与视图view底边间距Y相等(TFY_VIEW * view)
 */
@property (nonatomic , copy , readonly)BaseLineSpaceEqualView _Nonnull tfy_LastBaseLineEqualView;
/**
 *  与视图view底边间距Y相等并偏移offset(TFY_VIEW * view, CGFloat offset)
 */
@property (nonatomic , copy , readonly)BaseLineSpaceEqualViewOffset _Nonnull tfy_LastBaseLineEqualViewOffset;
/**
 *  与父视图右边间距(CGFloat value)
 */
@property (nonatomic , copy , readonly)RightSpace _Nonnull tfy_RightSpace;
/**
 *  与相对视图toView右边间距(CGFloat value,TFY_VIEW * toView)
 */
@property (nonatomic , copy , readonly)RightSpaceToView _Nonnull tfy_RightSpaceToView;
/**
 *  与相对视图toView右边间距相等(TFY_VIEW toView)
 */
@property (nonatomic , copy , readonly)RightSpaceEqualView _Nonnull tfy_RightSpaceEqualView;
/**
 *   与相对视图toView右边间距相等并偏移offset(TFY_VIEW toView, CGFloat offset)
 */
@property (nonatomic , copy , readonly)RightSpaceEqualViewOffset _Nonnull tfy_RightSpaceEqualViewOffset;

#pragma --------- 第七个分割点 --------
/**
 *  与父视图顶边间距(CGFloat value)
 */
@property (nonatomic , copy , readonly)TopSpace _Nonnull tfy_TopSpace;
/**
 *  与相对视图toView顶边间距(CGFloat value,TFY_VIEW * toView)
 */
@property (nonatomic , copy , readonly)TopSpaceToView _Nonnull tfy_TopSpaceToView;
/**
 *  与视图view顶边间距相等(TFY_VIEW * view)
 */
@property (nonatomic , copy , readonly)TopSpaceEqualView _Nonnull tfy_TopSpaceEqualView;
/**
 *   与视图view顶边间距相等并偏移offset(TFY_VIEW * view, CGFloat offset)
 */
@property (nonatomic , copy , readonly)TopSpaceEqualViewOffset _Nonnull tfy_TopSpaceEqualViewOffset;

#pragma --------- 第八个分割点 --------
/**
 *  与父视图底边间距(CGFloat value)
 */
@property (nonatomic , copy , readonly)BottomSpace _Nonnull tfy_BottomSpace;
/**
 *  与相对视图toView底边间距(CGFloat value,TFY_VIEW * toView)
 */
@property (nonatomic , copy , readonly)BottomSpaceToView _Nonnull tfy_BottomSpaceToView;
/**
 *  与相对视图toView底边间距相等(TFY_VIEW * toView)
 */
@property (nonatomic , copy , readonly)BottomSpaceEqualView _Nonnull tfy_BottomSpaceEqualView;
/**
 *  与相对视图toView底边间距相等并偏移offset(TFY_VIEW * toView, CGFloat offset)
 */
@property (nonatomic , copy , readonly)BottomSpaceEqualViewOffset _Nonnull tfy_BottomSpaceEqualViewOffset;

#pragma --------- 第九个分割点 --------
/**
 *  宽度(CGFloat value)
 */
@property (nonatomic , copy , readonly)Width _Nonnull tfy_Width;
/**
 *  宽度自动()
 */
@property (nonatomic , copy , readonly)WidthAuto _Nonnull tfy_WidthAuto;
/**
 *  宽度等于视图view(TFY_VIEW * view)
 */
@property (nonatomic , copy , readonly)WidthEqualView _Nonnull tfy_WidthEqualView;
/**
 *  宽度等于视图view 参照比例Ratio(TFY_VIEW * view ,CGFloat ratio)
 */
@property (nonatomic , copy , readonly)WidthEqualViewRatio _Nonnull tfy_WidthEqualViewRatio;
/**
 *  视图自身宽度与高度的比(CGFloat Ratio)
 */
@property (nonatomic , copy , readonly)WidthHeightRatio _Nonnull tfy_WidthHeightRatio;

#pragma --------- 第十个分割点 --------
/**
 *  高度(CGFloat value)
 */
@property (nonatomic , copy , readonly)Height _Nonnull tfy_Height;
/**
 *  高度自动()
 */
@property (nonatomic , copy , readonly)HeightAuto _Nonnull tfy_HeightAuto;
/**
 *  高度等于视图view(TFY_VIEW * view)
 */
@property (nonatomic , copy , readonly)HeightEqualView _Nonnull tfy_HeightEqualView;
/**
 *  视图自身高度与宽度的比(CGFloat Ratio)
 */
@property (nonatomic , copy , readonly)HeightWidthRatio _Nonnull tfy_HeightWidthRatio;
/**
 *  高度等于视图view 参照比例Ratio(TFY_VIEW * view ,CGFloat ratio)
 */
@property (nonatomic , copy , readonly)HeightEqualViewRatio _Nonnull tfy_HeightEqualViewRatio;

#pragma --------- 第十一个分割点 --------
/**
 *  中心X与父视图偏移(CGFloat value)
 */
@property (nonatomic , copy , readonly)CenterX _Nonnull tfy_CenterX;
/**
 *  中心X与视图view偏移(CGFloat value , TFY_VIEW * toView)
 */
@property (nonatomic , copy , readonly)CenterXToView _Nonnull tfy_CenterXToView;


#pragma --------- 第十二个分割点 --------
/**
 *  中心Y与父视图偏移(CGFloat value)
 */
@property (nonatomic , copy , readonly)CenterY _Nonnull tfy_CenterY;
/**
 *  中心Y与视图view偏移(CGFloat value , TFY_VIEW * toView)
 */
@property (nonatomic , copy , readonly)CenterYToView _Nonnull tfy_CenterYToView;

#pragma --------- 第十三个分割点 --------
/**
 *  中心与父视图偏移(CGFloat value)
 */
@property (nonatomic , copy , readonly)Center _Nonnull tfy_Center;
/**
 *  中心与视图view偏移(CGFloat value , TFY_VIEW * toView)
 */
@property (nonatomic , copy , readonly)CenterToView _Nonnull tfy_CenterToView;
/**
 *  size设置(CGFloat width, CGFloat height)
 */
@property (nonatomic , copy , readonly)size _Nonnull tfy_size;
/**
 *  size设置(TFY_VIEW * view)
 */
@property (nonatomic , copy , readonly)SizeEqual _Nonnull tfy_SizeEqualView;
/**
 *  frame设置(TFY_VIEW * view)
 */
@property (nonatomic , copy , readonly)FrameEqual _Nonnull tfy_FrameEqualView;


#pragma **************************** 方法展示 ****************************
/**
 *  是否进行安全布局
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_IsSafe:(BOOL)safe;
/**
 *  重置缓存的约束,该方法在当前视图对象移除从父视图上可能需要调用清除与父视图之前旧约束缓存对象
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_ResetConstraints;
/**
 *  清除所有布局属性
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_ClearLayoutAttrs;
/**
 * 移除一个或者一组约束 attributes 约束类型（可变参数）
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_RemoveLayoutAttr:(NSLayoutAttribute)attributes, ...;
/**
 *  移除一个单个属性  attribute 约束类型
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_RemoveLayoutOneAttr:(NSLayoutAttribute)attribute;
/**
 *  移除一个或者一组约束从指定的视图上  view 指定视图  attributes 约束类型（可变参数）
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_RemoveFrom:(TFY_CLASS_VIEW * _Nonnull)view layoutAttrs:(NSLayoutAttribute)attributes, ...;
/**
 *  移除一个约束从指定的视图上  view 指定视图  attribute 约束类型
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_RemoveFrom:(TFY_CLASS_VIEW * _Nonnull)view layoutAttr:(NSLayoutAttribute)attribute;
/**
 *  移除一个约束从关联的视图  view 关联的视图  attribute 移除的约束
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_RemoveTo:(TFY_VIEW * _Nonnull)view attr:(NSLayoutAttribute)attributes;
/**
 *  移除多个约束从关联的视图  view 关联的视图  attributes 移除的约束
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_RemoveTo:(TFY_VIEW * _Nonnull)view layoutAttrs:(NSLayoutAttribute)attributes, ...;
/**
 *  设置当前约束的低优先级
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_priorityLow;
/**
 *  设置当前约束的高优先级
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_priorityHigh;
/**
 *  设置当前约束的默认优先级
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_priorityRequired;
/**
 *  设置当前约束的合适优先级
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_priorityFitting;
/**
 *  设置当前约束的优先级  value 优先级大小(0-1000)
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_priority:(CGFloat)value;
/**
 *  设置左边距(默认相对父视图)  leftSpace 左边距
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_LeftSpace:(CGFloat)leftSpace;
/**
 *  设置左边距  leftSpace 左边距  toView 相对视图
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_LeftSpace:(CGFloat)leftSpace toView:(TFY_VIEW * _Nonnull)toView;
/**
 * 设置左边距与视图view左边距相等  view 相对视图
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_LeftSpaceEqualView:(TFY_VIEW * _Nonnull)view;
/**
 *  设置左边距与视图view左边距相等并偏移offset  view 相对视图  offset 偏移量
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_LeftSpaceEqualView:(TFY_VIEW * _Nonnull)view offset:(CGFloat)offset;
/**
 *  设置右边距(默认相对父视图)  rightSpace 右边距
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_RightSpace:(CGFloat)rightSpace;
/**
 *  设置右边距  rightSpace 右边距  toView 相对视图
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_RightSpace:(CGFloat)rightSpace toView:(TFY_VIEW * _Nonnull)toView;
/**
 *  设置右边距与视图view左对齐边距相等 view 相对视图
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_RightSpaceEqualView:(TFY_VIEW * _Nonnull)view;
/**
 *  设置右边距与视图view左对齐边距相等并偏移offset view 相对视图  offset 偏移量
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_RightSpaceEqualView:(TFY_VIEW * _Nonnull)view offset:(CGFloat)offset;
/**
 *  设置左对齐(默认相对父视图)  leadingSpace 左边距
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_LeadingSpace:(CGFloat)leadingSpace;
/**
 * 设置左对齐  leadingSpace 左边距  toView 相对视图
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_LeadingSpace:(CGFloat)leadingSpace toView:(TFY_VIEW * _Nonnull)toView;
/**
 *  设置左对齐边距与某视图左对齐边距相等  view 相对视图
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_LeadingSpaceEqualView:(TFY_VIEW * _Nonnull)view;
/**
 * 设置左对齐边距与某视图左对齐边距相等并偏移offset view 相对视图  offset 偏移量
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_LeadingSpaceEqualView:(TFY_VIEW * _Nonnull)view offset:(CGFloat)offset;
/**
 *  设置右对齐(默认相对父视图) trailingSpace 右边距
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_TrailingSpace:(CGFloat)trailingSpace;
/**
 *  设置右对齐  trailingSpace 右边距  toView 相对视图
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_TrailingSpace:(CGFloat)trailingSpace toView:(TFY_VIEW * _Nonnull)toView;
/**
 *  设置右对齐边距与某视图右对齐边距相等  view 相对视图
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_TrailingSpaceEqualView:(TFY_VIEW * _Nonnull)view;
/**
 *  设置右对齐边距与某视图右对齐边距相等并偏移offset  view 相对视图  offset 偏移量
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_TrailingSpaceEqualView:(TFY_VIEW * _Nonnull)view offset:(CGFloat)offset;
/**
 *  设置顶边距(默认相对父视图) topSpace 顶边距
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_TopSpace:(CGFloat)topSpace;
/**
 *  设置顶边距 topSpace 顶边距  toView 相对视图
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_TopSpace:(CGFloat)topSpace toView:(TFY_VIEW * _Nonnull)toView;
/**
 *  设置顶边距与视图view顶边距相等  view 相对视图
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_TopSpaceEqualView:(TFY_VIEW * _Nonnull)view;
/**
 * 设置顶边距与视图view顶边距相等并偏移offset  view 相对视图  offset 偏移量
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_TopSpaceEqualView:(TFY_VIEW * _Nonnull)view offset:(CGFloat)offset;
/**
 * 设置底边距(默认相对父视图) bottomSpace 底边距
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_BottomSpace:(CGFloat)bottomSpace;
/**
 * 设置底边距 bottomSpace 底边距  toView 相对视图
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_BottomSpace:(CGFloat)bottomSpace toView:(TFY_VIEW * _Nonnull)toView;
/**
 *  设置底边距与视图view底边距相等 view 相对视图
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_BottomSpaceEqualView:(TFY_VIEW * _Nonnull)view;
/**
 * 设置底边距与视图view底边距相等并偏移offset  view 相对视图  offset 偏移量
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_BottomSpaceEqualView:(TFY_VIEW * _Nonnull)view offset:(CGFloat)offset;
/**
 *  设置宽度  width 宽度
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_Width:(CGFloat)width;
/**
 *  设置宽度与某个视图相等 view 相对视图
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_WidthEqualView:(TFY_VIEW * _Nonnull)view;
/**
 *  设置宽度与视图view相等 view 相对视图  ratio 比例
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_WidthEqualView:(TFY_VIEW * _Nonnull)view ratio:(CGFloat)ratio;
/**
 * 设置自动宽度
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_AutoWidth;
/**
 * 设置视图自身宽度与高度的比 ratio 比例
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_WidthHeightRatio:(CGFloat)ratio;
/**
 * 设置高度  height 高度
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_Height:(CGFloat)height;
/**
 * 设置高度与视图view相等  view 相对视图
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_HeightEqualView:(TFY_VIEW * _Nonnull)view;
/**
 * 设置高度与视图view相等 view 相对视图  ratio 比例
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_HeightEqualView:(TFY_VIEW * _Nonnull)view ratio:(CGFloat)ratio;
/**
 * 设置自动高度
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_AutoHeight;
/**
 *  设置视图自身高度与宽度的比 ratio 比例
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_HeightWidthRatio:(CGFloat)ratio;
/**
 * 设置中心x与父视图中心的偏移 centerX = 0 与父视图中心x重合 centerX 中心x坐标偏移
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_CenterX:(CGFloat)centerX;
/**
 * 设置中心x与相对视图中心的偏移 centerX = 0 与相对视图中心x重合 centerX 中心x坐标偏移 toView 相对视图
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_CenterX:(CGFloat)centerX toView:(TFY_VIEW * _Nonnull)toView;
/**
 * 设置中心y与父视图中心的偏移 centerY = 0 与父视图中心y重合 centerY 中心y坐标偏移
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_CenterY:(CGFloat)centerY;
/**
 * 设置中心y与相对视图中心的偏移 centerY = 0 与相对视图中心y重合 centerY 中心y坐标偏移 toView 相对视图
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_CenterY:(CGFloat)centerY toView:(TFY_VIEW * _Nonnull)toView;

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
/**
 *  设置顶部基线偏移(默认相对父视图) space 间隙
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_FirstBaseLine:(CGFloat)space;
/**
 *  设置顶部基线与对象视图底部基线偏移 space 间隙 toView 相对视图
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_FirstBaseLine:(CGFloat)space toView:(TFY_VIEW * _Nonnull)toView;
/**
 *  设置顶部基线与相对视图顶部基线相等 view 相对视图
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_FirstBaseLineEqualView:(TFY_VIEW * _Nonnull)view;
/**
 * 设置顶部基线与相对视图顶部基线相等并偏移offset view 相对视图  offset 偏移量
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_FirstBaseLineEqualView:(TFY_VIEW * _Nonnull)view offset:(CGFloat)offset;

#endif
/**
 *  设置底部基线偏移(默认相对父视图) space 间隙
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_LastBaseLine:(CGFloat)space;
/**
 * 设置底部基线与对象视图顶部基线偏移 space 间隙 toView 相对视图
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_LastBaseLine:(CGFloat)space toView:(TFY_VIEW * _Nonnull)toView;
/**
 * 设置底部基线与相对视图底部基线相等 view 相对视图
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_LastBaseLineEqualView:(TFY_VIEW * _Nonnull)view;
/**
 * 设置底部基线与相对视图底部基线相等并偏移offset view 相对视图 offset 偏移量
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_LastBaseLineEqualView:(TFY_VIEW * _Nonnull)view offset:(CGFloat)offset;
/**
 *  设置中心偏移(默认相对父视图)center = CGPointZero 与父视图中心重合 center 中心偏移xy
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_Center:(CGPoint)center;
/**
 * 设置中心偏移(默认相对父视图)center = CGPointZero 与父视图中心重合 center 中心偏移xy toView 相对视图
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_Center:(CGPoint)center toView:(TFY_VIEW * _Nonnull)toView;
/**
 *  设置frame(默认相对父视图) left 左边距 top 顶边距 width 宽度 height 高度
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_Frame:(CGFloat)left top:(CGFloat)top width:(CGFloat)width height:(CGFloat)height;
/**
 * 设置frame (默认相对父视图) left 左边距 top 顶边距 right 右边距 bottom 底边距
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_AutoSize:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom;
/**
 * 设置frame left 左边距 top 顶边距 width 宽度 height 高度 toView 相对视图
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_Frame:(CGFloat)left top:(CGFloat)top width:(CGFloat)width height:(CGFloat)height toView:(TFY_VIEW * _Nonnull)toView;
/**
 * 设置frame (默认相对父视图) left 左边距 top 顶边距 right 右边距 height 高度
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_AutoWidth:(CGFloat)left top:(CGFloat)top right:(CGFloat)right height:(CGFloat)height;
/**
 * 设置frame (默认相对父视图) left 左边距 top 顶边距 width 宽度 bottom 底边距
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_AutoHeight:(CGFloat)left top:(CGFloat)top width:(CGFloat)width bottom:(CGFloat)bottom;
/**
 * 设置frame left 左边距 top 顶边距 right 右边距 bottom 底边距 toView 相对视图
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_AutoSize:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom toView:(TFY_VIEW * _Nonnull)toView;
/**
 * 设置frame left 左边距 top 顶边距 right 右边距 height 高度 toView 相对视图
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_AutoWidth:(CGFloat)left top:(CGFloat)top right:(CGFloat)right height:(CGFloat)height toView:(TFY_VIEW * _Nonnull)toView;
/**
 * 设置frame (默认相对父视图) left 左边距 top 顶边距 width 宽度 bottom 底边距
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_AutoHeight:(CGFloat)left top:(CGFloat)top width:(CGFloat)width bottom:(CGFloat)bottom toView:(TFY_VIEW * _Nonnull)toView;
/**
 * 设置视图显示宽高 size 视图宽高
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_Size:(CGSize)size;
/**
 * 设置视图size等于view view 相对视图
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_SizeEqualView:(TFY_VIEW * _Nonnull)view;
/**
 * 设置视图frame等于view view 相对视图
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_FrameEqualView:(TFY_VIEW * _Nonnull)view;

#if TARGET_OS_IPHONE || TARGET_OS_TV
/**
 *  对视图底部加线 value 线宽 color 线的颜色
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_AddBottomLine:(CGFloat)value lineColor:(UIColor *)color;
/**
 *  对视图底部加线 value 线宽 color 线的颜色 pading 内边距
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_AddBottomLine:(CGFloat)value lineColor:(UIColor *)color pading:(CGFloat)pading;
/**
 * 对视图顶部加线 value 线宽 color 线的颜色
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_AddTopLine:(CGFloat)value lineColor:(UIColor *)color;
/**
 *  对视图顶部加线 value 线宽 color 线的颜色 pading 内边距
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_AddTopLine:(CGFloat)value lineColor:(UIColor *)color pading:(CGFloat)pading;
/**
 * 对视图左边加线 value 线宽 color 线的颜色
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_AddLeftLine:(CGFloat)value lineColor:(UIColor *)color;
/**
 * 对视图左边加线 value   线宽 color   线的颜色 padding 边距
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_AddLeftLine:(CGFloat)value lineColor:(UIColor *)color padding:(CGFloat)padding;
/**
 * 对视图右边加线 value 线宽 color 线的颜色
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_AddRightLine:(CGFloat)value lineColor:(UIColor *)color;
/**
 * 对视图右边加线 value 线宽 color 线的颜色 padding 边距
 */
-(TFY_CLASS_VIEW * _Nonnull)tfy_AddRightLine:(CGFloat)value lineColor:(UIColor *)color padding:(CGFloat)padding;

#endif

@end

@interface TFY_StackView : TFY_CLASS_VIEW

/// 混合布局(同时垂直和横向)每行多少列
@property (nonatomic , assign) NSInteger tfy_Column;
/// 容器内边距
#if TARGET_OS_IPHONE || TARGET_OS_TV
@property (nonatomic , assign) UIEdgeInsets tfy_Edge;
#elif TARGET_OS_MAC
@property (nonatomic , assign) NSEdgeInsets tfy_Edge;
#endif
/// 容器内子控件横向间隙
@property (nonatomic , assign) CGFloat tfy_HSpace;
/// 容器内子控件垂直间隙
@property (nonatomic , assign) CGFloat tfy_VSpace;

/// 子元素高宽比
@property (nonatomic , assign) CGFloat tfy_ElementHeightWidthRatio;

/// 子元素宽高比
@property (nonatomic , assign) CGFloat tfy_ElementWidthHeightRatio;

/// 容器里子元素实际数量
@property (nonatomic , assign , readonly) NSInteger tfy_SubViewCount;

/// 容器自动布局方向
@property (nonatomic , assign) TFY_LayoutOrientationOptions tfy_Orientation;

/// 子视图固定宽度
@property (nonatomic , assign) CGFloat tfy_SubViewWidth;

/// 子视图固定高度
@property (nonatomic , assign) CGFloat tfy_SubViewHeight;

/// 设置分割线尺寸
@property (nonatomic , assign) CGFloat tfy_SegmentLineSize;
/// 设置分割线内边距
@property (nonatomic , assign) CGFloat tfy_SegmentLinePadding;
/// 设置分割线的颜色
@property (nonatomic , strong) TFY_COLOR * tfy_SegmentLineColor;
/************重载父类属性**************/
/// 自动高度
@property (nonatomic ,copy , readonly)HeightAuto tfy_HeightAuto;

/// 自动宽度
@property (nonatomic ,copy , readonly)WidthAuto tfy_WidthAuto;

/// 元素集合
@property (nonatomic, strong, readonly)NSArray<TFY_CLASS_VIEW *> * tfy_Subviews;

/************重载父类方法**************/
/**
 自动宽度
 */

- (void)tfy_AutoWidth;

/**
 自动高度
 */

- (void)tfy_AutoHeight;

/**
 开始进行自动布局
 */
- (void)tfy_StartLayout;

/**
 清除所有子视图
 */
- (void)tfy_RemoveAllSubviews;

/**
 移除所有空白站位视图(仅仅横向垂直混合布局有效)
 */
- (void)tfy_RemoveAllVacntView;
@end



NS_ASSUME_NONNULL_END
