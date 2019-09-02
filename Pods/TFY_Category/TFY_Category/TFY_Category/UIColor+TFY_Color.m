//
//  UIColor+TFY_Color.m
//  XJK
//
//  Created by 田风有 on 2018/8/2.
//  Copyright © 2018年 zhegndi. All rights reserved.
//

#import "UIColor+TFY_Color.h"

static void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v )
{
    float min, max, delta;
    min = MIN( r, MIN( g, b ));
    max = MAX( r, MAX( g, b ));
    *v = max;               // v
    delta = max - min;
    if( max != 0 )
        *s = delta / max;       // s
    else {
        // r = g = b = 0        // s = 0, V是不确定的
        *s = 0;
        *h = -1;
        return;
    }
    if( r == max )
        *h = ( g - b ) / delta;     // 黄色和红色之间
    else if( g == max )
        *h = 2 + ( b - r ) / delta; // 青色和黄色之间
    else
        *h = 4 + ( r - g ) / delta; // 品红和青之间
    *h *= 60;               // 度
    if( *h < 0 )
        *h += 360;
}


@implementation UIColor (TFY_Color)

+ (UIColor *)tfy_colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue{
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

+ (UIColor *)tfy_colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r                       截取的range = (0,2)
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;//     截取的range = (2,2)
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;//     截取的range = (4,2)
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;//将字符串十六进制两位数字转为十进制整数
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

//默认alpha值为1
+ (UIColor *)tfy_colorWithHexString:(NSString *)color
{
    return [self tfy_colorWithHexString:color alpha:1.0f];
}
/**
 *  根据图片获取图片的主色调
 */
+ (UIColor *)tfy_colorAtPosition:(CGPoint)position inImage:(UIImage *)image
{
    CGRect sourceRect = CGRectMake(position.x, position.y, 1.0f, 1.0f);
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, sourceRect);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *buffer = malloc(4);
    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big;
    CGContextRef context = CGBitmapContextCreate(buffer, 1, 1, 8, 4, colorSpace, bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0.f, 0.f, 1.0f, 1.0f), imageRef);
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGFloat r = buffer[0] / 255.0f;
    CGFloat g = buffer[1] / 255.0f;
    CGFloat b = buffer[2] / 255.0f;
    CGFloat a = buffer[3] / 255.0f;
    free(buffer);
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

