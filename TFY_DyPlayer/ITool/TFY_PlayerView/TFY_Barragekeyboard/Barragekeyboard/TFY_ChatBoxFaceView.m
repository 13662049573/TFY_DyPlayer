//
//  TFY_ChatBoxFaceView.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/30.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_ChatBoxFaceView.h"
#import "TFY_EmotionManager.h"



@interface TFY_ChatBoxFaceView ()
@property(nonatomic,strong)NSArray *emotions;
@property(nonatomic,strong)TFY_StackView *stackView;

@end

@implementation TFY_ChatBoxFaceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.15 green:0.11 blue:0.11 alpha:1.00];
        
        [self addSubview:self.stackView];
        [self.stackView tfy_AutoSize:0 top:0 right:0 bottom:40];
        
        [self.emotions enumerateObjectsUsingBlock:^(TFY_EmotionModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            UIView *backView = [UIView new];
            [self.stackView addSubview:backView];
            
            UIImageView *emotionimage = tfy_imageView();
            emotionimage.tfy_action(self, @selector(imageClick:)).tfy_imge([NSString stringWithFormat:@"Expression.bundle/%@",model.face_name]);
            emotionimage.tag = idx;
            
            [backView addSubview:emotionimage];
            emotionimage.tfy_Center(0, 0).tfy_size(56, 54);
            
        }];
        
        [self.stackView tfy_StartLayout];
    }
    return self;
}

-(void)imageClick:(UIImageView *)tagimage{
    
}



-(NSArray *)emotions{
    if (!_emotions) {
        _emotions = [NSArray array];
        _emotions = [TFY_EmotionManager customEmotion];
    }
    return _emotions;
}

-(TFY_StackView *)stackView{
    if (!_stackView) {
        _stackView = [TFY_StackView new];
        _stackView.tfy_Edge = UIEdgeInsetsMake(1, 1, 1, 1);
        _stackView.tfy_Orientation = All;// 自动横向垂直混合布局
        _stackView.tfy_HSpace = 1;
        _stackView.tfy_VSpace = 1;
        _stackView.tfy_Column = 5;
    }
    return _stackView;
}

@end
