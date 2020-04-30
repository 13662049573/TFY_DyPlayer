//
//  UIViewController+TfyCU_Tab.m
//  TFY_TabBarController
//
//  Created by tiandengyou on 2019/11/28.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "UIViewController+TfyCU_Tab.h"
#import <objc/runtime.h>

@implementation UIViewController (TfyCU_Tab)

- (NSString *)tfy_tabItemTitle {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTfy_tabItemTitle:(NSString *)tfy_tabItemTitle {
    self.tfy_tabItem.title = tfy_tabItemTitle;
    objc_setAssociatedObject(self, @selector(tfy_tabItemTitle), tfy_tabItemTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIImage *)tfy_tabItemImage {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTfy_tabItemImage:(UIImage *)tfy_tabItemImage {
    self.tfy_tabItem.image = tfy_tabItemImage;
    objc_setAssociatedObject(self, @selector(tfy_tabItemImage), tfy_tabItemImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)tfy_tabItemSelectedImage {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTfy_tabItemSelectedImage:(UIImage *)tfy_tabItemSelectedImage {
    self.tfy_tabItem.selectedImage = tfy_tabItemSelectedImage;
    objc_setAssociatedObject(self, @selector(tfy_tabItemSelectedImage), tfy_tabItemSelectedImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TfyCU_TabBarItem *)tfy_tabItem{
    TfyCU_TabBar *tabBar = self.tfy_tabBarController.tabBar;
    if (!tabBar) {
        return nil;
    }
    if (![self.tfy_tabBarController.viewControllers containsObject:self]) {
        return nil;
    }
    NSUInteger index = [self.tfy_tabBarController.viewControllers indexOfObject:self];
    return tabBar.items[index];
}

- (id<TfyCU_TabBarControllerProtocol>)tfy_tabBarController {
    if ([self.parentViewController conformsToProtocol:@protocol(TfyCU_TabBarControllerProtocol)]) {
        return (id<TfyCU_TabBarControllerProtocol>)self.parentViewController;
    }
    return nil;
}

- (void)tfy_tabItemDidSelected:(BOOL)isFirstTime {}

- (void)tfy_tabItemDidDeselected {}

- (UIScrollView *)tfy_scrollView {
    return nil;
}
@end
