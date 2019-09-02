//
//  TFY_recommendherderView.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/5.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_recommendherderView.h"

@interface TFY_recommendherderView ()

@property(nonatomic , strong)UIView *back_view;

@property(nonatomic , strong)UILabel *title_label;

@property(nonatomic , strong)UIButton *arrow_btn;

@end

@implementation TFY_recommendherderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.back_view];
        self.back_view.tfy_LeftSpace(10).tfy_CenterY(0).tfy_size(8, 8);
        
        [self addSubview:self.title_label];
        self.title_label.tfy_LeftSpaceToView(5, self.back_view).tfy_TopSpace(0).tfy_RightSpace(80).tfy_BottomSpace(0);
        
        [self addSubview:self.arrow_btn];
        self.arrow_btn.tfy_RightSpace(10).tfy_CenterY(0).tfy_size(60, 40);
    }
    return self;
}

-(void)setModels:(Data *)models{
    _models = models;
    
    self.title_label.tfy_text(_models.name);
}

-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    
    self.arrow_btn.tag = _indexPath.section;
}

-(UIView *)back_view{
    if (!_back_view) {
        _back_view = [UIView new];
        _back_view.layer.masksToBounds = YES;
        _back_view.layer.cornerRadius = 4;
        _back_view.backgroundColor = [UIColor redColor];
    }
    return _back_view;
}

-(UILabel *)title_label{
    if (!_title_label) {
        _title_label = tfy_label();
        _title_label.tfy_textcolor(LCColor_B1, 1).tfy_alignment(0).tfy_fontSize(14).tfy_adjustsWidth(YES);
    }
    return _title_label;
}

-(UIButton *)arrow_btn{
    if (!_arrow_btn) {
        _arrow_btn = tfy_button();
        _arrow_btn.tfy_title(@"更多", LCColor_B2, 11).tfy_image(@"jiantou", UIControlStateNormal).tfy_action(self, @selector(arrow_btnClick:));
        [_arrow_btn tfy_layouEdgeInsetsPosition:ButtonPositionImageRight_titleLeft spacing:15];
    }
    return _arrow_btn;
}

-(void)arrow_btnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(HerderDelegateClick:model:)]) {
        [self.delegate HerderDelegateClick:btn.tag model:self.models];
    }
}
@end
