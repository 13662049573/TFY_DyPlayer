//
//  UIViewController+TFY_Popover.m
//  TFY_CHESHI
//
//  Created by 田风有 on 2018/8/7.
//  Copyright © 2018年 田风有. All rights reserved.
//

#import "UIViewController+TFY_Popover.h"
#import <objc/runtime.h>

static const char popoverAnimatorKey;

@implementation UIViewController (TFY_Popover)

-(TFY_PopoverAnimator *)popoverAnimator{
    return objc_getAssociatedObject(self, &popoverAnimatorKey);
}

-(void)setPopoverAnimator:(TFY_PopoverAnimator *)popoverAnimator{
    objc_setAssociatedObject(self, &popoverAnimatorKey, popoverAnimator, OBJC_ASSOCIATION_RETAIN);
}

- (void)tfy_bottomPresentController:(UIViewController *)vc presentedHeight:(CGFloat)height completeHandle:(TFY_CompleteHandle)completion{
    
    self.popoverAnimator = [TFY_PopoverAnimator popoverAnimatorWithStyle:TFY_PopoverTypeActionSheet completeHandle:completion];
    
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self.popoverAnimator;
    [self.popoverAnimator setBottomViewHeight:height];
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)tfy_centerPresentController:(UIViewController *)vc presentedSize:(CGSize)size completeHandle:(TFY_CompleteHandle)completion{
    self.popoverAnimator = [TFY_PopoverAnimator popoverAnimatorWithStyle:TFY_PopoverTypeAlert completeHandle:completion];
    [self.popoverAnimator setCenterViewSize:size];
    
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self.popoverAnimator;
    
    [self presentViewController:vc animated:YES completion:nil];
}
@end
