//
//  UITabBarItem+TFY_Animation.m
//  TFY_TabarController
//
//  Created by 田风有 on 2019/7/23.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "UITabBarItem+TFY_Animation.h"
#import <objc/runtime.h>

@implementation UITabBarItem (TFY_Animation)

// MARK: - 关联属性
- (void)setAnimation:(id<TFY_AnimationProtocol>)animation {
    
    NSAssert([animation conformsToProtocol:@protocol(TFY_AnimationProtocol)], @"UITabBarItem: animation属性必须遵守TLAnimationProtocol协议");
    objc_setAssociatedObject(self, @selector(animation), animation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<TFY_AnimationProtocol>)animation {
    return objc_getAssociatedObject(self, _cmd);
}
@end
