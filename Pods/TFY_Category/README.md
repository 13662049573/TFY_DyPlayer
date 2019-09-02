# TFY_Category
类方式的各种总结。

#import "UIView+Genie.h" 

设置一个四角圆角 radius 圆角半径  color  圆角背景色
 */
- (void)tfy_cornerRadius:(CGFloat)radius cornerColor:(UIColor *_Nonnull)color;

/**
 *
 *设置一个普通圆角 radius  圆角半径 color   圆角背景色 corners 圆角位置
 */
- (void)tfy_cornerRadius:(CGFloat)radius cornerColor:(UIColor *_Nonnull)color corners:(UIRectCorner)corners;
/**
 *
 *设置一个带边框的圆角 cornerRadii 圆角半径cornerRadii color       圆角背景色  corners     圆角位置  borderColor 边框颜色 borderWidth 边框线宽
 */
- (void)tfy_cornerRadii:(CGSize)cornerRadii cornerColor:(UIColor *_Nonnull)color corners:(UIRectCorner)corners borderColor:(UIColor *_Nonnull)borderColor borderWidth:(CGFloat)borderWidth;
/**
 *
 */
+ (UIView *_Nullable)tfy_gradientViewWithColors:(NSArray<UIColor *> *_Nullable)colors locations:(NSArray<NSNumber *> *_Nullable)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

- (void)tfy_setGradientBackgroundWithColors:(NSArray<UIColor *> *_Nullable)colors locations:(NSArray<NSNumber *> *_Nullable)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
/**
 * 添加四边阴影效果
 */
- (void)tfy_addShadowToView:(UIView *_Nonnull)theView withColor:(UIColor *_Nonnull)theColor;
/**
 *  添加单边阴影效果
 */
-(void)tfy_addShadowhalfView:(UIView *_Nonnull)theView withColor:(UIColor *_Nonnull)theColor;
/**
 * 添加阴影 shadowColor 阴影颜色 shadowOpacity 阴影透明度，默认0  shadowRadius  阴影半径，默认3 shadowPathSide 设置哪一侧的阴影，shadowPathWidth 阴影的宽度，
 */
-(void)tfy_SetShadowPathWith:(UIColor *_Nonnull)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowSide:(TFY_ShadowPathSide)shadowPathSide shadowPathWidth:(CGFloat)shadowPathWidth;

-(void)tfy_setShadow:(CGSize)size shadowOpacity:(CGFloat)opacity shadowRadius:(CGFloat)radius shadowColor:(UIColor *_Nonnull)color;

#import "NSDate+TFY_Date.h"

/**
 * 判断是否是润年
 * @return YES表示润年，NO表示平年
 */
- (BOOL)isLeapYear;
+ (BOOL)isLeapYear:(NSDate *)date;

/**
 * 获取该日期是该年的第几周
 */
- (NSUInteger)weekOfYear;
+ (NSUInteger)weekOfYear:(NSDate *)date;

/**
 * 获取格式化为YYYY-MM-dd格式的日期字符串
 */
- (NSString *)formatYMD;
+ (NSString *)formatYMD:(NSDate *)date;

/**
 * 返回当前月一共有几周(可能为4,5,6)
 */
- (NSUInteger)weeksOfMonth;
+ (NSUInteger)weeksOfMonth:(NSDate *)date;

#import "UIButton+Swizzling.h"

/**
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
 *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing   spacing 图片和文字的间隔
 */
-(void)tfy_layouEdgeInsetsPosition:(TFY_ButtonPosition)postion spacing:(CGFloat)spacing;

/**
 *  利用运行时自由设置UIButton的titleLabel和imageView的显示位置
 */

/** 设置按钮图片控件位置 */
@property (nonatomic, assign) CGRect tfy_imageRect;

/** 设置按钮图片控件位置 */
@property (nonatomic, assign) CGRect tfy_titleRect;

/** 设置按钮图片控件位置 */
- (void)tfy_layoutTitleRect:(CGRect )titleRect imageRect:(CGRect )imageRect;
/**
 *  带有uiiinage 图片方法
 */
+(UIButton*)tfy_createButtonWithTarget:(id)target Selector:(SEL)selector Image:(NSString *)image ImagePressed:(NSString *)imagePressed;
/**
 *  title 按钮文字  color a颜色 font 大小  是否居中 Integer 0 居中 1 向左 2 向右
 */
+(UIButton *)tfy_createButtonWithTitle:(NSString *)title titleColor:(UIColor *)color font:(CGFloat)font Alignment:(NSInteger )Integer Target:(id)target Selector:(SEL)selector;
/**
 *  title 按钮文字  color a颜色 font 大小  是否居中 Integer 0 居中 1 向左 2 向右  TFY_ButtonPosition 图片的位置方法 space 图片距离
 */