+ (UIColor *)tfy_colorWithHex:(NSString *)hexString
{
    NSString *trimmedString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    //Only take the last 6 characters ever, so someone can prefix it with #, 0x, or whatever they want
    if (trimmedString.length != 6)
    {
        trimmedString = [trimmedString substringWithRange:NSMakeRange(trimmedString.length-6, 6)];
    }
    
    NSRange range = NSMakeRange(0, 2);
    NSString *red = [trimmedString substringWithRange:range];
    
    range.location = 2;
    NSString *green = [trimmedString substringWithRange:range];
    
    range.location = 4;
    NSString *blue = [trimmedString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:red] scanHexInt:&r];
    [[NSScanner scannerWithString:green] scanHexInt:&g];
    [[NSScanner scannerWithString:blue] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (NSString *)tfy_hexFromColor:(UIColor *)color
{
    if (color == nil || color == [UIColor whiteColor])
    {
        //[UIColor whiteColor] isn't in the RGB spectrum
        return @"#ffffff";
    }
    
    CGFloat red, blue, green, alpha;
    
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    NSUInteger redInt = (NSUInteger)(red*255);
    NSUInteger greenInt = (NSUInteger)(green*255);
    NSUInteger blueInt = (NSUInteger)(blue*255);
    
    NSString *returnString = [NSString stringWithFormat:@"#%02x%02x%02x", (unsigned int)redInt, (unsigned int)greenInt, (unsigned int)blueInt];
    
    return returnString;
}

+ (NSString *)tfy_stripHashtagFromHex:(NSString *)hexString
{
    return ([hexString hasPrefix:@"#"]) ? [hexString substringFromIndex:1] : hexString;
}

+ (NSString *)tfy_addHashtagToHex:(NSString *)hexString
{
    return ([hexString hasPrefix:@"#"]) ? hexString : [@"#" stringByAppendingString:hexString];
}

- (UIColor *)tfy_darkenedColorByPercent:(float)percentage
{
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    double multiplier = 1.0-percentage;
    
    return [UIColor colorWithRed:red*multiplier green:green*multiplier blue:blue*multiplier alpha:alpha];
}

- (UIColor *)tfy_lightenedColorByPercent:(float)percentage
{
    return [self tfy_darkenedColorByPercent:-percentage];
}

- (UIColor *)tfy_tenPercentLighterColor
{
    return [self tfy_lightenedColorByPercent:0.1];
}

- (UIColor *)tfy_twentyPercentLighterColor
{
    return [self tfy_lightenedColorByPercent:0.2];
}

- (UIColor *)tfy_tenPercentDarkerColor
{
    return [self tfy_darkenedColorByPercent:0.1];
}

- (UIColor *)tfy_twentyPercentDarkerColor
{
    return [self tfy_darkenedColorByPercent:0.2];
}

+(UIColor *)tfy_colorBetweenColor:(UIColor *)c1 andColor:(UIColor *)c2 percentage:(float)p
{
    float p1 = 1.0 - p;
    float p2 = p;
    
    const CGFloat *components = CGColorGetComponents([c1 CGColor]);
    CGFloat r1 = components[0];
    CGFloat g1 = components[1];
    CGFloat b1 = components[2];
    CGFloat a1 = components[3];
    
    components = CGColorGetComponents([c2 CGColor]);
    CGFloat r2 = components[0];
    CGFloat g2 = components[1];
    CGFloat b2 = components[2];
    CGFloat a2 = components[3];
    
    return [UIColor colorWithRed:r1*p1 + r2*p2
                           green:g1*p1 + g2*p2
                            blue:b1*p1 + b2*p2
                           alpha:a1*p1 + a2*p2];
}

/**
 *  创建渐变颜色 size  渐变的size direction 渐变方式 startcolor 开始颜色  endColor 结束颜色
 */
+(UIColor *)tfy_colorGradientChangeWithSize:(CGSize)size direction:(GradientChangeDirection)direction startColor:(UIColor *)startcolor endColor:(UIColor *)endColor{
    if (CGSizeEqualToSize(size, CGSizeZero) || !startcolor || !endColor) {
        return nil;
    }
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    
    CGPoint startPoint = CGPointZero;
    if (direction == GradientChangeDirectionDownDiagonalLine) {
        startPoint = CGPointMake(0.0, 1.0);
    }
    gradientLayer.startPoint = startPoint;
    
    CGPoint endPoint = CGPointZero;
    switch (direction) {
        case GradientChangeDirectionLevel:
            endPoint = CGPointMake(1.0, 0.0);
            break;
        case GradientChangeDirectionVertical:
            endPoint = CGPointMake(0.0, 1.0);
            break;
        case GradientChangeDirectionUpwardDiagonalLine:
            endPoint = CGPointMake(1.0, 1.0);
            break;
        case GradientChangeDirectionDownDiagonalLine:
            endPoint = CGPointMake(1.0, 0.0);
            break;
        default:
            break;
    }
    gradientLayer.endPoint = endPoint;
    
    gradientLayer.colors = @[(__bridge id)startcolor.CGColor, (__bridge id)endColor.CGColor];
    UIGraphicsBeginImageContext(size);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [UIColor colorWithPatternImage:image];
}
/**
 * Takes in an array of NSNumbers and configures a color from it.
 * Position 0 is red, 1 green, 2 blue, 3 alpha.
 */
+(UIColor *)tfy_colorWithConfig:(NSArray *)config{
    return [UIColor colorWithRed:((NSNumber *)[config objectAtIndex:0]).floatValue
                           green:((NSNumber *)[config objectAtIndex:1]).floatValue
                            blue:((NSNumber *)[config objectAtIndex:2]).floatValue
                           alpha:((NSNumber *)[config objectAtIndex:3]).floatValue];
}

+ (UIColor *)tfy_ColorWithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (UIColor *)tfy_colorFromHexRGB:(NSString *)inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

+(UIColor*)tfy_mostColor_Color:(UIImage*)image{
    
    
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    
    CGSize thumbSize=CGSizeMake((int)(image.size.width/2), (int)(image.size.height/2));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    //第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData (context);
    
    if (data == NULL) return nil;
    NSArray *MaxColor=nil;
    // NSCountedSet *cls=[NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    float maxScore=0;
    for (int x=0; x<thumbSize.width*thumbSize.height; x++) {
        
        int offset = 4*x;
        
        int red = data[offset];
        int green = data[offset+1];
        int blue = data[offset+2];
        int alpha =  data[offset+3];
        
        if (alpha<25)continue;
        
        float h,s,v;
        RGBtoHSV(red, green, blue, &h, &s, &v);
        
        float y = MIN(abs(red*2104+green*4130+blue*802+4096+131072)>>13, 235);
        y= (y-16)/(235-16);
        if (y>0.9) continue;
        
        float score = (s+0.1)*x;
        if (score>maxScore) {
            maxScore = score;
        }
        MaxColor=@[@(red),@(green),@(blue),@(alpha)];
        //[cls addObject:clr];
    }
    CGContextRelease(context);
    
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
}
#pragma mark - Private Methods (PrivateColorWithHexAndAlpha)
+ (UIColor *)tfy_colorWith3DigitHex:(NSString *)hex andAlpha:(CGFloat)alpha
{
    // Red Value
    NSString *redHexString = [hex substringWithRange:NSMakeRange(0, 1)];
    NSString *modifiedRedHexString = [NSString stringWithFormat:@"%@%@", redHexString, redHexString];
    NSScanner *redScanner = [NSScanner scannerWithString:modifiedRedHexString];
    unsigned int redHexInt = 0;
    [redScanner scanHexInt:&redHexInt];
    CGFloat redValue = redHexInt/255.0f;
    
    // Green Value
    NSString *greenHexString = [hex substringWithRange:NSMakeRange(1, 1)];
    NSString *modifiedGreenHexString = [NSString stringWithFormat:@"%@%@", greenHexString, greenHexString];
    NSScanner *greenScanner = [NSScanner scannerWithString:modifiedGreenHexString];
    unsigned int  greenHexInt = 0;
    [greenScanner scanHexInt:&greenHexInt];
    CGFloat greenValue = greenHexInt/255.0f;
    
    // Blue Value
    NSString *blueHexString = [hex substringWithRange:NSMakeRange(2, 1)];
    NSString *modifiedBlueHexString = [NSString stringWithFormat:@"%@%@", blueHexString, blueHexString];
    NSScanner *blueScanner = [NSScanner scannerWithString:modifiedBlueHexString];
    unsigned int  blueHexInt = 0;
    [blueScanner scanHexInt:&blueHexInt];
    CGFloat blueValue = blueHexInt/255.0f;
    
    return [UIColor colorWithRed:redValue green:greenValue blue:blueValue alpha:alpha];
}

+ (UIColor *)tfy_colorWith6DigitHex:(NSString *)hex andAlpha:(CGFloat)alpha
{
    // Red Value
    NSString *redHexString = [hex substringWithRange:NSMakeRange(0, 2)];
    NSScanner *redScanner = [NSScanner scannerWithString:redHexString];
    unsigned int  redHexInt = 0;
    [redScanner scanHexInt:&redHexInt];
    CGFloat redValue = redHexInt/255.0f;
    
    // Green Value
    NSString *greenHexString = [hex substringWithRange:NSMakeRange(2, 2)];
    NSScanner *greenScanner = [NSScanner scannerWithString:greenHexString];
    unsigned int  greenHexInt = 0;
    [greenScanner scanHexInt:&greenHexInt];
    CGFloat greenValue = greenHexInt/255.0f;
    
    // Blue Value
    NSString *blueHexString = [hex substringWithRange:NSMakeRange(4, 2)];
    NSScanner *blueScanner = [NSScanner scannerWithString:blueHexString];
    unsigned int  blueHexInt = 0;
    [blueScanner scanHexInt:&blueHexInt];
    CGFloat blueValue = blueHexInt/255.0f;
    
    return [UIColor colorWithRed:redValue green:greenValue blue:blueValue alpha:alpha];
}
/**
 *  随机颜色
 */
+(UIColor *)tfy_randomColor{
    CGFloat r = 120+arc4random()%150;
    CGFloat g = 100+arc4random()%130;
    CGFloat b = arc4random()%50;
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}

@end
