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

@interface TFY_CLASS_VIEW (TFY_Frame)
/**
 *  获取屏幕宽度
 */
@property(nonatomic, assign, readonly)CGFloat tfy_swidth;
/**
 *  获取屏幕高度
 */
@property(nonatomic, assign, readonly)CGFloat tfy_sheight;
/**
 *  获取视图层宽度
 */
@property(nonatomic, assign)CGFloat tfy_width;
/**
 *  获取视图层高度
 */
@property(nonatomic, assign)CGFloat tfy_height;
/**
 *  获取视图层x
 */
@property(nonatomic, assign)CGFloat tfy_x;
/**
 *  获取视图层y
 */
@property(nonatomic, assign)CGFloat tfy_y;
/**
 *  获取视图层最大x
 */
@property(nonatomic, assign)CGFloat tfy_maxX;
/**
 *  获取视图层最大y
 */
@property(nonatomic, assign)CGFloat tfy_maxY;
/**
 *  获取视图层中间x
 */
@property(nonatomic, assign)CGFloat tfy_midX;
/**
 *  获取视图层中间y
 */
@property(nonatomic, assign)CGFloat tfy_midY;
/**
 *  离左边距离
 */
@property (nonatomic, assign) CGFloat tfy_left;
/**
 *  离最上面距离
 */
@property (nonatomic, assign) CGFloat tfy_top;
/**
 *  离右边距离
 */
@property (nonatomic, assign) CGFloat tfy_right;
/**
 *  离最底部距离
 */
@property (nonatomic, assign) CGFloat tfy_bottom;
#if TARGET_OS_IPHONE || TARGET_OS_TV
/**
 *  获取视图层中心锚点x
 */
@property(nonatomic, assign)CGFloat tfy_cx;
/**
 *  获取视图层中心锚点y
 */
@property(nonatomic, assign)CGFloat tfy_cy;
#endif
/**
 *  获取视图层xy
 */
@property(nonatomic, assign)CGPoint tfy_xy;
/**
 *  获取视图层size
 */
@property(nonatomic, assign)CGSize tfy_se;

@end

