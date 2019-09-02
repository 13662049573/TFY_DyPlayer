//
//  TFY_SmallFloatControlView.m
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/7/3.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_SmallFloatControlView.h"

@interface TFY_SmallFloatControlView ()
@property (nonatomic, strong) UIButton *closeBtn;
@end

@implementation TFY_SmallFloatControlView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.closeBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.bounds.size.width;
    
    min_x = min_view_w-20;
    min_y = -10;
    min_w = 30;
    min_h = min_w;
    self.closeBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
}

- (void)closeBtnClick:(UIButton *)sender {
    if (self.closeClickCallback) self.closeClickCallback();
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = tfy_button();
        _closeBtn.tfy_image(@"videoImages.bundle/close", UIControlStateNormal).tfy_action(self, @selector(closeBtnClick:));
    }
    return _closeBtn;
}

@end
