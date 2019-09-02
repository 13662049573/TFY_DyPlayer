//
//  TFY_PopoverAnimator.m
//  TFY_CHESHI
//
//  Created by 田风有 on 2018/8/7.
//  Copyright © 2018年 田风有. All rights reserved.
//

#import "TFY_PopoverAnimator.h"
#import "TFY_PopoverMacro.h"
#import "TFY_PresentationController.h"

#define kAnimationDuration 0.3

@interface TFY_PopoverAnimator()
{
    BOOL                       _isPresented;
    CGSize                     _presentedSize;
}
@property(nonatomic,strong)TFY_PresentationController  *presentationController;
@property(nonatomic,copy)  TFY_CompleteHandle           completeHandle;
@property(nonatomic,assign)TFY_PopoverType              popoverType;
@property(nonatomic,assign)CGFloat                    presentedHeight;


@end

@implementation TFY_PopoverAnimator
+ (instancetype)popoverAnimatorWithStyle:(TFY_PopoverType )popoverType completeHandle:(TFY_CompleteHandle)completeHandle{
    TFY_PopoverAnimator *popoverAnimator = [[TFY_PopoverAnimator alloc] init];
    popoverAnimator.popoverType = popoverType;
    popoverAnimator.completeHandle = completeHandle;
    return popoverAnimator;
}

#pragma mark - <UIViewControllerTransitioningDelegatere>

- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source{
    TFY_PresentationController *presentation = [[TFY_PresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    presentation.popoverType = self.popoverType;
    if (self.popoverType == TFY_PopoverTypeAlert) {
        presentation.presentedSize = _presentedSize;
    }else{
        presentation.presentedHeight = self.presentedHeight;
    }
    self.presentationController = presentation;
    return presentation;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    _isPresented = YES;
    !self.completeHandle?:self.completeHandle(_isPresented);
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    _isPresented = NO;
    !self.completeHandle? :self.completeHandle(_isPresented);
    return self;
}

#pragma mark - <UIViewControllerAnimatedTransitioning>

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return kAnimationDuration;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    _isPresented?[self animationForPresentedView:transitionContext]:[self animationForDismissedView:transitionContext];
}

#pragma mark - animationMethod
// Presented
- (void)animationForPresentedView:(nonnull id<UIViewControllerContextTransitioning>)transitionContext{
    UIView *presentedView = [transitionContext viewForKey:UITransitionContextToViewKey];
    [transitionContext.containerView addSubview:presentedView];
    self.presentationController.coverView.alpha = 0.0f;
    // 设置阴影
    transitionContext.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    transitionContext.containerView.layer.shadowOffset = CGSizeMake(0, 5);
    transitionContext.containerView.layer.shadowOpacity = 0.5f;
    transitionContext.containerView.layer.shadowRadius = 10.0f;
    
    WeakSelf(weakSelf)
    if (self.popoverType == TFY_PopoverTypeAlert) {
        presentedView.alpha = 0.0f;
        presentedView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        // 动画弹出
        [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            weakSelf.presentationController.coverView.alpha = 1.0f;
            presentedView.alpha = 1.0f;
            presentedView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }else{
        presentedView.transform = CGAffineTransformMakeTranslation(0, _presentedHeight);
        [UIView animateWithDuration:kAnimationDuration animations:^{
            weakSelf.presentationController.coverView.alpha = 1.0f;
            presentedView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    
}
// Dismissed
- (void)animationForDismissedView:(nonnull id<UIViewControllerContextTransitioning>)transitionContext{
    UIView *presentedView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    WeakSelf(weakSelf)
    if (self.popoverType == TFY_PopoverTypeAlert) {
        // 消失
        [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            weakSelf.presentationController.coverView.alpha = 0.0f;
            presentedView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [presentedView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }else{
        [UIView animateWithDuration:kAnimationDuration animations:^{
            weakSelf.presentationController.coverView.alpha = 0.0f;
            presentedView.transform = CGAffineTransformMakeTranslation(0, weakSelf.presentedHeight);
        } completion:^(BOOL finished) {
            [presentedView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }
}

#pragma mark - Setting
- (void)setBottomViewHeight:(CGFloat)height{
    _presentedHeight = height;
}

- (void)setCenterViewSize:(CGSize)size{
    _presentedSize = size;
}

@end