@interface TFY_CLASS_VIEW (TFY_AutoLayout)
/**
 *  是否安全布局
 */
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_IsSafe)(BOOL IsSafe);
/**
 *  当前约束小于等于
 */
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_LeseOrEqual)(void);
/**
 *  当前约束大于等于
 */
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_GreaterOrEqual)(void);
/**
 *  重置缓存约束
 */
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_ResetConstraint)(void);
/**
 *  清除所有约束
 */
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_ClearLayoutAttr)(void);
/**
*   移除约束(NSLayoutAttribute attributes, ...)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_RemoveLayoutAttrs)(NSLayoutAttribute attributes, ...);
/**
*  移除约束从指定视图上(TFY_VIEW * view, NSLayoutAttribute attributes, ...)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_RemoveFromLayoutAttrs)(TFY_CLASS_VIEW * _Nonnull view,NSLayoutAttribute attributes, ...);

/**
*  移除约束从关联视图上(TFY_VIEW * toView, NSLayoutAttribute attributes, ...)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_RemoveToLayoutAttrs)(TFY_VIEW * _Nonnull toView,NSLayoutAttribute attributes, ...);

#pragma --------- 第一个分割点 --------
/**
*   设置当前约束的低优先级
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_PriorityLow)(void);
/**
*   设置当前约束的高优先级
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_PriorityHigh)(void);
/**
*   设置当前约束的默认优先级
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_PriorityRequired)(void);
/**
*   设置当前约束的合适优先级
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_PriorityFitting)(void);
/**
*   设置当前约束的优先级 (CGFloat value): 优先级大小(0-1000)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_Priority)(CGFloat value);


#pragma --------- 第二个分割点 --------
/**
*  设置视图抗拉伸优先级,优先级越高越不容易被拉伸(UILayoutPriority, UILayoutConstraintAxis)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_ContentHuggingPriority)(TFY_LayoutPriority,TFY_ConstraintAxis);
/**
*  设置视图抗压缩优先级,优先级越高越不容易被压缩(UILayoutPriority, UILayoutConstraintAxis)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_ContentCompressionResistancePriority)(TFY_LayoutPriority,TFY_ConstraintAxis);

#pragma --------- 第三个分割点 --------
/**
*  与父视图左边间距(CGFloat value)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_LeftSpace)(CGFloat value);
/**
*  与相对视图toView左边间距(CGFloat value,TFY_VIEW * toView)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_LeftSpaceToView)(CGFloat value,TFY_VIEW * _Nonnull toView);
/**
*  与视图view左边间距相等(TFY_VIEW * view)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_LeftSpaceEqualView)(TFY_VIEW * _Nonnull view);
/**
*  与视图view左边间距相等并偏移offset(TFY_VIEW * view, CGFloat offset)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_LeftSpaceEqualViewOffset)(TFY_VIEW * _Nonnull view,CGFloat offset);


#pragma --------- 第四个分割点 --------
/**
*  与父视图左边间距(CGFloat value)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_LeadingSpace)(CGFloat value);
/**
*  与相对视图toView左边间距(CGFloat value,TFY_VIEW * toView)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_LeadingSpaceToView)(CGFloat value,TFY_VIEW * _Nonnull toView);
/**
*  与视图view左边间距相等(TFY_VIEW * view)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_LeadingSpaceEqualView)(TFY_VIEW * _Nonnull view);
/**
*  与视图view左边间距相等并偏移offset (TFY_VIEW * view, CGFloat offset)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_LeadingSpaceEqualViewOffset)(TFY_VIEW * _Nonnull view,CGFloat offset);

#pragma --------- 第五个分割点 --------
/**
*  与父视图右边间距(CGFloat value)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_TrailingSpace)(CGFloat value);
/**
*  与相对视图toView右边间距(CGFloat value,TFY_VIEW * toView)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_TrailingSpaceToView)(CGFloat value,TFY_VIEW * _Nonnull toView);
/**
*  与视图view右边间距相等(TFY_VIEW * view)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_TrailingSpaceEqualView)(TFY_VIEW * _Nonnull view);
/**
*  与视图view右边间距相等并偏移offset(TFY_VIEW * view, CGFloat offset)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_TrailingSpaceEqualViewOffset)(TFY_VIEW * _Nonnull view,CGFloat offset);

#pragma --------- 第六个分割点 --------
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
/**
*  与父视图底边间距Y(CGFloat value)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_FirstBaseLine)(CGFloat value);
/**
*  与相对视图toView底边间距Y(CGFloat value,TFY_VIEW * toView)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_FirstBaseLineToView)(CGFloat value,TFY_VIEW * _Nonnull toView);
/**
*  与视图view底边间距Y相等(TFY_VIEW * view)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_FirstBaseLineEqualView)(TFY_VIEW * _Nonnull view);
/**
*  与视图view底边间距Y相等并偏移offset(TFY_VIEW * view, CGFloat offset)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_FirstBaseLineEqualViewOffset)(TFY_VIEW * _Nonnull view,CGFloat offset);

#endif
/**
*   与父视图底边间距Y(CGFloat value)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_LastBaseLine)(CGFloat value);
/**
*  与相对视图toView底边间距Y(CGFloat value,TFY_VIEW * toView)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_LastBaseLineToView)(CGFloat value,TFY_VIEW * _Nonnull toView);
/**
*  与视图view底边间距Y相等(TFY_VIEW * view)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_LastBaseLineEqualView)(TFY_VIEW * _Nonnull view);
/**
*  与视图view底边间距Y相等并偏移offset(TFY_VIEW * view, CGFloat offset)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_LastBaseLineEqualViewOffset)(TFY_VIEW * _Nonnull view,CGFloat offset);
/**
*  与父视图右边间距(CGFloat value)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_RightSpace)(CGFloat value);
/**
*  与相对视图toView右边间距(CGFloat value,TFY_VIEW * toView)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_RightSpaceToView)(CGFloat value,TFY_VIEW * _Nonnull toView);
/**
*  与相对视图toView右边间距相等(TFY_VIEW toView)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_RightSpaceEqualView)(TFY_VIEW * _Nonnull view);
/**
*   与相对视图toView右边间距相等并偏移offset(TFY_VIEW toView, CGFloat offset)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_RightSpaceEqualViewOffset)(TFY_VIEW * _Nonnull view,CGFloat offset);

#pragma --------- 第七个分割点 --------
/**
*  与父视图顶边间距(CGFloat value)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_TopSpace)(CGFloat value);
/**
*  与相对视图toView顶边间距(CGFloat value,TFY_VIEW * toView)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_TopSpaceToView)(CGFloat value,TFY_VIEW * _Nonnull toView);
/**
*  与视图view顶边间距相等(TFY_VIEW * view)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_TopSpaceEqualView)(TFY_VIEW * _Nonnull view);
/**
*   与视图view顶边间距相等并偏移offset(TFY_VIEW * view, CGFloat offset)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_TopSpaceEqualViewOffset)(TFY_VIEW * _Nonnull view,CGFloat offset);

#pragma --------- 第八个分割点 --------
/**
*  与父视图底边间距(CGFloat value)
*/
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_BottomSpace)(CGFloat value);
/**
 *  与相对视图toView底边间距(CGFloat value,TFY_VIEW * toView)
 */
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_BottomSpaceToView)(CGFloat value,TFY_VIEW * _Nonnull toView);
/**
 *  与相对视图toView底边间距相等(TFY_VIEW * toView)
 */
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_BottomSpaceEqualView)(TFY_VIEW * _Nonnull view);
/**
 *  与相对视图toView底边间距相等并偏移offset(TFY_VIEW * toView, CGFloat offset)
 */
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_BottomSpaceEqualViewOffset)(TFY_VIEW * _Nonnull view,CGFloat offset);

