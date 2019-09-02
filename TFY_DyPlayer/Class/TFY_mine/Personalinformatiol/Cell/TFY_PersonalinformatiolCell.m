//
//  TFY_PersonalinformatiolCell.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/18.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_PersonalinformatiolCell.h"

@interface TFY_PersonalinformatiolCell ()
@property(nonatomic , strong)UILabel *title_label,*decs_label;

@property(nonatomic , strong)UIImageView *arrow_imageViw;
@end

@implementation TFY_PersonalinformatiolCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.title_label];
        self.title_label.tfy_LeftSpace(20).tfy_CenterY(-15).tfy_RightSpace(51).tfy_Height(25);
        
        [self.contentView addSubview:self.decs_label];
        self.decs_label.tfy_LeftSpace(20).tfy_CenterY(15).tfy_RightSpace(51).tfy_Height(25);
        
        [self.contentView addSubview:self.arrow_imageViw];
        self.arrow_imageViw.tfy_RightSpace(20).tfy_CenterY(0).tfy_size(21, 21);
    }
    return self;
}

-(void)setModels:(Personitems *)models{
    _models = models;
    
    self.title_label.tfy_text(_models.title_str);
    
    self.decs_label.tfy_text(_models.desc_str);
    
    self.arrow_imageViw.tfy_imge(_models.arrow_str);
}

-(UILabel *)title_label{
    if (!_title_label) {
        _title_label = tfy_label();
        _title_label.tfy_textcolor(LCColor_B1, 1).tfy_fontSize(14).tfy_alignment(0);
    }
    return _title_label;
}

-(UILabel *)decs_label{
    if (!_decs_label) {
        _decs_label = tfy_label();
        _decs_label.tfy_textcolor(LCColor_B2, 1).tfy_fontSize(13).tfy_alignment(0);
    }
    return _decs_label;
}

-(UIImageView *)arrow_imageViw{
    if (!_arrow_imageViw) {
        _arrow_imageViw = tfy_imageView();
    }
    return _arrow_imageViw;
}

@end
