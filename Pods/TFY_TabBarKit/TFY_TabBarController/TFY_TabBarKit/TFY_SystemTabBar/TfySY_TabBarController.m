//
//  TfySY_TabBarController.m
//  TFY_TabarController
//
//  Created by tiandengyou on 2019/11/25.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "TfySY_TabBarController.h"

@interface TfySY_TabBarController ()

@end

@implementation TfySY_TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)setControllerArray:(NSArray<UIViewController *> *)ControllerArray{
    _ControllerArray = ControllerArray;
    self.viewControllers = _ControllerArray;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    [super setSelectedIndex:selectedIndex];
    if(self.tfySY_TabBar){
        self.tfySY_TabBar.selectIndex = selectedIndex;
    }
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.tfySY_TabBar.frame = self.tabBar.bounds;
    [self.tfySY_TabBar viewDidLayoutItems];
    if ([self.vc_delegate respondsToSelector:@selector(tfySY_LayoutSubviews)]) {
        [self.vc_delegate tfySY_LayoutSubviews];
    }
}

@end
