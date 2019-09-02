# TFY_TabarController

使用方式 pod 'TFY_TabarController'   

需要继承父类 TFY_TabBarController


- (void)setupViewControllers {
    
    TFY_NavigationController *navVC = [[TFY_NavigationController alloc]initWithRootViewController:[[HomeController alloc] init]];
    TFY_NavigationController *navVC2 = [[TFY_NavigationController alloc]initWithRootViewController:[[MineController alloc] init]];
    
    [self setViewControllers:@[navVC, navVC2]];
    
    [self customizeTabBarForController:self];
}
- (void)customizeTabBarForController:(TFY_TabBarController *)tabBarController{
    
    NSArray *normalImages = @[@"home_iocn", @"woe_icon"];
    NSArray *selectedImages=@[@"home_icon_1", @"wode_icon_1"];
    NSArray *titleArr=@[@"首页",@"我的"];
    
    NSInteger index = 0;
    for (TFY_TabBarItem *item in [[tabBarController tabBar] items]) {
        //背景图片和点击效果图片
        [item setBackgroundSelectedImage:@"tabbar" withUnselectedImage:@"tabbar"];
        //添加文字
        [item tabarTitle:titleArr[index] FontOfSize:12 ColorTitle:[UIColor tfy_colorWithHex:@"FFC301"] Unselectedtitle:titleArr[index] UnTitleFontOfSize:12 UnColorTitle:[UIColor tfy_colorWithHex:@"323232"]];
        //添加按钮图片
        [item setFinishedSelectedImage:selectedImages[index] withFinishedUnselectedImage:normalImages[index]];
        
        index++;
    }
}
