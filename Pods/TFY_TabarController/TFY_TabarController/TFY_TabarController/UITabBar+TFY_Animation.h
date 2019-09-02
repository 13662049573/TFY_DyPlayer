//
//  UITabBar+TFY_Animation.h
//  TFY_TabarController
//
//  Created by 田风有 on 2019/7/23.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar (TFY_Animation)
@property(nonatomic, strong, readonly) NSArray *btns;
@property(nonatomic, assign, readonly) NSUInteger selectedIndex;
@end

NS_ASSUME_NONNULL_END
