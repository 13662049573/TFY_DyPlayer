//
//  UIDevice+Orientation.m
//  TFY_Category
//
//  Created by 田风有 on 2019/6/20.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "UIDevice+Orientation.h"

@implementation UIDevice (Orientation)
//调用私有方法实现
+ (void)setOrientation:(UIInterfaceOrientation)orientation {
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[self currentDevice]];
    int val = orientation;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
}

@end
