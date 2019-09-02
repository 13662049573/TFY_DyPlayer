//
//  TFY_SigninwithView.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/24.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_SigninwithView.h"

@interface TFY_SigninwithView ()
@property(nonatomic , strong)TFY_StackView *stackView;

@property(nonatomic , strong)UIView *lin_view1,*lin_view2;

@property(nonatomic , strong)UILabel *name_label;
@end

@implementation TFY_SigninwithView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.lin_view1];
        self.lin_view1.tfy_LeftSpace(0).tfy_TopSpace(20).tfy_size(Width_W*1/3-40, 2);
        
        [self addSubview:self.lin_view2];
        self.lin_view2.tfy_RightSpace(0).tfy_TopSpace(20).tfy_size(Width_W*1/3-40, 2);
        
        [self addSubview:self.name_label];
        self.name_label.tfy_LeftSpaceToView(20, self.lin_view1).tfy_TopSpace(0).tfy_RightSpaceToView(20, self.lin_view2).tfy_Height(40);
        
        [self addSubview:self.stackView];
        self.stackView.tfy_LeftSpace(0).tfy_TopSpaceToView(10, self.name_label).tfy_RightSpace(0).tfy_Height(100);
        
        NSArray *titleArr = @[@"ic_landing_qq",@"ic_landing_wechat",@"ic_landing_microblog"];
        [titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIButton *button = tfy_button().tfy_image(titleArr[idx],UIControlStateNormal).tfy_action(self,@selector(buttonClick:));
            
            button.tag = idx+200;
            [self.stackView addSubview:button];
            
        }];
        
        [self.stackView tfy_StartLayout];
    }
    return self;
}
-(void)buttonClick:(UIButton *)btn{
    if (self.signinwithBlock) {
        self.signinwithBlock(btn.tag);
    }
}

-(UIView *)lin_view1{
    if (!_lin_view1) {
        _lin_view1 = [UIView new];
        _lin_view1.backgroundColor = [UIColor tfy_colorWithHex:LCColor_B6];
    }
    return _lin_view1;
}

-(UIView *)lin_view2{
    if (!_lin_view2) {
        _lin_view2 = [UIView new];
        _lin_view2.backgroundColor = [UIColor tfy_colorWithHex:LCColor_B6];
    }
    return _lin_view2;
}

-(UILabel *)name_label{
    if (!_name_label) {
        _name_label = tfy_label();
        _name_label.tfy_text(@"第三方账号快速登录").tfy_textcolor(LCColor_A2, 1).tfy_fontSize(18).tfy_alignment(1).tfy_adjustsWidth(YES);
    }
    return _name_label;
}

-(TFY_StackView *)stackView{
    if (!_stackView) {
        _stackView = [TFY_StackView new];
        _stackView.tfy_Edge = UIEdgeInsetsMake(1, 1, 1, 1);
        _stackView.tfy_Orientation = Horizontal;// 自动横向垂直混合布局
        _stackView.tfy_HSpace = 1;
        _stackView.tfy_VSpace = 1;
    }
    return _stackView;
}


@end
