//
//  TFY_PlayerVideoCell.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/8.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_PlayerVideoCell.h"

@interface TFY_PlayerVideoCell ()
@property(nonatomic , strong)UIImageView *back_imageView;

@property(nonatomic , strong)UILabel *name_label;
@end

@implementation TFY_PlayerVideoCell

+ (instancetype)infoCellWithTableView:(UITableView *)tableView
{
    static NSString *Id = @"TFY_PlayerVideoCell";
    TFY_PlayerVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if(!cell){
        cell = [[TFY_PlayerVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.back_imageView];
        self.back_imageView.tfy_LeftSpace(10).tfy_TopSpace(10).tfy_BottomSpace(10).tfy_Width(Width_W*1/3-40);
        
        [self.contentView addSubview:self.name_label];
        self.name_label.tfy_LeftSpaceToView(10, self.back_imageView).tfy_CenterY(0).tfy_RightSpace(10).tfy_Height(30);
        
    }
    return self;
}

-(void)setModels:(TFY_PlayerVideoModel *)models{
    _models = models;
    
    [self.back_imageView tfy_setImageWithURLString:_models.tfy_pic placeholderImageName:@"zhnaweitu"];
    
    self.name_label.tfy_text(_models.tfy_name);
}

-(UIImageView *)back_imageView{
    if (!_back_imageView) {
        _back_imageView = tfy_imageView();
        _back_imageView.userInteractionEnabled = YES;
    }
    return _back_imageView;
}

-(UILabel *)name_label{
    if (!_name_label) {
        _name_label = tfy_label();
        _name_label.tfy_textcolor(LCColor_B1, 1).tfy_fontSize(15).tfy_alignment(0).tfy_adjustsWidth(YES);
    }
    return _name_label;
}

@end
