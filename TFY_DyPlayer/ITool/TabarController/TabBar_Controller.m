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
@interface TabBar_Controller ()<TfySY_TabBarDelegate>

@end

@implementation TabBar_Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加子VC
     [self addChildViewControllers];
    
    UIImage *images = [UIImage tfy_createImage:[UIColor tfy_colorWithHex:LCColor_B7]];
    [self.tabBar setShadowImage:images];
    
}

- (void)addChildViewControllers{
    TFY_NavigationController *vc1 = [self navcontroller:[TFY_recommendController new]];
    TFY_NavigationController *vc2 = [self navcontroller:[TFY_KoreandramaController new]];
    TFY_NavigationController *vc3 = [self navcontroller:[TFY_USdramaController new]];
    TFY_NavigationController *vc4 = [self navcontroller:[TFY_mineController new]];
    
    NSArray <NSDictionary *>*VCArray =
        @[@{@"vc":vc1,@"normalImg":@"tabLive",@"selectImg":@"tabLiveHL",@"itemTitle":@"推荐"},
          @{@"vc":vc2,@"normalImg":@"tabYule",@"selectImg":@"tabYuleHL",@"itemTitle":@"韩剧"},
          @{@"vc":vc3,@"normalImg":@"tabDiscovery",@"selectImg":@"tabDiscoveryHL",@"itemTitle":@"美剧"},
          @{@"vc":vc4,@"normalImg":@"tabFocus",@"selectImg":@"tabFocusHL",@"itemTitle":@"我的"}];
        NSMutableArray *tabBarConfs = @[].mutableCopy;
        NSMutableArray *tabBarVCs = @[].mutableCopy;
        [VCArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TfySY_TabBarConfigModel *model = [TfySY_TabBarConfigModel new];
            model.itemTitle = [obj objectForKey:@"itemTitle"];
            model.selectImageName = [obj objectForKey:@"selectImg"];
            model.normalImageName = [obj objectForKey:@"normalImg"];
            model.normalColor = [UIColor tfy_colorWithHex:LCColor_B2];
            model.selectColor = [UIColor tfy_colorWithHex:LCColor_A1];
            UIViewController *vc = [obj objectForKey:@"vc"];
            [tabBarVCs addObject:vc];
            [tabBarConfs addObject:model];
        }];
        self.ControllerArray = tabBarVCs;
        self.tfySY_TabBar = [[TfySY_TabBar alloc] initWithTabBarConfig:tabBarConfs];
        self.tfySY_TabBar.backgroundColor = [UIColor whiteColor];
        self.tfySY_TabBar.delegate = self;
        [self.tabBar addSubview:self.tfySY_TabBar];

}
- (void)TfySY_TabBar:(TfySY_TabBar *)tabbar selectIndex:(NSInteger)index{
    [self setSelectedIndex:index];
}

-(TFY_NavigationController *)navcontroller:(UIViewController *)vc{
    TFY_NavigationController *nav = [[TFY_NavigationController alloc] initWithRootViewController:vc];
    nav.backimage = [UIImage tfy_imageFromGradientColors:@[[UIColor tfy_colorWithHex:LCColor_A1],[UIColor tfy_colorWithHex:LCColor_A1]] gradientType:TFY_GradientTypeUprightToLowleft imageSize:CGSizeMake(Width_W, kNavBarHeight)];
    nav.backIconImage = [[UIImage imageNamed:@"arrrow_iocn_my"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.titleColor = [UIColor tfy_colorWithHex:LCColor_B5];
    return nav;
}

@end
