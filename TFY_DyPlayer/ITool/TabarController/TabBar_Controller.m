//
//  TabBar_Controller.m
//  TFY_AutoLayoutModelTools
//
//  Created by 田风有 on 2019/5/14.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "TabBar_Controller.h"
#import "TFY_recommendController.h"
#import "TFY_KoreandramaController.h"
#import "TFY_USdramaController.h"
#import "TFY_mineController.h"
@interface TabBar_Controller ()

@end

@implementation TabBar_Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupViewControllers];
    
}

- (void)setupViewControllers {
    
    TFY_NavigationController *navVC = [[TFY_NavigationController alloc]initWithRootViewController:[[TFY_recommendController alloc] init]];
    navVC.backIconImage = [[UIImage imageNamed:@"arrrow_iocn_my"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    TFY_NavigationController *navVC2 = [[TFY_NavigationController alloc]initWithRootViewController:[[TFY_KoreandramaController alloc] init]];
    navVC2.backIconImage = [[UIImage imageNamed:@"arrrow_iocn_my"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    TFY_NavigationController *navVC3 = [[TFY_NavigationController alloc]initWithRootViewController:[[TFY_USdramaController alloc] init]];
    navVC3.backIconImage = [[UIImage imageNamed:@"arrrow_iocn_my"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    TFY_NavigationController *navVC4 = [[TFY_NavigationController alloc]initWithRootViewController:[[TFY_mineController alloc] init]];
    navVC4.backIconImage = [[UIImage imageNamed:@"arrrow_iocn_my"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navVC4.barBackgroundColor = [UIColor tfy_colorWithHex:LCColor_A1];
    navVC4.titleColor = [UIColor tfy_colorWithHex:LCColor_B5];
    
    [self setViewControllers:@[navVC,navVC2,navVC3,navVC4]];
    
    [self customizeTabBarForController:self];
}
- (void)customizeTabBarForController:(TFY_TabBarController *)tabBarController{
    
    NSArray *normalImages = @[@"tabLive", @"tabYule",@"tabDiscovery",@"tabFocus"];
    NSArray *selectedImages=@[@"tabLiveHL", @"tabYuleHL",@"tabDiscoveryHL",@"tabFocusHL"];
    NSArray *titleArr = @[@"推荐",@"韩剧",@"美剧",@"我的"];
    NSInteger index = 0;
    for (TFY_TabBarItem *item in [[tabBarController tabBar] items]) {
        //背景图片和点击效果图片
        [item setBackgroundImage:[UIImage tfy_createImage:[UIColor tfy_colorWithHex:@"fafafa"]] withUnImage:[UIImage tfy_createImage:[UIColor tfy_colorWithHex:@"fafafa"]]];
        //添加按钮图片
        [item setFinishedSelectedImage:selectedImages[index] withFinishedUnselectedImage:normalImages[index]];
        
        [item tabarTitle:titleArr[index] FontOfSize:13 ColorTitle:[UIColor tfy_colorWithHex:LCColor_A1] Unselectedtitle:titleArr[index] UnTitleFontOfSize:13 UnColorTitle:[UIColor tfy_colorWithHex:LCColor_B2]];
        
        index++;
    }
}


@end
