//
//  TFY_PopoverAnimator.h
//  TFY_CHESHI
//
//  Created by 田风有 on 2018/8/7.
//  Copyright © 2018年 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TFY_PopoverMacro.h"

@interface TFY_PopoverAnimator : NSObject<UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate>
@property(nonatomic,assign)CGRect       presentedFrame;
+ (instancetype)popoverAnimatorWithStyle:(TFY_PopoverType )popoverType completeHandle:(TFY_CompleteHandle)completeHandle;

- (void)setCenterViewSize:(CGSize)size;
- (void)setBottomViewHeight:(CGFloat)height;
@end
