//
//  UIApplication+TFY_Chain.h
//  TFY_Category
//
//  Created by tiandengyou on 2020/3/27.
//  Copyright © 2020 恋机科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (TFY_Chain)
/**statusBar的frame*/
+ (CGRect)statusBarFrame;

/**当前的windowScene*/
+ (id)currentScene;

/**当前windowSceneDelegate*/
+ (id)currentSceneDelegate;

/**最上面的window*/
+ (UIWindow *)currentWindow;

/**当前关键视图*/
+ (UIWindow *)currentKeyWindow;

/**当前操作的window*/
+ (UIWindow *)window;

+ (UIWindow *)keyWindow;

/**app的 delegate*/
+ (id<UIApplicationDelegate>)delegate;

/**跟控制器-- window*/
+ (__kindof UIViewController *)rootViewController;


@property (nonatomic, assign, class, readonly) BOOL isSceneApp;
/**
 * 最上层的非TabbarController和NavigationBarController的控制器
 */
+ (__kindof  UIViewController *)currentTopViewController;

+ (__kindof UINavigationController *)currentToNavgationController;
@end


@interface UIView (Navigation_Chain)

- (UINavigationController *_Nonnull)navigationController;

@end

NS_ASSUME_NONNULL_END
