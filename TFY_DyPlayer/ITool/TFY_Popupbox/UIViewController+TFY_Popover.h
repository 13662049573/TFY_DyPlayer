//
//  UIViewController+TFY_Popover.h
//  TFY_CHESHI
//
//  Created by 田风有 on 2018/8/7.
//  Copyright © 2018年 田风有. All rights reserved.
//
/*  使用方法
 [self tfy_bottomPresentController:[PopoverViewController new] presentedHeight:160 completeHandle:^(BOOL presented) {
 if (presented) {
 NSLog(@"弹出了");
 }else{
 NSLog(@"消失了");
 }
 }];

 */

#import <UIKit/UIKit.h>
#import "TFY_PopoverMacro.h"
#import "TFY_PopoverAnimator.h"

@interface UIViewController (TFY_Popover)

@property(nonatomic,strong)TFY_PopoverAnimator        *popoverAnimator;

- (void)tfy_bottomPresentController:(UIViewController *)vc presentedHeight:(CGFloat)height completeHandle:(TFY_CompleteHandle)completion;

- (void)tfy_centerPresentController:(UIViewController *)vc presentedSize:(CGSize)size completeHandle:(TFY_CompleteHandle)completion;

@end
