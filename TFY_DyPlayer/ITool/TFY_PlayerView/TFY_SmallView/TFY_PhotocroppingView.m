//
//  TFY_PhotocroppingView.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/19.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_PhotocroppingView.h"

@interface TFY_PhotocroppingView ()

@property(nonatomic , strong)UIButton *photo_btn,*cropping_btn;
@end

@implementation TFY_PhotocroppingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.back_View];
        self.back_View.tfy_LeftSpace(0).tfy_TopSpace(50).tfy_RightSpace(0).tfy_BottomSpace(50);
        
        
        [self.back_View addSubview:self.photo_btn];
        self.photo_btn.tfy_LeftSpace(10).tfy_CenterY(-48).tfy_size(44, 44);
        
        [self.back_View addSubview:self.cropping_btn];
        self.cropping_btn.tfy_LeftSpace(10).tfy_CenterY(48).tfy_size(44, 44);
        
    }
    return self;
}

-(void)photo_btnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (self.PhotoBlock) {
        self.PhotoBlock();
    }
}

-(void)cropping_btnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (self.croppingBlock) {
        self.croppingBlock();
    }
}

-(UIView *)back_View{
    if (!_back_View) {
        _back_View = [UIView new];
    }
    return _back_View;
}

-(UIButton *)photo_btn{
    if (!_photo_btn) {
        _photo_btn = tfy_button();
        _photo_btn.tfy_image(@"videoImages.bundle/dy_share_to_screenshot_normal", UIControlStateNormal).tfy_action(self, @selector(photo_btnClick:),UIControlEventTouchUpInside);
    }
    return _photo_btn;
}

-(UIButton *)cropping_btn{
    if (!_cropping_btn) {
        _cropping_btn = tfy_button();
        _cropping_btn.tfy_image(@"videoImages.bundle/dy_share_to_record_normal", UIControlStateNormal).tfy_action(self, @selector(cropping_btnClick:),UIControlEventTouchUpInside);
    }
    return _cropping_btn;
}
@end
