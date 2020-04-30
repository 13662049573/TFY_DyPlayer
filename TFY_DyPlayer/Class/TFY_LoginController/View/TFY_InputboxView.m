//
//  TFY_InputboxView.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/24.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_InputboxView.h"
#import "TFY_FiledtextView.h"

@interface TFY_InputboxView ()<UITextFieldDelegate>
@property(nonatomic , strong)TFY_FiledtextView *phone_View,*password_View;
@end

@implementation TFY_InputboxView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor tfy_colorWithHexString:LCColor_B5 alpha:0.8];
        self.layer.cornerRadius = 8;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor tfy_colorWithHex:LCColor_B6].CGColor;
        
        [self addSubview:self.phone_View];
        self.phone_View.tfy_LeftSpace(0).tfy_TopSpace(0).tfy_RightSpace(0).tfy_Height(59.5);
        
        [self addSubview:self.password_View];
        self.password_View.tfy_LeftSpace(0).tfy_TopSpaceToView(1, self.phone_View).tfy_RightSpace(0).tfy_BottomSpace(0);
        
        [self registLoginEvent];
    }
    return self;
}

-(void)setPhone_str:(NSString *)phone_str{
    _phone_str = phone_str;
    
    self.phone_View.tfy_lefimage(_phone_str, CGRectMake(0, 0, 22, 22));
}

-(void)setPassword_str:(NSString *)password_str{
    _password_str = password_str;
    
    self.password_View.tfy_lefimage(_password_str, CGRectMake(0, 0, 22, 22));
}

-(void)setPhonetext_str:(NSString *)phonetext_str{
    _phonetext_str = phonetext_str;
    if (![TFY_CommonUtils judgeIsEmptyWithString:_phonetext_str]) {
        self.phone_View.tfy_text(_phonetext_str);
        if (self.phonefiledBlock) {
            self.phonefiledBlock(_phonetext_str);
        }
    }
}

-(TFY_FiledtextView *)phone_View{
    if (!_phone_View) {
        _phone_View = [TFY_FiledtextView new];
        _phone_View.tfy_placeholder(@"注册手机号", [UIFont systemFontOfSize:14], [UIColor tfy_colorWithHex:LCColor_B4]).tfy_keyboardType(UIKeyboardTypeNumberPad).tfy_borderStyle(UITextBorderStyleRoundedRect);
        _phone_View.delegate = self;
    }
    return _phone_View;
}
-(TFY_FiledtextView *)password_View{
    if (!_password_View) {
        _password_View = [TFY_FiledtextView new];
        _password_View.tfy_placeholder(@"注册密码", [UIFont systemFontOfSize:14], [UIColor tfy_colorWithHex:LCColor_B4]).tfy_keyboardType(UIKeyboardTypeASCIICapable).tfy_secureTextEntry(YES).tfy_borderStyle(UITextBorderStyleRoundedRect);
        _password_View.delegate = self;
    }
    return _password_View;
}
-(void)registLoginEvent{
    [self.phone_View.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if (self.phone_View.text.length >= 11) {
            self.phone_View.tfy_text([self.phone_View.text substringToIndex:11]);
        }
        if ([TFY_CommonUtils isPureNumber:self.phone_View.text]) {
            if (self.phonefiledBlock) {
                self.phonefiledBlock(self.phone_View.text);
            }
        }
    }];
    
    [self.password_View.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if (self.password_View.text.length >= 18) {
            self.password_View.tfy_text([self.password_View.text substringToIndex:18]);
        }
        if (![TFY_CommonUtils stringContainsEmoji:self.password_View.text]) {
            if (self.passwordfiledBlock) {
                self.passwordfiledBlock(self.password_View.text);
            }
        }
    }];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.phone_View) {
        if (textField.text.length >= 11) {
            
            self.phone_View.tfy_text([textField.text substringToIndex:11]);
            if (![TFY_CommonUtils mobilePhoneNumber:self.phone_View.text]) {
                [TFY_ProgressHUD showErrorWithStatus:@"请输入正确的手机号!"];
            }
        }
    }
    if (textField == self.password_View) {
        if (textField.text.length >= 18) {
            
            self.password_View.tfy_text([textField.text substringToIndex:18]);
        }
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.phone_View)
    {
        if (textField.secureTextEntry)
        {
            [textField insertText:self.phone_View.text];
        }
    }
    if (textField == self.password_View)
    {
        if (textField.secureTextEntry)
        {
            [textField insertText:self.password_View.text];
        }
    }
}


@end
