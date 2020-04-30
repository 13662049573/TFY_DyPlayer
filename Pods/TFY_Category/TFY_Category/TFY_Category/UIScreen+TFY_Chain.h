//
//  UIScreen+TFY_Chain.h
//  TFY_Category
//
//  Created by tiandengyou on 2020/3/27.
//  Copyright © 2020 恋机科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScreen (TFY_Chain)
+ (CGFloat)scale;

+ (CGRect)bounds;

+ (CGSize)size;

+ (CGFloat)width;

+ (CGFloat)height;

/**
 宽度，恒定
 */
+ (CGFloat)screenWidth;

/**
 高度，恒定
 */
+ (CGFloat)screenHeight;

/**
 适配比例
 */
+ (CGFloat)screenScale;

/**
 当前设备屏幕边界
 */
- (CGRect)currentBounds NS_EXTENSION_UNAVAILABLE_IOS("");

- (CGRect)boundsForOrientation:(UIInterfaceOrientation)orientation;
@end

NS_ASSUME_NONNULL_END
