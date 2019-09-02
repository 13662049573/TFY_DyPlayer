//
//  TFY_TabBarController.m
//  TFY_AutoLayoutModelTools
//
//  Created by 田风有 on 2019/5/14.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "TFY_TabBarController.h"
#import <objc/runtime.h>
#import "TFY_TabBarItem.h"

/// iPhoneX  iPhoneXS  iPhoneXS Max  iPhoneXR 机型判断
#define tabbar_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ((NSInteger)(([[UIScreen mainScreen] currentMode].size.height/[[UIScreen mainScreen] currentMode].size.width)*100) == 216) : NO)

@interface UIViewController (TFY_TabBarControllerItemInternal)

- (void)tfy_setTabBarController:(TFY_TabBarController *)tabBarController;

@end

@interface TFY_TabBarController ()
@property(nonatomic, strong)UIView *contentView;
@property(nonatomic, strong, readwrite)TFY_TabBar *tabBar;
@property(nonatomic, assign)BOOL selected;
@end

@implementation TFY_TabBarController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setSelectedIndex:self.selectedIndex];
    
    [self setTabBarHidden:self.isTabBarHidden animated:YES Hidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.tabBar];
}

//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    UIInterfaceOrientationMask orientationMask = UIInterfaceOrientationMaskAll;
//    for (UIViewController *viewController in [self viewControllers]) {
//        if (![viewController respondsToSelector:@selector(supportedInterfaceOrientations)]) {
//            return UIInterfaceOrientationMaskPortrait;
//        }
//
//        UIInterfaceOrientationMask supportedOrientations = [viewController supportedInterfaceOrientations];
//
//        if (orientationMask > supportedOrientations) {
//            orientationMask = supportedOrientations;
//        }
//    }
//    return orientationMask;
//}

// 是否支持自动转屏
- (BOOL)shouldAutorotate {
    return YES;
}
// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault; // your own style
}

- (BOOL)prefersStatusBarHidden {
    return YES; // your own visibility code
}

- (UIViewController *)selectedViewController {
    return [[self viewControllers] objectAtIndex:[self selectedIndex]];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (selectedIndex >= self.viewControllers.count) {return;}
    
    if ([self selectedViewController]) {
        [[self selectedViewController] willMoveToParentViewController:nil];
        [[[self selectedViewController] view] removeFromSuperview];
        [[self selectedViewController] removeFromParentViewController];
    }
    _selectedIndex = selectedIndex;
    [[self tabBar] setSelectedItem:[[self tabBar] items][selectedIndex]];
    
    [self setSelectedViewController:[[self viewControllers] objectAtIndex:selectedIndex]];
    
    [self addChildViewController:[self selectedViewController]];
    
    [[[self selectedViewController] view] setFrame:[[self contentView] bounds]];
    
    [[self contentView] addSubview:[[self selectedViewController] view]];
    
    [[self selectedViewController] didMoveToParentViewController:self];
}

-(void)setViewControllers:(NSArray<UIViewController *> *)viewControllers{
    
    if (viewControllers && [viewControllers isKindOfClass:[NSArray class]]) {

        _viewControllers = [viewControllers copy];

        NSMutableArray *tabBarItems = [[NSMutableArray alloc] init];

        for (UIViewController *viewController in viewControllers) {
            
            TFY_TabBarItem *tabBarItem = [[TFY_TabBarItem alloc] init];
            [tabBarItem setTitle:viewController.title];
            [tabBarItems addObject:tabBarItem];
            [viewController tfy_setTabBarController:self];
        }

        [[self tabBar] setItems:tabBarItems];
    }
    else{
        for (UIViewController *viewController in _viewControllers) {
            [viewController tfy_setTabBarController:nil];
        }

        _viewControllers = nil;
    }
}

- (NSInteger)indexForViewController:(UIViewController *)viewController {
    UIViewController *searchedController = viewController;
    if ([searchedController navigationController]) {
        searchedController = [searchedController navigationController];
    }
    return [[self viewControllers] indexOfObject:searchedController];
}

- (TFY_TabBar *)tabBar {
    if (!_tabBar) {
        _tabBar = [[TFY_TabBar alloc] init];
        _tabBar.backgroundColor = [UIColor clearColor];
        _tabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        [_tabBar setDelegate:self];
    }
    return _tabBar;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _contentView;
}

