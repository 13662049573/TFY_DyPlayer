//
//  TFY_SettingHerderView.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/11.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_SettingHerderView.h"

@interface TFY_SettingHerderView ()
@property(nonatomic , strong)UILabel *title_label;

@end

@implementation TFY_SettingHerderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor tfy_colorWithHex:LCColor_B7];
        
        [self addSubview:self.title_label];
        self.title_label.tfy_LeftSpace(20).tfy_TopSpace(0).tfy_RightSpace(20).tfy_BottomSpace(0);
    }
    return self;
}

-(void)setModels:(Settinggroup *)models{
    _models = models;
    
    self.title_label.tfy_text(_models.herder);
}

-(UILabel *)title_label{
    if (!_title_label) {
        _title_label = tfy_label();
        _title_label.tfy_textcolor(LCColor_B2, 1).tfy_alignment(0).tfy_fontSize([UIFont systemFontOfSize:13]);
    }
    return _title_label;
}
@end
