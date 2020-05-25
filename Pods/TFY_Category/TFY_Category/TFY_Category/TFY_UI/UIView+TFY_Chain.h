//
//  UIView+TFY_Chain.h
//  TFY_Category
//
//  Created by 田风有 on 2019/6/11.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import <UIKit/UIKit.h>
/**切圆角*/
typedef NS_OPTIONS (NSUInteger, CornerClipType) {
    CornerClipTypeNone = 0,  // 不切
    CornerClipTypeTopLeft     = UIRectCornerTopLeft, // 左上角
    CornerClipTypeTopRight    = UIRectCornerTopRight, // 右上角
    CornerClipTypeBottomLeft  = UIRectCornerBottomLeft, // 左下角
    CornerClipTypeBottomRight = UIRectCornerBottomRight, // 右下角
    CornerClipTypeAll  = UIRectCornerAllCorners,// 全部四个角
    // 上面2个角
    CornerClipTypeBothTop  = CornerClipTypeTopLeft | CornerClipTypeTopRight,
    // 下面2个角
    CornerClipTypeBothBottom  = CornerClipTypeBottomLeft | CornerClipTypeBottomRight,
    // 左侧2个角
    CornerClipTypeBothLeft  = CornerClipTypeTopLeft | CornerClipTypeBottomLeft,
    // 右面2个角
    CornerClipTypeBothRight  = CornerClipTypeTopRight | CornerClipTypeBottomRight
};
/**加边框*/
typedef NS_OPTIONS(NSInteger, BorderDirection){
    BorderDirectionLeft = 1 << 1,
    BorderDirectionTop = 1 << 2,
    BorderDirectionRight = 1 << 3,
    BorderDirectionBottom = 1 << 4,
};

NS_ASSUME_NONNULL_BEGIN

static inline UIView * _Nonnull tfy_view(void){
    return [[UIView alloc] init];
}
static inline UIView * _Nonnull tfy_viewframe(CGRect rect){
    return [[UIView alloc] initWithFrame:rect];
}

typedef void(^TouchCallBackBlock)(void);

@interface UIView (TFY_Chain)
/**
 * 背景颜色
 */
@property(nonatomic, copy, readonly)UIView *_Nonnull(^_Nonnull tfy_backgroundColor)(UIColor*_Nonnull);
/**
 * frame
 */
@property(nonatomic, copy, readonly)UIView *_Nonnull(^_Nonnull tfy_frame)(CGRect);
/**
 * 添加View
 */
@property(nonatomic, copy, readonly)UIView *_Nonnull(^_Nonnull tfy_addToSuperView)(UIView *_Nonnull);
/**
 * 透明度
 */
@property(nonatomic, copy, readonly)UIView *_Nonnull(^_Nonnull tfy_alpha)(CGFloat);
/**
 * 如果是，则将内容和子视图裁剪到视图的边界。默认是否定的。
 */
@property(nonatomic, copy, readonly)UIView *_Nonnull(^_Nonnull tfy_clipsToBounds)(BOOL);
/**
 * 隐藏本类
 */
@property(nonatomic, copy, readonly)UIView *_Nonnull(^_Nonnull tfy_hidden)(BOOL);
/**
 * 交互
 */
@property(nonatomic, copy, readonly)UIView *_Nonnull(^_Nonnull tfy_userInteractionEnabled)(BOOL);
/**
 *  初始一个Lable 可以随自己更改
 */
@property(nonatomic,strong)UILabel *tfy_bgdge;
/**
 *  显示的个数
 */
@property(nonatomic,copy)NSString *tfy_badgeValue;
/**
 * 徽章的背景色
 */
@property(nonatomic,strong)UIColor *tfy_badgeBGColor;
/**
 *  徽章的文字颜色
 */
@property(nonatomic,strong)UIColor *tfy_badgeTextColor;
/**
 *  标志字体
 */
@property(nonatomic,strong)UIFont *tfy_badgeFont;
/**
 *  徽章的填充值
 */
@property(nonatomic,assign)CGFloat tfy_badgePadding;
/**
 *  最小尺寸小徽章
 */
@property(nonatomic,assign)CGFloat tfy_badgeMinSize;
/**
 *  X barbuttonitem你选值
 */
@property(nonatomic,assign)CGFloat tfy_badgeOriginX;
/**
 *  Y barbuttonitem你选值
 */
@property(nonatomic,assign)CGFloat tfy_badgeOriginY;
/**
 *  删除徽章时达到零
 */
@property(nonatomic,assign)BOOL tfy_shouldHideBadgeAtZero;
/**
 *  当价值变化时，徽章有一个反弹动画
 */
@property(nonatomic,assign)BOOL tfy_shouldAnimateBadge;
/**
 *  获取当前控制器
 */
- (UIViewController *_Nonnull)viewController;
/**
 *  获取当前navigationController
 */
- (UINavigationController *_Nonnull)navigationController;
/**
 *  获取当前tabBarController
 */
- (UITabBarController *_Nonnull)tabBarController;
/**
 *  添加四边阴影 shadowColor 颜色  shadowRadius 半径 shadowOpacity 透明度  setShadow 大小
 */
-(void)tfy_setShadow:(CGSize)size shadowOpacity:(CGFloat)opacity shadowRadius:(CGFloat)radius shadowColor:(UIColor *)color;

#pragma -------------------------------------点击事件方法---------------------------------

/**
 *  添加点击事件
 */
