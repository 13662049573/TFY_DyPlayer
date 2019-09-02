//
//  TFY_mineReusableView.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/9.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_mineReusableView.h"

@interface TFY_mineReusableView ()
@property(nonatomic , strong)UIImageView *back_imageView;

@property(nonatomic , strong)UIButton *phone_btn;

@end

@implementation TFY_mineReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor tfy_colorWithHex:LCColor_B5];
        
        [self addSubview:self.back_imageView];
        self.back_imageView.tfy_LeftSpace(0).tfy_TopSpace(0).tfy_RightSpace(0).tfy_Height(148);
        
        [self addSubview:self.toux_imageView];
        self.toux_imageView.tfy_CenterX(0).tfy_CenterY(0).tfy_size(70, 70);
        
        [self addSubview:self.phone_btn];
        self.phone_btn.tfy_LeftSpace(60).tfy_TopSpaceToView(20, self.toux_imageView).tfy_RightSpace(60).tfy_Height(50);
        
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"username" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
            NSString *username = [TFY_CommonUtils getStrValueInUDWithKey:@"username"];
            if (![TFY_CommonUtils judgeIsEmptyWithString:username]) {
                self.phone_btn.tfy_text(username);
                self.phone_btn.enabled = NO;
            }
            else{
                self.phone_btn.tfy_text(@"登录/注册");
                self.phone_btn.enabled = YES;
            }
        }];
    }
    return self;
}

-(void)setName_string:(NSString *)name_string{
    _name_string = name_string;
    
    self.phone_btn.tfy_text(_name_string);
}


-(UIImageView *)back_imageView{
    if (!_back_imageView) {
        _back_imageView = tfy_imageView();
//        _back_imageView.backgroundColor =[UIColor tfy_colorWithHex:LCColor_A1];
        _back_imageView.tfy_imge(@"wo_top_bg");
    }
    return _back_imageView;
}

-(UIImageView *)toux_imageView{
    if (!_toux_imageView) {
        _toux_imageView = tfy_imageView().tfy_action(self,@selector(toxuimageViewClick));
        NSData *data = [TFY_CommonUtils getdataValueInUDWithKey:@"image"];
        if (data!=nil) {
            UIImage *images = [UIImage imageWithData:data];
            _toux_imageView.image = images;
        }
        else{
            _toux_imageView.tfy_imge(@"my_head_portrait");
        }
    }
    return _toux_imageView;
}

-(UIButton *)phone_btn{
    if (!_phone_btn) {
        _phone_btn = tfy_button();
        _phone_btn.tfy_textcolor(LCColor_B1).tfy_text(@"登录/注册").tfy_alAlignment(1).tfy_font(19).tfy_action(self, @selector(phone_btnClick:));
        NSString *username = [TFY_CommonUtils getStrValueInUDWithKey:@"username"];
        if (![TFY_CommonUtils judgeIsEmptyWithString:username]) {
            _phone_btn.tfy_text(username);
            _phone_btn.enabled = NO;
        }
        else{
            _phone_btn.tfy_text(@"登录/注册");
            _phone_btn.enabled = YES;
        }
    }
    return _phone_btn;
}
-(void)phone_btnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(HerderDelegateClick:)]) {
        [self.delegate HerderDelegateClick:self];
    }
}

-(void)toxuimageViewClick{
    if ([self.delegate respondsToSelector:@selector(toux_imageView:)]) {
        [self.delegate toux_imageView:self];
    }
}
@end
