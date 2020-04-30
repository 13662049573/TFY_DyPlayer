//
//  TFY_PlayerTopBar.m
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/26.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_PlayerTopBar.h"

@interface TFY_PlayerTopBar ()
/**
 *  返回按钮 也是 回屏按钮
 */
@property(nonatomic , strong)UIButton *arrow_btn,*report_btn;
/**
 *  标题
 */
@property(nonatomic , strong)UILabel *title_label;

@end

@implementation TFY_PlayerTopBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"videoImages.bundle/top_shadow"];
        self.layer.contents = (id)image.CGImage;
        
        [self addSubview:self.arrow_btn];
        self.arrow_btn.tfy_LeftSpace(10).tfy_CenterY(0).tfy_size(40, 40);
        
        [self addSubview:self.report_btn];
        self.report_btn.tfy_RightSpace(10).tfy_CenterY(0).tfy_size(50, 25);
        
        [self addSubview:self.title_label];
        self.title_label.tfy_LeftSpaceToView(5, self.arrow_btn).tfy_CenterY(0).tfy_RightSpaceToView(5, self.report_btn).tfy_HeightAuto();
        
    }
    return self;
}

-(void)setTitle_string:(NSString *)title_string{
    _title_string = title_string;
    
    self.title_label.tfy_text(_title_string);
}
/**
 *  返回按钮方法
 */
-(void)arrow_btnClick{
    if ([self.delegate respondsToSelector:@selector(topBarBackBtnClicked)]) {
        [self.delegate topBarBackBtnClicked];
    }
}

/**
 *  分享
 */
-(void)report_btnClick{
    if ([self.delegate respondsToSelector:@selector(report_btnClick)]) {
        [self.delegate report_btnClick];
    }
}

#pragma 懒加载 按钮

-(UIButton *)arrow_btn{
    if (!_arrow_btn) {
        _arrow_btn = tfy_button();
        _arrow_btn.tfy_image(@"videoImages.bundle/arrow_left_white", UIControlStateNormal).tfy_action(self, @selector(arrow_btnClick),UIControlEventTouchUpInside);
    }
    return _arrow_btn;
}

-(UIButton *)report_btn{
    if (!_report_btn) {
        _report_btn = tfy_button();
        _report_btn.tfy_image(@"videoImages.bundle/report", UIControlStateNormal).tfy_action(self, @selector(report_btnClick),UIControlEventTouchUpInside);
    }
    return _report_btn;
}

-(UILabel *)title_label{
    if (!_title_label) {
        _title_label = tfy_label();
        _title_label.tfy_textcolor(@"ffffff", 1).tfy_fontSize([UIFont systemFontOfSize:14]).tfy_alignment(0).tfy_text(@"标题").tfy_numberOfLines(0);
    }
    return _title_label;
}

@end
