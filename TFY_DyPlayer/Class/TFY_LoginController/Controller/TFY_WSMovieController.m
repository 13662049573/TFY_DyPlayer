//
//  TFY_WSMovieController.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/23.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_WSMovieController.h"
#import "TabBar_Controller.h"

@interface TFY_WSMovieController ()
@property (nonatomic, strong)UIButton *enterMainButton;
@end

@implementation TFY_WSMovieController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [TFY_CommonUtils BackstatusBarStyle:0];
    
    [self.view addSubview:self.enterMainButton];
    self.enterMainButton.tfy_LeftSpace(40).tfy_BottomSpace(kNavBarHeight-20).tfy_RightSpace(40).tfy_Height(50);
}

-(UIButton *)enterMainButton{
    if (!_enterMainButton) {
        _enterMainButton = tfy_button();
        _enterMainButton.tfy_text(@"进入应用",UIControlStateNormal).tfy_textcolor(@"ffffff",UIControlStateNormal).tfy_cornerRadius(10).tfy_alAlignment(1).tfy_borders(1, @"ffffff").tfy_action(self, @selector(enterMainAction:),UIControlEventTouchUpInside);
    }
    return _enterMainButton;
}
- (void)enterMainAction:(UIButton *)btn {
   
    TabBar_Controller *rootTabCtrl = [[TabBar_Controller alloc]init];
    self.view.window.rootViewController = rootTabCtrl;
}
@end
