//
//  TFY_QuickregistrationFooderView.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/25.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_QuickregistrationFooderView.h"

@interface TFY_QuickregistrationFooderView ()
@property(nonatomic , strong)UIButton *carryout_btn;
@end

@implementation TFY_QuickregistrationFooderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.carryout_btn];
        self.carryout_btn.tfy_Center(0, 0).tfy_LeftSpace(30).tfy_RightSpace(30).tfy_Height(50);
    }
    return self;
}

-(void)setButtombool:(BOOL)buttombool{
    _buttombool = buttombool;
    
    self.carryout_btn.enabled = _buttombool;
    if (_buttombool) {
        self.carryout_btn.tfy_backgroundColor(LCColor_A1, 1);
    }
    else{
        self.carryout_btn.tfy_backgroundColor(LCColor_A1, 0.7);
    }
}


-(UIButton *)carryout_btn{
    if (!_carryout_btn) {
        _carryout_btn = tfy_button();
        _carryout_btn.tfy_backgroundColor(LCColor_A1, 0.7).tfy_title(@"完成",UIControlStateNormal, LCColor_B5,UIControlStateNormal, [UIFont systemFontOfSize:15]).tfy_cornerRadius(25).tfy_action(self, @selector(carryout_btnCliick),UIControlEventTouchUpInside);
    }
    return _carryout_btn;
}

-(void)carryout_btnCliick{
    if (self.carryoutBlock) {
        self.carryoutBlock();
    }
}
@end
