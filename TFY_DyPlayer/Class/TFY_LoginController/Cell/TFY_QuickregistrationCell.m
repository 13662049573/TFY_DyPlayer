//
//  TFY_QuickregistrationCell.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/25.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_QuickregistrationCell.h"
#import "TFY_FiledtextView.h"
@interface TFY_QuickregistrationCell ()<UITextFieldDelegate>
@property(nonatomic , strong)UIView *back_View;

@property(nonatomic , strong)TFY_FiledtextView *textfiled;

@property(nonatomic , strong)UIButton *captcha_btn;

@property(nonatomic , strong)UILabel *name_label;
@end

@implementation TFY_QuickregistrationCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.back_View];
        self.back_View.tfy_LeftSpace(20).tfy_TopSpace(1).tfy_BottomSpace(1).tfy_RightSpace(20);
        
        [self.back_View addSubview:self.name_label];
        self.name_label.tfy_LeftSpace(0).tfy_TopSpace(0).tfy_BottomSpace(0).tfy_Width(65);
        
        [self.back_View addSubview:self.textfiled];
        self.textfiled.tfy_LeftSpaceToView(0, self.name_label).tfy_RightSpace(0).tfy_TopSpace(0).tfy_BottomSpace(0);
        
        [self.back_View addSubview:self.captcha_btn];
        self.captcha_btn.tfy_RightSpace(0).tfy_TopSpace(0).tfy_BottomSpace(0).tfy_Width(80);
        
        [self registLoginEvent];
    }
    return self;
}


-(void)setModels:(Quickitems *)models{
    _models = models;
    
    self.name_label.tfy_text(_models.title_str);
    
    self.textfiled.tfy_placeholder(_models.placeholder_str, [UIFont systemFontOfSize:13], [UIColor tfy_colorWithHex:LCColor_B3]).tfy_secureTextEntry(_models.secureText_bool).tfy_borderStyle(_models.borderStyle);
    
    self.captcha_btn.hidden = _models.code_bool;
    
}

-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    if (_indexPath.row==1) {
        self.textfiled.tfy_RightSpace(80);
    }
    else{
       self.textfiled.tfy_RightSpace(0);
    }
    if (_indexPath.row == 0) {
        self.textfiled.tfy_keyboardType(UIKeyboardTypeNumberPad);
    }
    else{
        self.textfiled.tfy_keyboardType(UIKeyboardTypeASCIICapable);
    }
    
}

-(UIView *)back_View{
    if (!_back_View) {
        _back_View = [UIView new];
        _back_View.backgroundColor = [UIColor tfy_colorWithHexString:LCColor_B5 alpha:0.8];
        _back_View.layer.cornerRadius = 8;
        _back_View.layer.borderWidth = 1;
        _back_View.layer.borderColor = [UIColor tfy_colorWithHex:LCColor_B6].CGColor;
    }
    return _back_View;
}


-(TFY_FiledtextView *)textfiled{
    if (!_textfiled) {
        _textfiled = [TFY_FiledtextView new];
        _textfiled.tfy_backgroundColor([UIColor clearColor]);
        _textfiled.delegate = self;
    }
    return _textfiled;
}

-(UIButton *)captcha_btn{
    if (!_captcha_btn) {
        _captcha_btn = tfy_button();
        _captcha_btn.tfy_title(@"获取验证码",UIControlStateNormal, LCColor_A1,UIControlStateNormal, [UIFont systemFontOfSize:14]).tfy_alAlignment(0).tfy_action(self, @selector(captcha_btnClick:),UIControlEventTouchUpInside).tfy_cornerRadius(8).tfy_alAlignment(1);
        _captcha_btn.CompleteBlock = ^{
          
            NSLog(@"倒计时结束");
        };
    }
    return _captcha_btn;
}

-(UILabel *)name_label{
    if (!_name_label) {
        _name_label = tfy_label();
        _name_label.tfy_textcolor(LCColor_B1, 1).tfy_fontSize([UIFont systemFontOfSize:14]).tfy_alignment(1).tfy_adjustsWidth(YES);
    }
    return _name_label;
}

-(void)registLoginEvent{
    [self.textfiled.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if (self.indexPath.row == 0) {
            if (x.length >= 11) {
                self.textfiled.tfy_text([x substringToIndex:11]);
            }
            if ([TFY_CommonUtils isPureNumber:x]) {
                if (self.phonefiledBlock) {
                    self.phonefiledBlock(self.textfiled.text);
                }
            }
        }
        if (self.indexPath.row == 1) {
            if (x.length >= 6) {
                self.textfiled.tfy_text([x substringToIndex:6]);
            }
            if (self.codefiledBlock) {
                self.codefiledBlock(x);
            }
        }
        if (self.indexPath.row == 2) {
            if (x.length >= 18) {
                
                self.textfiled.tfy_text([x substringToIndex:18]);
            }
            if (![TFY_CommonUtils stringContainsEmoji:x]) {
                if (self.passwordfiledBlock) {
                    self.passwordfiledBlock(x);
                }
            }
        }
    }];
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.indexPath.row == 0) {
        if (textField.text.length >= 11) {
            
            self.textfiled.tfy_text([textField.text substringToIndex:11]);
            if (![TFY_CommonUtils mobilePhoneNumber:self.textfiled.text]) {
                [TFY_ProgressHUD showErrorWithStatus:@"请输入正确的手机号!"];
            }
        }
    }
    if (self.indexPath.row == 1) {
        if (textField.text.length >= 6) {
            
            self.textfiled.tfy_text([textField.text substringToIndex:6]);
        }
    }
    if (self.indexPath.row == 2) {
        if (textField.text.length >= 18) {
            
            self.textfiled.tfy_text([textField.text substringToIndex:18]);
        }
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.secureTextEntry)
    {
        [textField insertText:self.textfiled.text];
    }
}



-(void)captcha_btnClick:(UIButton *)btn{
    
    [btn startTimer];
}
@end
