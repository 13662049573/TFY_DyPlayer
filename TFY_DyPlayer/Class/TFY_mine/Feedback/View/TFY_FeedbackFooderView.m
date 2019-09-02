//
//  TFY_FeedbackFooderView.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/18.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_FeedbackFooderView.h"

@interface TFY_FeedbackFooderView ()
@property(nonatomic , strong)UIButton *btn;
@end

@implementation TFY_FeedbackFooderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor tfy_colorWithHex:LCColor_B5];
        [self addSubview:self.btn];
        self.btn.tfy_Center(0, 0).tfy_LeftSpace(50).tfy_RightSpace(50).tfy_Height(50);
    }
    return self;
}

-(UIButton *)btn{
    if (!_btn) {
        _btn = tfy_button().tfy_title(@"提交",@"ffffff",15).tfy_alAlignment(1).tfy_action(self,@selector(btnClick)).tfy_backgroundColor(LCColor_A1,1).tfy_cornerRadius(10);
    }
    return _btn;
}
-(void)btnClick{
    [TFY_ProgressHUD showSuccessWithStatus:@"数据提交成功，我们会很快做出反馈，谢谢你的支持！"];
}

@end
