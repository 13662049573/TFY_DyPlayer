//
//  TFY_ChatBoxFaceCell.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/9/2.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_ChatBoxFaceCell.h"

@interface TFY_ChatBoxFaceCell ()
@property(nonatomic , strong)UIImageView *emotionsImageView;
@end

@implementation TFY_ChatBoxFaceCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.emotionsImageView];
        [self.emotionsImageView tfy_AutoSize:0 top:0 right:0 bottom:0];
    }
    return self;
}


-(void)setModel:(TFY_EmotionModel *)model{
    _model = model;
    
    self.emotionsImageView.tfy_imge([NSString stringWithFormat:@"Expression.bundle/%@",_model.face_name]);
}

-(UIImageView *)emotionsImageView{
    if (!_emotionsImageView) {
        _emotionsImageView = tfy_imageView();
    }
    return _emotionsImageView;
}
@end
