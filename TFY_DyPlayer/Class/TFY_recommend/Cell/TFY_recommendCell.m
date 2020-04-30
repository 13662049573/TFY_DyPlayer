//
//  TFY_recommendCell.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/5.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_recommendCell.h"

@interface TFY_recommendCell ()

@property(nonatomic , strong)UILabel *state_label,*hits_label,*name_label,*info_label;

@property(nonatomic , strong)UIImageView *pic_imageView;
@end

@implementation TFY_recommendCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.pic_imageView];
        self.pic_imageView.tfy_LeftSpace(0).tfy_TopSpace(0).tfy_RightSpace(0).tfy_BottomSpace(40);
        
        [self.contentView addSubview:self.name_label];
        self.name_label.tfy_LeftSpace(0).tfy_TopSpaceToView(0, self.pic_imageView).tfy_RightSpace(0).tfy_HeightAuto();
        
        [self.contentView addSubview:self.hits_label];
        self.hits_label.tfy_LeftSpace(0).tfy_RightSpace(0).tfy_TopSpaceToView(0, self.name_label).tfy_BottomSpace(0);
        
        [self.pic_imageView addSubview:self.state_label];
        self.state_label.tfy_LeftSpace(0).tfy_BottomSpace(7).tfy_RightSpace(0).tfy_Height(25);
        
        [self.pic_imageView addSubview:self.info_label];
        self.info_label.tfy_RightSpace(10).tfy_TopSpace(10).tfy_size(40, 25);
        
    }
    return self;
}
//首页数据模型
-(void)setModel:(Vod *)model{
    _model = model;
    
    [self.pic_imageView tfy_setImageWithURLString:_model.pic placeholderImageName:@"zhnaweitu"];
    
    self.name_label.tfy_text(_model.name);
    
    self.hits_label.tfy_text([NSString stringWithFormat:@"播放:%@",_model.hits]);
    
    self.state_label.tfy_text(_model.state);
    
    if (![TFY_CommonUtils judgeIsEmptyWithString:_model.info]) {
        self.info_label.tfy_backgroundColor(@"1AA3F0", 1);
    }
    else{
        self.info_label.tfy_backgroundColor(@"1AA3F0", 0);
        
    }
    self.info_label.tfy_text(_model.info);
}

//更多信息模型
-(void)setDatamodel:(Data *)datamodel{
    _datamodel = datamodel;
    
    [self.pic_imageView tfy_setImageWithURLString:_datamodel.pic placeholderImageName:@"zhnaweitu"];
    
    self.name_label.tfy_text(_datamodel.name);
    
    self.hits_label.tfy_text([NSString stringWithFormat:@"播放:%@",_datamodel.hits]);
    
    self.state_label.tfy_text(_datamodel.state);
    
    if (![TFY_CommonUtils judgeIsEmptyWithString:_datamodel.info]) {
        self.info_label.tfy_backgroundColor(@"1AA3F0", 1);
    }
    else{
        self.info_label.tfy_backgroundColor(@"1AA3F0", 0);
        
    }
    self.info_label.tfy_text(_datamodel.info);
    
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

-(UILabel *)hits_label{
    if (!_hits_label) {
        _hits_label = tfy_label();
        _hits_label.tfy_textcolor(LCColor_B3, 1).tfy_fontSize([UIFont systemFontOfSize:10]).tfy_alignment(1).tfy_adjustsWidth(YES);
    }
    return _hits_label;
}

-(UILabel *)state_label{
    if (!_state_label) {
        _state_label = tfy_label();
        _state_label.tfy_textcolor(LCColor_B5, 1).tfy_fontSize([UIFont systemFontOfSize:12]).tfy_alignment(1).tfy_adjustsWidth(YES);
    }
    return _state_label;
}

-(UILabel *)info_label{
    if (!_info_label) {
        _info_label = tfy_label();
        _info_label.tfy_textcolor(LCColor_B5, 1).tfy_fontSize([UIFont systemFontOfSize:10]).tfy_alignment(1).tfy_adjustsWidth(YES);
    }
    return _info_label;
}
@end
