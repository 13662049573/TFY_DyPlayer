//
//  TFY_SettingViewCell.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/11.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_SettingViewCell.h"
#import "TFY_ColorSwitch.h"

@interface TFY_SettingViewCell ()
@property(nonatomic , strong)TFY_ColorSwitch *Switch;

@property(nonatomic , strong)UILabel *title_label,*arrow_label;

@property(nonatomic , strong)UIImageView *arrow_imageView;
@end

@implementation TFY_SettingViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.title_label];
        self.title_label.tfy_LeftSpace(20).tfy_CenterY(0).tfy_size(Width_W/2, 35);
        
        [self.contentView addSubview:self.arrow_imageView];
        self.arrow_imageView.tfy_RightSpace(20).tfy_CenterY(0).tfy_size(21, 21);
        
        [self.contentView addSubview:self.arrow_label];
        self.arrow_label.tfy_RightSpace(20).tfy_CenterY(0).tfy_size(Width_W/2, 35);
        
        [self.contentView addSubview:self.Switch];
    }
    return self;
}


-(void)setModels:(Items *)models{
    _models = models;
    
    self.title_label.tfy_text(_models.title_str);
    
    if (![TFY_CommonUtils judgeIsEmptyWithString:_models.arrow_str]) {
        self.arrow_imageView.tfy_imge(_models.arrow_str);
        self.arrow_imageView.hidden = NO;
    }
    else{
        self.arrow_imageView.hidden = YES;
    }
    if (_models.count_str == 0 || _models.count_str == 1) {
        self.Switch.on = _models.count_str;
    }
}

-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    
    if (_indexPath.section == 6 && _indexPath.row==0) {
        self.title_label.tfy_LeftSpace(20).tfy_RightSpace(20).tfy_Height(35).tfy_CenterY(0);
        self.title_label.tfy_textcolor(LCColor_A2, 1).tfy_alignment(1);
    }
    else{
        self.title_label.tfy_LeftSpace(20).tfy_CenterY(0).tfy_size(Width_W/2, 35);
        self.title_label.tfy_textcolor(LCColor_B1, 1).tfy_alignment(0);
    }
    
    if (((_indexPath.section ==2 || _indexPath.section == 3) && _indexPath.row == 0) || _indexPath.section == 4) {
        self.Switch.hidden = NO;
    }
    else{
        self.Switch.hidden = YES;
    }
    
    if (_indexPath.section == 5 && _indexPath.row == 4) {
        self.arrow_label.hidden = NO;
        float cacheSize =  [TFY_CommonUtils readCacheSize]*1024;
        
        self.arrow_label.tfy_text([TFY_CommonUtils convertFileSize:cacheSize]);
    }
    else{
        self.arrow_label.hidden = YES;
        self.arrow_label.tfy_text(@"");
    }
}


-(UILabel *)title_label{
    if (!_title_label) {
        _title_label = tfy_label();
        _title_label.tfy_textcolor(LCColor_B1, 1).tfy_fontSize([UIFont systemFontOfSize:14]).tfy_alignment(0);
    }
    return _title_label;
}

-(UILabel *)arrow_label{
    if (!_arrow_label) {
        _arrow_label = tfy_label();
        _arrow_label.tfy_textcolor(LCColor_B1, 1).tfy_fontSize([UIFont systemFontOfSize:13]).tfy_alignment(2);
        _arrow_label.hidden = YES;
    }
    return _arrow_label;
}

-(UIImageView *)arrow_imageView{
    if (!_arrow_imageView) {
        _arrow_imageView = tfy_imageView();
        _arrow_imageView.hidden = YES;
    }
    return _arrow_imageView;
}

-(TFY_ColorSwitch *)Switch{
    if (!_Switch) {
        _Switch = [[TFY_ColorSwitch alloc] initWithFrame:CGRectMake(Width_W-77, 14.5, 57, 30)];
        [_Switch setTintBorderColor:[UIColor tfy_colorWithHex:@"E6E6E6"]];
        _Switch.onTintColor = [UIColor tfy_colorWithHex:LCColor_A1];
        _Switch.hidden = YES;
        [_Switch addTarget:self action:@selector(tableSwitchPressed:) forControlEvents:UIControlEventValueChanged];
    }
    return _Switch;
}
- (void)tableSwitchPressed:(id)sender
{
    TFY_ColorSwitch *nkswitch = (TFY_ColorSwitch *)sender;
    if (nkswitch.isOn){
        
    }
    else{
       
    }
}
@end
