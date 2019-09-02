//
//  TFY_LoginpasswordfastView.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/24.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_LoginpasswordfastView.h"

@interface TFY_LoginpasswordfastView ()
@property(nonatomic , strong)UIButton *login_btn,*passwlord_btn,*fast_btn;
@end

@implementation TFY_LoginpasswordfastView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.login_btn];
        self.login_btn.tfy_LeftSpace(30).tfy_TopSpace(10).tfy_RightSpace(30).tfy_Height(50);
        
        [self addSubview:self.fast_btn];
        self.fast_btn.tfy_LeftSpace(0).tfy_TopSpaceToView(10, self.login_btn).tfy_size(Width_W/2-40, 40);
        
        [self addSubview:self.passwlord_btn];
        self.passwlord_btn.tfy_RightSpace(0).tfy_TopSpaceToView(10, self.login_btn).tfy_size(Width_W/2-40, 40);
    }
    return self;
}

-(void)setButtombool:(BOOL)buttombool{
    _buttombool = buttombool;
    
    self.login_btn.enabled = _buttombool;
    if (_buttombool) {
        self.login_btn.tfy_backgroundColor(LCColor_A1, 1);
    }
    else{
       self.login_btn.tfy_backgroundColor(LCColor_A1, 0.7);
    }
}

-(UIButton *)login_btn{
    if (!_login_btn) {
        _login_btn = tfy_button();
        _login_btn.tfy_backgroundColor(LCColor_A1, 0.7).tfy_alAlignment(1).tfy_borders(1, LCColor_B5).tfy_cornerRadius(25).tfy_action(self, @selector(login_btnClick:)).tfy_title(@"登录", LCColor_B5, 15);
        _login_btn.tag = 100;
    }
    return _login_btn;
}

-(UIButton *)fast_btn{
    if (!_fast_btn) {
        _fast_btn = tfy_button();
        _fast_btn.tfy_title(@"快速注册", LCColor_A1, 14).tfy_alAlignment(0).tfy_action(self, @selector(login_btnClick:));
        _fast_btn.tag = 101;
    }
    return _fast_btn;
}

-(UIButton *)passwlord_btn{
    if (!_passwlord_btn) {
        _passwlord_btn = tfy_button();
        _passwlord_btn.tfy_title(@"找回密码", LCColor_A1, 14).tfy_alAlignment(2).tfy_action(self, @selector(login_btnClick:));
        _passwlord_btn.tag = 102;
    }
    return _passwlord_btn;
}


-(void)login_btnClick:(UIButton *)btn{
    if (btn.tag == 100) {
        self.login_btn.hidden = YES;
        [self.login_btn show];
    }
    if (self.fastBlock) {
        self.fastBlock(btn.tag);
    }
}

@end
