//
//  TFY_mineViewCell.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/9.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_mineViewCell.h"

@interface TFY_mineViewCell ()
@property(nonatomic , strong)UIImageView *pic_imageView;

@property(nonatomic , strong)UILabel *title_label;
@end

@implementation TFY_mineViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView addSubview:self.pic_imageView];
        self.pic_imageView.tfy_CenterX(0).tfy_TopSpace(10).tfy_size(21, 21);
        
        [self.contentView addSubview:self.title_label];
        self.title_label.tfy_LeftSpace(0).tfy_TopSpaceToView(0, self.pic_imageView).tfy_RightSpace(0).tfy_BottomSpace(0);
        
    }
    return self;
}

-(void)setModels:(Mineitems *)models{
    _models = models;
    
    self.pic_imageView.tfy_imge(_models.image_str);
    
    self.title_label.tfy_text(_models.title_str);
}



-(UIImageView *)pic_imageView{
    if (!_pic_imageView) {
        _pic_imageView = tfy_imageView();
    }
    return _pic_imageView;
}

-(UILabel *)title_label{
    if (!_title_label) {
        _title_label = tfy_label();
        _title_label.tfy_textcolor(LCColor_B1, 1).tfy_fontSize([UIFont systemFontOfSize:15]).tfy_alignment(1);
    }
    return _title_label;
}

@end
