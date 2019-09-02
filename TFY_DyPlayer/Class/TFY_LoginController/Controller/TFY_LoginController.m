//
//  TFY_LoginController.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/23.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_LoginController.h"
#import "TFY_FiledtextView.h"
#import "TFY_InputboxView.h"
#import "TFY_LoginpasswordfastView.h"
#import "TFY_SigninwithView.h"
#import "TFY_QuickregistrationController.h"
@interface TFY_LoginController ()
@property(nonatomic , strong)TFY_InputboxView *inputView;

@property(nonatomic , strong)TFY_LoginpasswordfastView *fastView;

@property(nonatomic , strong)TFY_SigninwithView *siginView;

@property(nonatomic , copy)NSString *phone;

@property(nonatomic , copy)NSString *passwolrd;
@end

@implementation TFY_LoginController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController tfy_navigationBarTransparent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    self.navigationController.tfy_titleColor = [UIColor tfy_colorWithHex:LCColor_A1];
    self.navigationController.tfy_titleFont = [UIFont systemFontOfSize:15];
    
    self.navigationItem.leftBarButtonItem = tfy_barbtnItem().tfy_imageItem(@"top_guangbi_icon",self,@selector(close_btnClick));
    
   
    [self.view addSubview:self.inputView];
    self.inputView.tfy_LeftSpace(20).tfy_CenterY(-140).tfy_RightSpace(20).tfy_Height(120);
    
    [self.view addSubview:self.fastView];
    self.fastView.tfy_LeftSpace(20).tfy_TopSpaceToView(25, self.inputView).tfy_RightSpace(20).tfy_Height(120);
    
    [self.view addSubview:self.siginView];
    self.siginView.tfy_LeftSpace(0).tfy_TopSpaceToView(0, self.fastView).tfy_RightSpace(0).tfy_BottomSpace(0);
}

-(TFY_InputboxView *)inputView{
    if (!_inputView) {
        _inputView = [TFY_InputboxView new];
        _inputView.phone_str = @"ic_landing_nickname";
        _inputView.password_str = @"mm_normal";
        TFY_PLAYER_WS(myslef);
        _inputView.phonefiledBlock = ^(NSString * _Nonnull text) {
            myslef.phone = text;
        };
        _inputView.passwordfiledBlock = ^(NSString * _Nonnull text) {
            myslef.passwolrd = text;
        };
        
        [self registLoginEvent];
    }
    return _inputView;
}
-(void)registLoginEvent{
    
    RAC(self,fastView.buttombool) = [RACSignal combineLatest:@[RACObserve(self, phone),RACObserve(self,passwolrd)]
    reduce:^id(NSString *bankCardNo,NSString *bankNameStr){
      
      BOOL enable = (bankCardNo.length >= 11 && bankNameStr.length > 0);
      return @(enable);
      
  }];
    
    
}
-(TFY_LoginpasswordfastView *)fastView{
    if (!_fastView) {
        _fastView = [TFY_LoginpasswordfastView new];
        TFY_PLAYER_WS(myslef);
        _fastView.fastBlock = ^(NSInteger index) {
            if (index==100) {
                [myslef close_btnClick];
            }
            if (index==101) {
                TFY_QuickregistrationController *vc = [TFY_QuickregistrationController new];
                vc.quickregistrationBlock = ^(NSString * _Nonnull phone, NSString * _Nonnull code, NSString * _Nonnull passwolrd) {
                    
                    myslef.inputView.phonetext_str = phone;
                    
                };
                [myslef.navigationController pushViewController:vc animated:YES];
            }
            if (index==102) {
                
            }
        };
    }
    return _fastView;
}

-(TFY_SigninwithView *)siginView{
    if (!_siginView) {
        _siginView = [TFY_SigninwithView new];
//        TFY_PLAYER_WS(myslef);
        _siginView.signinwithBlock = ^(NSInteger index) {
            
        };
    }
    return _siginView;
}

-(void)close_btnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"username" object:nil];
}
@end
