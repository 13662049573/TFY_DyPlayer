//
//  UIWindow+TFY_Chain.m
//  TFY_Category
//
//  Created by tiandengyou on 2020/3/27.
//  Copyright © 2020 恋机科技. All rights reserved.
//

#import "UIWindow+TFY_Chain.h"
#import <objc/message.h>
#import "UIApplication+TFY_Chain.h"

@implementation UIWindow (TFY_Chain)

- (void)showOnCurrentScene{
    [self showOnScene:[UIApplication currentScene]];
}

- (void)showOnScene:(id)scene{
    if (UIApplication.isSceneApp) {
        if (scene && [scene isKindOfClass:NSClassFromString(@"UIWindowScene")]) {
            ((void (*)(id, SEL,id))objc_msgSend)(self,sel_registerName("setWindowScene:"),scene);
        }
    }
}
@end
