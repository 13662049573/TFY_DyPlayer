//
//  TFY_MineFooderCell.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/18.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_MineFooderCell.h"

@interface TFY_MineFooderCell ()
@property(nonatomic , strong)UIImageView *pic_imageView;

@property(nonatomic , strong)UILabel *name_label,*time_label;
@end

@implementation TFY_MineFooderCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        [self addSubview:self.pic_imageView];
        self.pic_imageView.tfy_LeftSpace(0).tfy_TopSpace(0).tfy_RightSpace(0).tfy_BottomSpace(50);
        
        [self.pic_imageView addSubview:self.time_label];
        self.time_label.tfy_RightSpace(0).tfy_LeftSpace(0).tfy_BottomSpace(0).tfy_Height(25);
        
        [self addSubview:self.name_label];
        self.name_label.tfy_LeftSpace(0).tfy_RightSpace(0).tfy_TopSpaceToView(0, self.pic_imageView).tfy_BottomSpace(0);
    }
    return self;
}

-(void)setModes:(TFY_PlayerVideoModel *)modes{
    _modes = modes;
    
    [self.pic_imageView tfy_setImageWithURLString:_modes.tfy_pic placeholderImageName:@"zhnaweitu"];
    
    self.name_label.tfy_text(_modes.tfy_name);
    
    self.time_label.tfy_text([TFY_CommonUtils convertSecond2Time:(int)_modes.tfy_seconds]);
}


-(UIImageView *)pic_imageView{
    if (!_pic_imageView) {
        _pic_imageView = tfy_imageView();
        _pic_imageView.userInteractionEnabled = YES;
    }
    return _pic_imageView;
}

-(UILabel *)name_label{
    if (!_name_label) {
        _name_label = tfy_label();
        _name_label.tfy_textcolor(LCColor_B1, 1).tfy_fontSize([UIFont systemFontOfSize:12]).tfy_alignment(1).tfy_numberOfLines(0);
    }
    return _name_label;
}


-(UILabel *)time_label{
    if (!_time_label) {
        _time_label = tfy_label();
        _time_label.tfy_textcolor(LCColor_B5, 1).tfy_fontSize([UIFont systemFontOfSize:13]).tfy_alignment(1).tfy_adjustsWidth(YES).tfy_backgroundColor(@"1AA3F0", 2);
    }
    return _time_label;
}
@end
