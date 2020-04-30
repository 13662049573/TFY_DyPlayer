//
//  TFY_PersonalinformatiolHerderView.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/18.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_PersonalinformatiolHerderView.h"

#define ico_ofie 70

@interface TFY_PersonalinformatiolHerderView ()

@property(nonatomic , strong)UIImageView *tuxun_imageView;

@property(nonatomic , strong)UILabel *name_label,*title_label,*desc_label;

@property(nonatomic , strong)UIProgressView *progess;
@end

@implementation TFY_PersonalinformatiolHerderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor tfy_colorWithHex:LCColor_B5];
        
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"progess" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        
            [self.progess setProgress:[x.object floatValue] animated:YES];
            self.desc_label.tfy_text([NSString stringWithFormat:@"资料完成度%.0f",self.progess.progress*100]);
        }];
    
        [self addSubview:self.tuxun_imageView];
        self.tuxun_imageView.tfy_LeftSpace(20).tfy_CenterY(0).tfy_size(ico_ofie, ico_ofie);
        
        [self addSubview:self.name_label];
        self.name_label.tfy_LeftSpaceToView(10, self.tuxun_imageView).tfy_TopSpace(10).tfy_RightSpace(20).tfy_Height(25);
        
        [self addSubview:self.title_label];
        self.title_label.tfy_LeftSpaceToView(10, self.tuxun_imageView).tfy_TopSpaceToView(0, self.name_label).tfy_RightSpace(20).tfy_Height(20);
        
        [self addSubview:self.desc_label];
        self.desc_label.tfy_LeftSpaceToView(10, self.tuxun_imageView).tfy_TopSpaceToView(0, self.title_label).tfy_RightSpace(20).tfy_BottomSpace(5);
        
        [self addSubview:self.progess];
        self.progess.tfy_LeftSpace(0).tfy_BottomSpace(0).tfy_RightSpace(0).tfy_Height(5);
        
    }
    return self;
}

-(UIImageView *)tuxun_imageView{
    if (!_tuxun_imageView) {
        _tuxun_imageView = tfy_imageView().tfy_cornerRadius(ico_ofie/2);
        NSData *data = [TFY_CommonUtils getdataValueInUDWithKey:@"image"];
        if (data!=nil) {
            _tuxun_imageView.image = [UIImage imageWithData:data];
        }
        else{
            _tuxun_imageView.tfy_imge(@"my_head_portrait");
        }
    }
    return _tuxun_imageView;
}

-(UILabel *)name_label{
    if (!_name_label) {
        _name_label = tfy_label();
        _name_label.tfy_textcolor(LCColor_B1, 1).tfy_fontSize([UIFont systemFontOfSize:15]).tfy_alignment(0);
        NSString *username = [TFY_CommonUtils getStrValueInUDWithKey:@"username"];
        if (![TFY_CommonUtils judgeIsEmptyWithString:username]) {
            _name_label.tfy_text(username);
        }
        else{
            _name_label.tfy_text(@"暂时没有名称或手机号!");
        }
    }
    return _name_label;
}

-(UILabel *)title_label{
    if (!_title_label) {
        _title_label = tfy_label();
        _title_label.tfy_textcolor(LCColor_B3, 1).tfy_fontSize([UIFont systemFontOfSize:13]).tfy_alignment(0).tfy_text(@"你还不是会员");
    }
    return _title_label;
}

-(UILabel *)desc_label{
    if (!_desc_label) {
        _desc_label = tfy_label();
        _desc_label.tfy_textcolor(LCColor_B3, 1).tfy_fontSize([UIFont systemFontOfSize:13]).tfy_alignment(0).tfy_numberOfLines(0).tfy_text(@"资料完成度0，完成绑定手机等后面信息，每完成一项数据，完成度增加百分之二十，全部完成可以获取12元/月优惠开通VIP");
    }
    return _desc_label;
}

-(UIProgressView *)progess{
    if (!_progess) {
        _progess = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progess.progress = 0.2;
        _progess.progressTintColor = [UIColor tfy_colorWithHex:LCColor_A1];
    }
    return _progess;
}
@end
