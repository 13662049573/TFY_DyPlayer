//
//  TFY_PlayerBaseView.m
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/30.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_PlayerBaseView.h"

@interface TFY_PlayerBaseView ()
@property (nonatomic, weak) UIView *fitView;
@end

@implementation TFY_PlayerBaseView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // 确定您是否可以接收触摸事件
    if (self.userInteractionEnabled == NO || self.hidden == YES || self.alpha <= 0.01) return nil;
    // 确定触摸点是否遥不可及
    if (![self pointInside:point withEvent:event]) return nil;
    NSInteger count = self.subviews.count;
    for (NSInteger i = count - 1; i >= 0; i--) {
        UIView *childView = self.subviews[i];
        CGPoint childPoint = [self convertPoint:point toView:childView];
        UIView *fitView = [childView hitTest:childPoint withEvent:event];
        if (fitView) {
            return fitView;
        }
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}


@end