+(UIButton *)tfy_createButtonImageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font Alignment:(NSInteger )Integer EdgeInsetsStyle:(TFY_ButtonPosition)style imageTitleSpace:(CGFloat)space target:(id)target action:(SEL)action;/**
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
 *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing   spacing 图片和文字的间隔
 */
-(void)tfy_layouEdgeInsetsPosition:(TFY_ButtonPosition)postion spacing:(CGFloat)spacing;

/**
 *  利用运行时自由设置UIButton的titleLabel和imageView的显示位置
 */

/** 设置按钮图片控件位置 */
@property (nonatomic, assign) CGRect tfy_imageRect;

/** 设置按钮图片控件位置 */
@property (nonatomic, assign) CGRect tfy_titleRect;

/** 设置按钮图片控件位置 */
- (void)tfy_layoutTitleRect:(CGRect )titleRect imageRect:(CGRect )imageRect;
/**
 *  带有uiiinage 图片方法
 */
+(UIButton*)tfy_createButtonWithTarget:(id)target Selector:(SEL)selector Image:(NSString *)image ImagePressed:(NSString *)imagePressed;
/**
 *  title 按钮文字  color a颜色 font 大小  是否居中 Integer 0 居中 1 向左 2 向右
 */
+(UIButton *)tfy_createButtonWithTitle:(NSString *)title titleColor:(UIColor *)color font:(CGFloat)font Alignment:(NSInteger )Integer Target:(id)target Selector:(SEL)selector;
/**
 *  title 按钮文字  color a颜色 font 大小  是否居中 Integer 0 居中 1 向左 2 向右  TFY_ButtonPosition 图片的位置方法 space 图片距离
 */
+(UIButton *)tfy_createButtonImageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font Alignment:(NSInteger )Integer EdgeInsetsStyle:(TFY_ButtonPosition)style imageTitleSpace:(CGFloat)space target:(id)target action:(SEL)action;

#import "UIColor+TFY_Color.h"
/**
 *  颜色渐变
 */
+(UIColor *)tfy_colorBetweenColor:(UIColor *)color1 andColor:(UIColor *)color2 percentage:(float)percentage;

/**
 *  创建渐变颜色 size  渐变的size direction 渐变方式 startcolor 开始颜色  endColor 结束颜色
 */
+(UIColor *)tfy_colorGradientChangeWithSize:(CGSize)size direction:(GradientChangeDirection)direction startColor:(UIColor *)startcolor endColor:(UIColor *)endColor;

/**
 * 需要的 NSNumbers 数组中并配置从它的颜色。
 * 位置 0 是红色，1 绿，2 蓝色，3 阿尔法。
 */
+(UIColor *)tfy_colorWithConfig:(NSArray *)config;

/**
 *  颜色转换：iOS中（以#开头）十六进制的颜色转换为UIColor(RGB)
 */
+ (UIColor *)tfy_ColorWithHexString:(NSString *)color;

#import "NSObject+TFY_Associated.h"
**
 *  关联key
 */
- (id)tfy_getAssociatedValueForKey:(void *)key;
/**
 *  关联 - OBJC_ASSOCIATION_RETAIN_NONATOMIC
 */
- (void)tfy_setAssociatedValue:(id)value withKey:(void *)key;
/**
 *  关联- OBJC_ASSOCIATION_ASSIGN
 */
- (void)tfy_setAssignValue:(id)value withKey:(SEL)key;
/**
 *  关联 - OBJC_ASSOCIATION_COPY_NONATOMIC
 */
- (void)tfy_setCopyValue:(id)value withKey:(SEL)key;
/**
 *  删除关联
 */
- (void)tfy_removeAssociatedObjects;
/**
 *  类名
 */
- (NSString *)tfy_className;
+ (NSString *)tfy_className;
/**
 *  父类名称
 */
- (NSString *)tfy_superClassName;
+ (NSString *)tfy_superClassName;
/**
 *  实例属性字典
 */
-(NSDictionary *)tfy_propertyDictionary;
/**
 *  属性名称列表
 */
- (NSArray*)tfy_propertyKeys;
+ (NSArray *)tfy_propertyKeys;
/**
 * 属性详细信息列表
 */
- (NSArray *)tfy_propertiesInfo;
+ (NSArray *)tfy_propertiesInfo;
/**
 *  格式化后的属性列表
 */
+ (NSArray *)tfy_propertiesWithCodeFormat;
/**
 *  方法列表
 */
-(NSArray*)tfy_methodList;
+(NSArray*)tfy_methodList;

-(NSArray*)tfy_methodListInfo;
/**
 *  创建并返回一个指向所有已注册类的指针列表
 */
+ (NSArray *)tfy_registedClassList;
/**
 * 实例变量
 */
+ (NSArray *)tfy_instanceVariable;

这些都是皮毛还有很多，需要的可以下载pod ‘TFY_Category’ cococapods加入直接使用。
