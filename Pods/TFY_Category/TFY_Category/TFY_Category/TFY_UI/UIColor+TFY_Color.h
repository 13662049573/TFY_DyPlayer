//
//  UIColor+TFY_Color.h
//  XJK
//
//  Created by 田风有 on 2018/8/2.
//  Copyright © 2018年 zhegndi. All rights reserved.
//  https://github.com/13662049573/TFY_AutoLayoutModelTools

#import <UIKit/UIKit.h>

/**
 渐变方式
 
 - GradientChangeDirectionLevel:              水平渐变
 - GradientChangeDirectionVertical:           竖直渐变
 - GradientChangeDirectionUpwardDiagonalLine: 向下对角线渐变
 - GradientChangeDirectionDownDiagonalLine:   向上对角线渐变
 */
typedef NS_ENUM(NSInteger, GradientChangeDirection) {
    GradientChangeDirectionLevel,
    GradientChangeDirectionVertical,
    GradientChangeDirectionUpwardDiagonalLine,
    GradientChangeDirectionDownDiagonalLine,
};



@interface UIColor (PrivateColorWithHexAndAlpha)

+ (instancetype)tfy_colorWith3DigitHex:(NSString *)hex andAlpha:(CGFloat)alpha;
+ (instancetype)tfy_colorWith6DigitHex:(NSString *)hex andAlpha:(CGFloat)alpha;

@end

@interface UIColor (TFY_Color)
/**
 *  默认alpha为1
 */
+ (UIColor *)tfy_colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

/**
 *   从十六进制字符串获取颜色,默认alpha为1
 */
+ (UIColor *)tfy_colorWithHexString:(NSString *)color;

/**
 *  从十六进制字符串获取颜色，alpha需要自己传递 color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
 */
+ (UIColor *)tfy_colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
/**
 *  根据图片获取图片的主色调 position--范围
 */
+ (UIColor *)tfy_colorAtPosition:(CGPoint)position inImage:(UIImage *)image;
/**
 *  颜色转换：iOS中 十六进制的颜色转换为UIColor(RGB)
 */
+ (UIColor *)tfy_colorWithHex:(NSString *)hexString;
/**
 *  颜色转换：将颜色换字符串
 */
+ (NSString *)tfy_hexFromColor:(UIColor *)color;
/**
 *  将颜色值带有#号的字符去掉
 */
+ (NSString *)tfy_stripHashtagFromHex:(NSString *)hexString;
/**
 *   将颜色值带有#号的字符添加
 */
+ (NSString *)tfy_addHashtagToHex:(NSString *)hexString;
/**
 *   颜色值的暗调
 */
- (UIColor *)tfy_darkenedColorByPercent:(float)percentage;
/**
 *  颜色值的点亮
 */
- (UIColor *)tfy_lightenedColorByPercent:(float)percentage;
/**
 *  百分之十打火机
 */
- (UIColor *)tfy_tenPercentLighterColor;
/**
 *
 */
- (UIColor *)tfy_twentyPercentLighterColor;
/**
 *
 */
- (UIColor *)tfy_tenPercentDarkerColor;
/**
 *
 */
- (UIColor *)tfy_twentyPercentDarkerColor;
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
/**
 *  颜色转换：iOS中 十六进制的颜色转换为UIColor(RGB)
 */
+ (UIColor *)tfy_colorFromHexRGB:(NSString *)inColorString;
/**
 *   获取图片的平均颜色
 */
+(UIColor*)tfy_mostColor_Color:(UIImage*)image;
/**
 *  随机颜色
 */
+(UIColor *)tfy_randomColor;
/**
 *   ios 13 添加颜色的判断 提供了的新方法，可以在 block 中判断 traitCollection.userInterfaceStyle，根据系统模式设置返回的颜色。
 */
+(UIColor *)generateDynamicColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor;
/**将颜色对象转换为canvas用字符串格式*/
-(NSString *)tfy_canvasColorString;
/***将颜色对象转换为Web用字符串格式*/
-(NSString *)tfy_webColorString;
/***将颜色对象变亮*/
-(UIColor *)tfy_lighten;
/***将颜色对象变暗*/
-(UIColor *)tfy_darken;
/**将两个颜色对象混合*/
-(UIColor *)tfy_mix:(UIColor *)c;
/**适合各种颜色值*/
+(UIColor *)colorWithHexString:(NSString *)hexString;
/***颜色转字符串*/
+(NSString*)stringWithColor:(UIColor *)color;
@end
