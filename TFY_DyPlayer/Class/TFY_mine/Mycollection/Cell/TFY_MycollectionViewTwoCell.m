//
//  TFY_MycollectionViewTwoCell.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/16.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_MycollectionViewTwoCell.h"

@interface TFY_MycollectionViewTwoCell ()
@property(nonatomic , strong)UIImageView *pic_imageView;

@property(nonatomic , strong)UILabel *zhuyan_label,*pf_label,*hits_label,*daoyan_label,*name_label,*state_label,*addtime_label,*type_label;
@end


@implementation TFY_MycollectionViewTwoCell

+ (instancetype)infoCellWithTableView:(UITableView *)tableView{
    
    static NSString *Id = @"TFY_MycollectionViewTwoCell";
    TFY_MycollectionViewTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if(!cell){
        cell = [[TFY_MycollectionViewTwoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.pic_imageView];
        self.pic_imageView.tfy_RightSpace(10).tfy_TopSpace(10).tfy_BottomSpace(10).tfy_Width(Width_W*1/3);
        
        [self.pic_imageView addSubview:self.pf_label];
        self.pf_label.tfy_RightSpace(10).tfy_TopSpace(10).tfy_size(65, 25);
        
        [self.pic_imageView addSubview:self.state_label];
        self.state_label.tfy_RightSpace(10).tfy_RightSpace(10).tfy_BottomSpace(10).tfy_Height(25);
        
        [self.contentView addSubview:self.name_label];
        self.name_label.tfy_RightSpaceToView(10, self.pic_imageView).tfy_TopSpace(10).tfy_LeftSpace(10).tfy_HeightAuto();
        
        [self.contentView addSubview:self.daoyan_label];
        self.daoyan_label.tfy_RightSpaceToView(10, self.pic_imageView).tfy_TopSpaceToView(5, self.name_label).tfy_LeftSpace(10).tfy_HeightAuto();
        
        [self.contentView addSubview:self.zhuyan_label];
        self.zhuyan_label.tfy_RightSpaceToView(10, self.pic_imageView).tfy_TopSpaceToView(5, self.daoyan_label).tfy_LeftSpace(10).tfy_HeightAuto();
        
        [self.contentView addSubview:self.type_label];
        self.type_label.tfy_LeftSpace(10).tfy_TopSpaceToView(5, self.zhuyan_label).tfy_Width(Width_W*2/3/2).tfy_Height(25);
        
        [self.contentView addSubview:self.hits_label];
        self.hits_label.tfy_RightSpaceToView(10, self.pic_imageView).tfy_Width(Width_W*2/3/2).tfy_TopSpaceToView(5, self.zhuyan_label).tfy_Height(25);
        
        [self.contentView addSubview:self.addtime_label];
        self.addtime_label.tfy_RightSpaceToView(10, self.pic_imageView).tfy_LeftSpace(10).tfy_TopSpaceToView(5, self.hits_label).tfy_Height(25);
    }
    return self;
}

-(void)setModels:(TFY_CollectionModel *)models{
    _models = models;
    
    [self.pic_imageView tfy_setImageWithURLString:_models.pic placeholderImageName:@"zhnaweitu"];
    
    self.name_label.tfy_text([NSString stringWithFormat:@"名称: %@",_models.name]);
    
    self.daoyan_label.tfy_text([NSString stringWithFormat:@"导演: %@",_models.daoyan]);
    
    self.zhuyan_label.tfy_text([NSString stringWithFormat:@"主演: %@",_models.zhuyan]);
    
    self.type_label.tfy_text([NSString stringWithFormat:@"类型: %@",_models.type]);
    
    self.pf_label.tfy_text([NSString stringWithFormat:@"评分:%@",_models.pf]);
    
    self.hits_label.tfy_text([NSString stringWithFormat:@"播放量: %@",_models.hits]);
    
    self.state_label.tfy_text([NSString stringWithFormat:@"选集: %@",_models.state]);
    
    self.addtime_label.tfy_text([NSString stringWithFormat:@"发布时间: %@",[NSDate timeInfoWithDateString:_models.addtime]]);
}

-(UIImageView *)pic_imageView{
    if (!_pic_imageView) {
        _pic_imageView = tfy_imageView();
    }
    return _pic_imageView;
}

-(UILabel *)name_label{
    if (!_name_label) {
        _name_label = tfy_label();
        _name_label.tfy_textcolor(LCColor_B1, 1).tfy_fontSize(14).tfy_alignment(0).tfy_numberOfLines(0);
    }
    return _name_label;
}

-(UILabel *)daoyan_label{
    if (!_daoyan_label) {
        _daoyan_label = tfy_label();
        _daoyan_label.tfy_textcolor(LCColor_B2, 1).tfy_fontSize(13).tfy_alignment(0).tfy_numberOfLines(0);
    }
    return _daoyan_label;
}

-(UILabel *)type_label{
    if (!_type_label) {
        _type_label = tfy_label();
        _type_label.tfy_textcolor(LCColor_B1, 1).tfy_fontSize(14).tfy_alignment(0).tfy_numberOfLines(0);
    }
    return _type_label;
}


-(UILabel *)zhuyan_label{
    if (!_zhuyan_label) {
        _zhuyan_label = tfy_label();
        _zhuyan_label.tfy_textcolor(LCColor_B2, 1).tfy_fontSize(13).tfy_alignment(0).tfy_numberOfLines(0);
    }
    return _zhuyan_label;
}

-(UILabel *)hits_label{
    if (!_hits_label) {
        _hits_label = tfy_label();
        _hits_label.tfy_textcolor(LCColor_B1, 1).tfy_fontSize(14).tfy_alignment(2);
    }
    return _hits_label;
}

-(UILabel *)pf_label{
    if (!_pf_label) {
        _pf_label = tfy_label();
        _pf_label.tfy_textcolor(LCColor_B5, 1).tfy_fontSize(13).tfy_alignment(1).tfy_backgroundColor(@"1AA3F0", 1).tfy_cornerRadius(5);
    }
    return _pf_label;
}



-(UILabel *)state_label{
    if (!_state_label) {
        _state_label = tfy_label();
        _state_label.tfy_textcolor(LCColor_B5, 1).tfy_fontSize(13).tfy_alignment(1);
    }
    return _state_label;
}

-(UILabel *)addtime_label{
    if (!_addtime_label) {
        _addtime_label = tfy_label();
        _addtime_label.tfy_textcolor(LCColor_B1, 1).tfy_fontSize(14).tfy_alignment(1);
    }
    return _addtime_label;
}

@end
