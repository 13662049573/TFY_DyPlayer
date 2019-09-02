//
//  UIDevice+Orientation.h
//  TFY_Category
//
//  Created by 田风有 on 2019/6/20.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (Orientation)

/**
 *  强制旋转设备
 *  orientation 旋转方向
 */
+ (void)setOrientation:(UIInterfaceOrientation)orientation;
@end

NS_ASSUME_NONNULL_END