#pragma --------- 第九个分割点 --------
/**
 *  宽度(CGFloat value)
 */
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_Width)(CGFloat value);
/**
 *  宽度自动()
 */
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_WidthAuto)(void);
/**
 *  宽度等于视图view(TFY_VIEW * view)
 */
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_WidthEqualView)(TFY_VIEW * _Nonnull view);
/**
 *  宽度等于视图view 参照比例Ratio(TFY_VIEW * view ,CGFloat ratio)
 */
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_WidthEqualViewRatio)(TFY_VIEW * _Nonnull view,CGFloat ratio);
/**
 *  视图自身宽度与高度的比(CGFloat Ratio)
 */
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_WidthHeightRatio)(CGFloat ratio);

#pragma --------- 第十个分割点 --------
/**
 *  高度(CGFloat value)
 */
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_Height)(CGFloat value);
/**
 *  高度自动()
 */
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_HeightAuto)(void);
/**
 *  高度等于视图view(TFY_VIEW * view)
 */
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_HeightEqualView)(TFY_VIEW * _Nonnull view);
/**
 *  视图自身高度与宽度的比(CGFloat Ratio)
 */
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_HeightWidthRatio)(CGFloat ratio);
/**
 *  高度等于视图view 参照比例Ratio(TFY_VIEW * view ,CGFloat ratio)
 */
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_HeightEqualViewRatio)(TFY_VIEW * _Nonnull view,CGFloat ratio);

#pragma --------- 第十一个分割点 --------
/**
 *  中心X与父视图偏移(CGFloat value)
 */
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_CenterX)(CGFloat value);
/**
 *  中心X与视图view偏移(CGFloat value , TFY_VIEW * toView)
 */
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_CenterXToView)(CGFloat value,TFY_VIEW * _Nonnull toView);