@property (nonatomic, copy) TouchCallBackBlock touchCallBackBlock;

- (void)addActionWithblock:(TouchCallBackBlock)block;

- (void)addTarget:(id)target action:(SEL)action;

#pragma -------------------------------------添加圆角方法---------------------------------

/**圆角*/
@property(nonatomic, assign) CGFloat tfy_clipRadius;
@property(nonatomic, assign) CornerClipType tfy_clipType;

/**border*/
@property(nonatomic, assign) CGFloat tfy_borderWidth;
@property(nonatomic, strong) UIColor *tfy_borderColor;

/**
 * 便捷添加圆角 clipType 圆角类型  radius 圆角角度
 */
- (void)clipWithType:(CornerClipType)clipType radius:(CGFloat)radius;

/**
 * 便捷给添加border  color 边框的颜色  borderWidth 边框的宽度
 */
- (void)addBorderWithColor:(UIColor *_Nonnull)color borderWidth:(CGFloat)borderWidth;

#pragma -------------------------------------加边框方法---------------------------------

/** 使用layer的borderWidth统一设置*/
- (void)addBorderWithInset:(UIEdgeInsets)inset Color:(UIColor *_Nonnull)borderColor direction:(BorderDirection)directions;

/**使用layer的borderColor统一设置*/
- (void)addBorderWithInset:(UIEdgeInsets)inset BorderWidth:(CGFloat)borderWidth direction:(BorderDirection)directions;


/**各项的间距为UIEdgeInsetsZero*/
- (void)addBorderWithColor:(UIColor *_Nonnull)borderColor BodrerWidth:(CGFloat)borderWidth direction:(BorderDirection)directions;

/**自定义的layer设置*/
- (void)addBorderWithInset:(UIEdgeInsets)inset Color:(UIColor *_Nonnull)borderColor BorderWidth:(CGFloat)borderWidth direction:(BorderDirection)directions;

/** 移除当前边框*/
- (void)removeBorders:(BorderDirection)directions;

/**移除所有追加的边框*/
- (void)removeAllBorders;

#pragma -------------------------------------手势点击添加方法---------------------------------

/**
 *  添加Tap手势事件  target 事件目标  vaction 事件  返回添加的手势
 */
- (UITapGestureRecognizer *)addGestureTapTarget:(id)target action:(SEL)action;

/**
 *  添加Pan手势事件  target 事件目标  action 事件  返回添加的手势
 */
- (UIPanGestureRecognizer *)addGesturePanTarget:(id)target action:(SEL)action;

/**
 *  添加Pinch手势事件   target 事件目标  action 事件  返回添加的手势
 */
- (UIPinchGestureRecognizer *)addGesturePinchTarget:(id)target action:(SEL)action;

/**
 *  添加LongPress手势事件  target 事件目标  action 事件  返回添加的手势
 */
- (UILongPressGestureRecognizer *)addGestureLongPressTarget:(id)target action:(SEL)action;

/**
 *  添加Swipe手势事件  target 事件目标  action 事件  返回添加的手势
 */
- (UISwipeGestureRecognizer *)addGestureSwipeTarget:(id)target action:(SEL)action;

/**
 *  添加Rotation手势事件  target 事件目标  action 事件  返回添加的手势
 */
- (UIRotationGestureRecognizer *)addGestureRotationTarget:(id)target action:(SEL)action;

/**
 *  添加ScreenEdgePan手势事件  target 事件目标  action 事件  返回添加的手势
 */
- (UIScreenEdgePanGestureRecognizer *)addGestureScreenEdgePanTarget:(id)target action:(SEL)action;

#pragma  ---------------------手势回调------------------------------

/**
 *  添加Tap手势block事件  event block事件  返回添加的手势
 */
- (UITapGestureRecognizer *)addGestureTapEventHandle:(void (^)(id sender, UITapGestureRecognizer *gestureRecognizer))event;

/**
 *  添加Pan手势block事件  event block事件   返回添加的手势
 */
- (UIPanGestureRecognizer *)addGesturePanEventHandle:(void (^)(id sender, UIPanGestureRecognizer *gestureRecognizer))event;

/**
 *  添加Pinch手势block事件  event block事件  返回添加的手势
 */
- (UIPinchGestureRecognizer *)addGesturePinchEventHandle:(void (^)(id sender, UIPinchGestureRecognizer *gestureRecognizer))event;

/**
 *  添加LongPress手势block事件  event block事件  返回添加的手势
 */
- (UILongPressGestureRecognizer *)addGestureLongPressEventHandle:(void (^)(id sender, UILongPressGestureRecognizer *gestureRecognizer))event;

/**
 *  添加Swipe手势block事件  event block事件  返回添加的手势
 */
- (UISwipeGestureRecognizer *)addGestureSwipeEventHandle:(void (^)(id sender, UISwipeGestureRecognizer *gestureRecognizer))event;

/**
 *  添加Rotation手势block事件  event block事件  返回添加的手势
 */
- (UIRotationGestureRecognizer *)addGestureRotationEventHandle:(void (^)(id sender, UIRotationGestureRecognizer *gestureRecognizer))event;

/**
 *  添加ScreenEdgePan手势block事件  event block事件  返回添加的手势
 */
- (UIScreenEdgePanGestureRecognizer *)addGestureScreenEdgePanEventHandle:(void (^)(id sender, UIScreenEdgePanGestureRecognizer *gestureRecognizer))event;


@end

NS_ASSUME_NONNULL_END
