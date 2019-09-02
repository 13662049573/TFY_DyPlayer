//
//  TFY_SpeedView.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/19.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_SpeedView.h"

@interface TFY_SpeedView ()
@property(nonatomic , strong)TFY_StackView *stackView;
@end

@implementation TFY_SpeedView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"videoImages.bundle/bottom_shadow"];
        self.layer.contents = (id)image.CGImage;
        
        [self addSubview:self.stackView];
        [self.stackView tfy_AutoSize:0 top:0 right:0 bottom:0];
        
        NSArray *titleArr = @[@"0.5X",@"0.75X",@"1.0X",@"1.25X",@"1.5X",@"2X"];
        [titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            UIButton *button = tfy_button().tfy_text(titleArr[idx]).tfy_font(14).tfy_action(self,@selector(buttonClick:));
            [button setTitleColor:[UIColor tfy_colorWithHex:LCColor_B5] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor tfy_colorWithHex:LCColor_A1] forState:UIControlStateSelected];
            button.tag = idx+1;
            [self.stackView addSubview:button];
            if (idx==2) {
                button.selected = YES;
            }
        }];
        
        [self.stackView tfy_StartLayout];
        
    }
    return self;
}

-(void)buttonClick:(UIButton *)btn{
    CGFloat value = 1;
    if (btn.tag == 1) value = 0.5;
    if (btn.tag == 2) value = 0.75;
    if (btn.tag == 3) value = 1;
    if (btn.tag == 4) value = 1.25;
    if (btn.tag == 5) value = 1.5;
    if (btn.tag == 6) value = 2;
    if (self.Speekback) {
        self.Speekback(value);
    }
    for (NSInteger index = 0; index < 6; index++) {
        UIButton *btn1 = (UIButton *)[self viewWithTag:1+index];
        if (btn.tag == btn1.tag) {
            btn1.selected = YES;
        }
        else{
            btn1.selected = NO;
        }
    }
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
