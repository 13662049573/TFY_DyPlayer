//
//  TFY_mineViewTwoViewCell.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/9.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_mineViewTwoViewCell.h"
#import "TFY_ColorSwitch.h"

@interface TFY_mineViewTwoViewCell ()
@property(nonatomic , strong)UIImageView *pic_imageView,*arrow_imageView;

@property(nonatomic , strong)UILabel *title_label,*cache_label;

@property(nonatomic , strong)UIView *lin_View;
/**
 *  账单状态
 */
@property(nonatomic , strong)TFY_ColorSwitch *Switch;
@end

@implementation TFY_mineViewTwoViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.pic_imageView];
        self.pic_imageView.tfy_LeftSpace(20).tfy_CenterY(0).tfy_size(24, 24);
        
        [self.contentView addSubview:self.title_label];
        self.title_label.tfy_LeftSpaceToView(10, self.pic_imageView).tfy_CenterY(0).tfy_RightSpace(50).tfy_Height(30);
        
        [self.contentView addSubview:self.arrow_imageView];
        self.arrow_imageView.tfy_RightSpace(20).tfy_CenterY(0).tfy_size(21, 21);
        
        [self.contentView addSubview:self.lin_View];
        self.lin_View.tfy_LeftSpace(20).tfy_BottomSpace(0).tfy_RightSpace(20).tfy_Height(0.5);
        
        [self.contentView addSubview:self.cache_label];
        self.cache_label.tfy_RightSpace(20).tfy_TopSpace(0).tfy_BottomSpace(0).tfy_Width(Width_W/2);
    }
    return self;
}

-(void)setModels:(Mineitems *)models{
    _models = models;
    
    self.pic_imageView.tfy_imge(_models.image_str);
    
    self.title_label.tfy_text(_models.title_str);
    
    if (![TFY_CommonUtils judgeIsEmptyWithString:_models.arrow_str]) {
        self.arrow_imageView.tfy_imge(_models.arrow_str);
    }
   
    self.Switch.on = _models.whether;
}

-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
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
        _title_label.tfy_textcolor(LCColor_B1, 1).tfy_fontSize(15).tfy_alignment(0);
    }
    return _title_label;
}

-(UILabel *)cache_label{
    if (!_cache_label) {
        _cache_label = tfy_label();
        _cache_label.tfy_textcolor(LCColor_B1, 1).tfy_fontSize(15).tfy_alignment(2);
    }
    return _cache_label;
}

-(UIImageView *)arrow_imageView{
    if (!_arrow_imageView) {
        _arrow_imageView = tfy_imageView();
    }
    return _arrow_imageView;
}

-(UIView *)lin_View{
    if (!_lin_View) {
        _lin_View = [UIView new];
        _lin_View.backgroundColor = [UIColor tfy_colorWithHex:@"e8e8e8"];
        
    }
    return _lin_View;
}

@end
