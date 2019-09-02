//
//  TFY_PlayerVideoherderView.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/8.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_PlayerVideoherderView.h"

static NSString *kVideoCover = @"https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240";

@interface TFY_PlayerVideoherderView ()
@property(nonatomic , strong)UILabel *zhuyan_label,*pf_label,*hits_label,*daoyan_label,*name_label,*state_label,*text_label,*addtime_label,*type_label;
/**
 * 收藏
 */
@property(nonatomic , strong)UIButton *collection_btn;
@end

@implementation TFY_PlayerVideoherderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.name_label];
        self.name_label.tfy_LeftSpace(10).tfy_TopSpace(0).tfy_Width(Width_W*2/3-10).tfy_Height(30);
        
        [self addSubview:self.type_label];
        self.type_label.tfy_RightSpace(10).tfy_CenterYToView(0, self.name_label).tfy_Width(Width_W*1/3-10).tfy_Height(30);
        
        [self addSubview:self.daoyan_label];
        self.daoyan_label.tfy_LeftSpace(10).tfy_TopSpaceToView(5, self.name_label).tfy_Width(Width_W*2/3-10).tfy_Height(25);
        
        [self addSubview:self.collection_btn];
        self.collection_btn.tfy_CenterYToView(0, self.daoyan_label).tfy_size(23, 21.5).tfy_RightSpace(10);
        
        [self addSubview:self.zhuyan_label];
        self.zhuyan_label.tfy_LeftSpace(10).tfy_TopSpaceToView(5, self.daoyan_label).tfy_RightSpace(10).tfy_HeightAuto();
        
        [self addSubview:self.hits_label];
        self.hits_label.tfy_LeftSpace(10).tfy_TopSpaceToView(5, self.zhuyan_label).tfy_size(Width_W/2, 20);
        
        [self addSubview:self.pf_label];
        self.pf_label.tfy_RightSpace(10).tfy_TopSpaceToView(5, self.zhuyan_label).tfy_size(80, 20);
        
        [self addSubview:self.text_label];
        self.text_label.tfy_LeftSpace(10).tfy_TopSpaceToView(5, self.hits_label).tfy_RightSpace(10).tfy_HeightAuto();
        
        [self addSubview:self.state_label];
        self.state_label.tfy_LeftSpace(10).tfy_TopSpaceToView(5, self.text_label).tfy_Width(Width_W/2).tfy_BottomSpace(0);
        
        [self addSubview:self.addtime_label];
        self.addtime_label.tfy_RightSpace(10).tfy_TopSpaceToView(5, self.text_label).tfy_Width(Width_W/2).tfy_BottomSpace(0);
        
    }
    return self;
}

-(void)setModels:(VideoData *)models{
    _models = models;
    
    self.name_label.tfy_text([NSString stringWithFormat:@"名称: %@",_models.name]);
    
    self.type_label.tfy_text([NSString stringWithFormat:@"类型: %@",_models.type]);
    
    self.daoyan_label.tfy_text([NSString stringWithFormat:@"导演: %@",_models.daoyan]);
    
    self.zhuyan_label.tfy_text([NSString stringWithFormat:@"主演: %@",_models.zhuyan]);
    
    self.hits_label.tfy_text([NSString stringWithFormat:@"播放: %@",_models.hits]);
    
    self.pf_label.tfy_text([NSString stringWithFormat:@"评分: %@",_models.pf]);
    
    self.text_label.tfy_text(_models.text);
    
    self.state_label.tfy_text([NSString stringWithFormat:@"选集: %@",_models.state]);
    
    self.addtime_label.tfy_text([NSString stringWithFormat:@"发布时间: %@",[NSDate timeInfoWithDateString:_models.addtime]]);
}

+(CGFloat)heerderCGFlot:(NSString *)text{
    CGFloat height =  [text boundingRectWithSize:CGSizeMake(Width_W-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.height;
    
    return height+160;
}

-(UILabel *)name_label{
    if (!_name_label) {
        _name_label = tfy_label();
        _name_label.tfy_textcolor(LCColor_B1, 1).tfy_fontSize(15).tfy_alignment(0).tfy_numberOfLines(0);
    }
    return _name_label;
}

-(UILabel *)type_label{
    if (!_type_label) {
        _type_label = tfy_label();
        _type_label.tfy_textcolor(LCColor_B1, 1).tfy_fontSize(15).tfy_alignment(2).tfy_numberOfLines(0);
    }
    return _type_label;
}

-(UILabel *)daoyan_label{
    if (!_daoyan_label) {
        _daoyan_label = tfy_label();
        _daoyan_label.tfy_textcolor(LCColor_B2, 1).tfy_fontSize(13).tfy_alignment(0).tfy_numberOfLines(0);
    }
    return _daoyan_label;
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
        _hits_label.tfy_textcolor(LCColor_B2, 1).tfy_fontSize(13).tfy_alignment(0);
    }
    return _hits_label;
}

-(UILabel *)pf_label{
    if (!_pf_label) {
        _pf_label = tfy_label();
        _pf_label.tfy_textcolor(LCColor_B5, 1).tfy_fontSize(13).tfy_alignment(1).tfy_backgroundColor(@"1AA3F0", 1).tfy_cornerRadius(8);
    }
    return _pf_label;
}

-(UILabel *)text_label{
    if (!_text_label) {
        _text_label = tfy_label();
        _text_label.tfy_textcolor(LCColor_B3, 1).tfy_fontSize(12).tfy_alignment(0).tfy_numberOfLines(0);
    }
    return _text_label;
}

-(UILabel *)state_label{
    if (!_state_label) {
        _state_label = tfy_label();
        _state_label.tfy_textcolor(LCColor_B1, 1).tfy_fontSize(13).tfy_alignment(0);
    }
    return _state_label;
}

-(UILabel *)addtime_label{
    if (!_addtime_label) {
        _addtime_label = tfy_label();
        _addtime_label.tfy_textcolor(LCColor_B1, 1).tfy_fontSize(13).tfy_alignment(2);
    }
    return _addtime_label;
}

-(UIButton *)collection_btn{
    if (!_collection_btn) {
        _collection_btn = tfy_button();
        _collection_btn.tfy_image(@"empty_heart", UIControlStateNormal).tfy_image(@"red_heart", UIControlStateSelected).tfy_action(self, @selector(collection_btnClick:));
    }
    return _collection_btn;
}

-(void)setSelected_btn:(BOOL)selected_btn{
    _selected_btn = selected_btn;
    
    self.collection_btn.selected = _selected_btn;
}

-(void)collection_btnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if ([self.delegate respondsToSelector:@selector(CollectionDelegateClick:)]) {
        [self.delegate CollectionDelegateClick:btn.selected];
    }
}
@end