-(void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated Hidden:(BOOL)hid_den{
    _tabBarHidden = hidden;
    
    __weak TFY_TabBarController *weakSelf = self;
    
    void (^block)(void) = ^{
        CGSize viewSize = weakSelf.view.bounds.size;
        CGFloat tabBarStartingY = viewSize.height;
        CGFloat contentViewHeight = viewSize.height;
        CGFloat tabBarHeight = CGRectGetHeight([[weakSelf tabBar] frame]);
        
        if (!tabBarHeight) {
            tabBarHeight = tabbar_iPhoneX? 59 : 49;
        }
        
        if (!self->_tabBarHidden) {
            tabBarStartingY = viewSize.height - tabBarHeight;
            if (![[weakSelf tabBar] isTranslucent]) {
                contentViewHeight -= ([[weakSelf tabBar] minimumContentHeight] ?: tabBarHeight);
            }
            [[weakSelf tabBar] setHidden:NO];
        }
        
        [[weakSelf tabBar] setFrame:CGRectMake(0, tabBarStartingY, viewSize.width, tabBarHeight)];
    };
    
    void (^completion)(BOOL) = ^(BOOL finished){
        if (hidden) {
            if (hid_den==NO) {
                [[weakSelf tabBar] setHidden:NO];
                
            }
            else{
                [[weakSelf tabBar] setHidden:YES];
                
            }
            
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:0.0 animations:block completion:completion];
    } else {
        block();
        completion(YES);
    }
    
}

- (void)imgAnimate:(UIButton *)btn{
    
    UIView *view=btn.subviews[0];
    
    [UIView animateWithDuration:0.1 animations:
     ^(void){
         
         view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.8, 0.8);
         
         
     } completion:^(BOOL finished){//do other thing
         [UIView animateWithDuration:0.2 animations:
          ^(void){
              
              view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.1, 1.1);
              
          } completion:^(BOOL finished){//do other thing
              [UIView animateWithDuration:0.1 animations:
               ^(void){
                   
                   view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1,1);
                   
                   
               } completion:^(BOOL finished){//do other thing
               }];
          }];
     }];
    
    
}

- (void)setTabBarHidden:(BOOL)hidden {
    [self setTabBarHidden:hidden animated:YES Hidden:NO];
}

#pragma mark - RDVTabBarDelegate

- (BOOL)tabBar:(TFY_TabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index tabBarItem:(TFY_TabBarItem *)item addWithisMenuShow:(BOOL)isMenuShow{
    if ([[self delegate] respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) {
        if (![[self delegate] tabBarController:self shouldSelectViewController:[self viewControllers][index]]) {
            return NO;
        }
    }
    
    if ([self selectedViewController] == [self viewControllers][index]) {
        if ([[self selectedViewController] isKindOfClass:[UINavigationController class]]) {
            UINavigationController *selectedController = (UINavigationController *)[self selectedViewController];
            
            if ([selectedController topViewController] != [selectedController viewControllers][0]) {
                [selectedController popToRootViewControllerAnimated:YES];
            }
        }
        
        return NO;
    }
    
    return YES;
}

- (void)tabBar:(TFY_TabBar *)tabBar didSelectItemAtIndex:(NSInteger)index tabBarItem:(TFY_TabBarItem *)item addWithisMenuShow:(BOOL)isMenuShow{
    if (index < 0 || index >= [[self viewControllers] count]) {
        return;
    }
    
    [self setSelectedIndex:index];
    
    if ([[self delegate] respondsToSelector:@selector(tabBarController:didSelectViewController:)]) {
        [[self delegate] tabBarController:self didSelectViewController:[self viewControllers][index]];
    }
    self.selectedIndex=index;
}

@end

#pragma mark - UIViewController+RDVTabBarControllerItem

@implementation UIViewController (TFY_TabBarControllerItemInternal)

- (void)tfy_setTabBarController:(TFY_TabBarController *)tabBarController {
    objc_setAssociatedObject(self, @selector(tfy_tabBarController), tabBarController, OBJC_ASSOCIATION_ASSIGN);
}

@end

@implementation UIViewController (TFY_TabBarControllerItem)

- (TFY_TabBarController *)tfy_tabBarController {
    TFY_TabBarController *tabBarController = objc_getAssociatedObject(self, @selector(tfy_tabBarController));
    
    if (!tabBarController && self.parentViewController) {
        tabBarController = [self.parentViewController tfy_tabBarController];
    }
    
    return tabBarController;
}

- (TFY_TabBarItem *)tfy_tabBarItem {
    TFY_TabBarController *tabBarController = [self tfy_tabBarController];
    NSInteger index = [tabBarController indexForViewController:self];
    return [[[tabBarController tabBar] items] objectAtIndex:index];
}

- (void)tfy_setTabBarItem:(TFY_TabBarItem *)tabBarItem {
    TFY_TabBarController *tabBarController = [self tfy_tabBarController];
    
    if (!tabBarController) {
        return;
    }
    
    TFY_TabBar *tabBar = [tabBarController tabBar];
    NSInteger index = [tabBarController indexForViewController:self];
    
    NSMutableArray *tabBarItems = [[NSMutableArray alloc] initWithArray:[tabBar items]];
    [tabBarItems replaceObjectAtIndex:index withObject:tabBarItem];
    [tabBar setItems:tabBarItems];
}

@end
