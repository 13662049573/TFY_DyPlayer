//
//  TfyCU_TabBarController.m
//  TFY_TabBarController
//
//  Created by tiandengyou on 2019/11/28.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TfyCU_TabBarController.h"
#import "TfyCU_TabBarItem.h"

#define TFY_TabBar_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ((NSInteger)(([[UIScreen mainScreen] currentMode].size.height/[[UIScreen mainScreen] currentMode].size.width)*100) == 216) : NO)

//屏幕高
#define  TFY_TabBar_Height_H [UIScreen mainScreen].bounds.size.height
//屏幕宽
#define  TFY_TabBar_Width_W  [UIScreen mainScreen].bounds.size.width

#define kTFY_TabBar_NavBarHeight           (TFY_TabBar_iPhoneX ? 88.0 : 64.0)
#define kTFY_TabBar_NavTimebarHeight       (TFY_TabBar_iPhoneX ? 44.0 : 20.0)
#define kTFY_TabBar_BottomBarHeight        (TFY_TabBar_iPhoneX ? 34.0 : 0)
#define kTFY_TabBar_ContentHeight          (TFY_TabBar_Height_H - kTFY_TabBar_NavBarHeight-kTFY_TabBar_BottomBarHeight)

@interface TfyCU_TabBarController ()

@property(nonatomic, strong)TfyCU_TabBarView *tabContentView;
@end

@implementation TfyCU_TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
       
   [self.view addSubview:self.tabBar];
   [self.view addSubview:self.tabContentView];
}

-(void)setStyle:(ScenestobeusedStyle)Style{
    _Style = Style;
    switch (_Style) {
        case NavigationbaruseStyle:
            [self setTabBarFrame:CGSizeMake(TFY_TabBar_Width_W, 44) contentViewFrame:CGSizeMake(TFY_TabBar_Width_W, TFY_TabBar_Height_H-kTFY_TabBar_NavBarHeight) ScenestobeusedStyle:NavigationbaruseStyle];
            break;
        case TabarbaruseStyle:
            [self setTabBarFrame:CGSizeMake(TFY_TabBar_Width_W, kTFY_TabBar_NavBarHeight) contentViewFrame:CGSizeMake(TFY_TabBar_Width_W, TFY_TabBar_Height_H-kTFY_TabBar_NavBarHeight) ScenestobeusedStyle:TabarbaruseStyle];
            break;
        default:
            break;
    }
}


- (void)setTabBarFrame:(CGSize)tabBarSize contentViewFrame:(CGSize)contentViewSize ScenestobeusedStyle:(ScenestobeusedStyle)Style{
    if (self.tabContentView.headerView) {
        return;
    }
    if (Style==NavigationbaruseStyle) {
        self.tabBar.frame = CGRectMake(0, kTFY_TabBar_NavTimebarHeight, tabBarSize.width, tabBarSize.height);
        self.tabContentView.frame = CGRectMake(0, kTFY_TabBar_NavBarHeight, contentViewSize.width, contentViewSize.height);
    }
    else{
        self.tabBar.frame = CGRectMake(0, TFY_TabBar_Height_H-tabBarSize.height, tabBarSize.width, tabBarSize.height);
        self.tabContentView.frame = CGRectMake(0, 0, contentViewSize.width, contentViewSize.height);
    }
}


-(void)setViewControllers:(NSArray<UIViewController *> *)viewControllers{
    self.tabContentView.viewControllers = viewControllers;
}

- (NSArray<UIViewController *> *)viewControllers {
    return self.tabContentView.viewControllers;
}

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
    return NO; // your own visibility code
}

- (TfyCU_TabBar *)tabBar {
    return self.tabContentView.tabBar;
}

- (TfyCU_TabBarView *)tabContentView{
    if (!_tabContentView) {
        _tabContentView = [[TfyCU_TabBarView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        _tabContentView.delegate = self;
        _tabContentView.backgroundColor = [UIColor clearColor];
        _tabContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _tabContentView;
}

@end