#pragma --------- 第十二个分割点 --------
/**
 *  中心Y与父视图偏移(CGFloat value)
 */
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_CenterY)(CGFloat value);
/**
 *  中心Y与视图view偏移(CGFloat value , TFY_VIEW * toView)
 */
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_CenterYToView)(CGFloat value,TFY_VIEW * _Nonnull toView);

#pragma --------- 第十三个分割点 --------
/**
 *  中心与父视图偏移(CGFloat value)
 */
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_Center)(CGFloat x,CGFloat y);
/**
 *  中心与视图view偏移(CGFloat value , TFY_VIEW * toView)
 */
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_CenterToView)(CGPoint center,TFY_VIEW * _Nonnull toView);
/**
 *  size设置(CGFloat width, CGFloat height)
 */
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_size)(CGFloat width,CGFloat height);
/**
 *  size设置(TFY_VIEW * view)
 */
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_SizeEqualView)(TFY_VIEW * _Nonnull view);
/**
 *  frame设置(TFY_VIEW * view)
 */
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_FrameEqualView)(TFY_VIEW * _Nonnull view);

#pragma **************************** 方法展示 ****************************
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

/**
 *  混合布局(同时垂直和横向)每行多少列
 */
@property (nonatomic , assign) NSInteger tfy_Column;
/**
 *  容器内边距
 */
#if TARGET_OS_IPHONE || TARGET_OS_TV
@property (nonatomic , assign) UIEdgeInsets tfy_Edge;
#elif TARGET_OS_MAC
@property (nonatomic , assign) NSEdgeInsets tfy_Edge;
#endif
/**
 *  容器内子控件横向间隙
 */
@property (nonatomic , assign) CGFloat tfy_HSpace;
/**
 *  容器内子控件垂直间隙
 */
@property (nonatomic , assign) CGFloat tfy_VSpace;
/**
 *  子元素高宽比
 */
@property (nonatomic , assign) CGFloat tfy_ElementHeightWidthRatio;
/**
 *  子元素宽高比
 */
@property (nonatomic , assign) CGFloat tfy_ElementWidthHeightRatio;
/**
 *  容器里子元素实际数量
 */
@property (nonatomic , assign , readonly) NSInteger tfy_SubViewCount;
/**
 *  容器自动布局方向
 */
@property (nonatomic , assign) TFY_LayoutOrientationOptions tfy_Orientation;
/**
 *  子视图固定宽度
 */
@property (nonatomic , assign) CGFloat tfy_SubViewWidth;
/**
 *  子视图固定高度
 */
@property (nonatomic , assign) CGFloat tfy_SubViewHeight;
/**
 *  设置分割线尺寸
 */
@property (nonatomic , assign) CGFloat tfy_SegmentLineSize;
/**
 *  设置分割线内边距
 */
@property (nonatomic , assign) CGFloat tfy_SegmentLinePadding;
/**
 *  设置分割线的颜色
 */
@property (nonatomic , strong) TFY_COLOR * tfy_SegmentLineColor;
/************重载父类属性**************/
/**
 *  自动高度
 */
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_HeightAuto)(void);
/**
 *  自动宽度
 */
@property(nonatomic,copy,readonly)TFY_CLASS_VIEW *(^tfy_WidthAuto)(void);
/**
 *  元素集合
 */
@property (nonatomic, strong, readonly)NSArray<TFY_CLASS_VIEW *> * tfy_Subviews;

/************重载父类方法**************/
/**
 * 自动宽度
 */
- (void)tfy_AutoWidth;
/**
 * 自动高度
 */
- (void)tfy_AutoHeight;
/**
 *  开始进行自动布局
 */
- (void)tfy_StartLayout;
/**
 * 清除所有子视图
 */
- (void)tfy_RemoveAllSubviews;
/**
 * 移除所有空白站位视图(仅仅横向垂直混合布局有效)
 */
- (void)tfy_RemoveAllVacntView;

@end



NS_ASSUME_NONNULL_END
