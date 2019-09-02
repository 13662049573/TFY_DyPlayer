//
//  TFY_PicturevideoView.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/22.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_PicturevideoView.h"

#define Window_root(UIView)  [[[UIApplication sharedApplication] keyWindow] addSubview:UIView]

@interface TFY_PicturevideoView ()
@property(nonatomic , strong)UIImageView *back_imaeView;

@property(nonatomic , strong)UIButton *close_btn;

@property(nonatomic , strong)UILabel *title_label;

@property(nonatomic , strong)TFY_StackView *stackView;
@end

@implementation TFY_PicturevideoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [[UIImage imageNamed:@"videoImages.bundle/video_right"] tfy_blurredImage:0.8];
        self.layer.contents = (id)image.CGImage;
        
        [self addSubview:self.close_btn];
        self.close_btn.tfy_LeftSpace(0).tfy_TopSpace(10).tfy_size(40, 40);
        
        [self addSubview:self.back_imaeView];
        self.back_imaeView.tfy_Center(0, 0).tfy_size(TFY_PLAYER_ScreenW*3/4, TFY_PLAYER_ScreenW/2);
        
        [self addSubview:self.title_label];
        self.title_label.tfy_LeftSpace(40).tfy_BottomSpaceToView(-20, self.back_imaeView).tfy_RightSpace(40).tfy_Height(30);
        
        [self addSubview:self.stackView];
        self.stackView.tfy_LeftSpace(50).tfy_TopSpaceToView(0, self.back_imaeView).tfy_RightSpace(50).tfy_BottomSpace(0);
        
        NSArray *imageArr = @[@"dy_share_to_weixin_normal",@"dy_share_to_qq_normal",@"dy_share_to_sina_normal",@"dy_share_to_qzone_normal",@"dy_share_to_friend_normal",@"dy_share_to_publish_normal"];
        NSArray *titleArr = @[@"微信",@"QQ",@"新浪",@"空间",@"朋友圈",@"保存相册"];
        [titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIButton *button = tfy_button().tfy_image(imageArr[idx],UIControlStateNormal).tfy_title(titleArr[idx],@"ffffff",14).tfy_alAlignment(1).tfy_action(self,@selector(buttonClick:));
            button.tag = idx+1;
            button.imageEdgeInsets = UIEdgeInsetsMake(10, 30, 40, 0);
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -30, -50, 0);
            [self.stackView addSubview:button];
            
        }];
        
        [self.stackView tfy_StartLayout];
    }
    return self;
}

-(void)setStatus:(PicturevideoStatus)status{
    _status = status;
    switch (_status) {
        case TFY_PictureStatus:
            
            break;
        case TFY_VideoStatus:
            
            break;
        default:
            break;
    }
}

-(void)setThumeimage:(UIImage *)thumeimage{
    _thumeimage = thumeimage;
    if ([_thumeimage isKindOfClass:[UIImage class]]) {
        self.back_imaeView.image = _thumeimage;
        [self showMKPAlertView];
        
    }
}

-(void)buttonClick:(UIButton *)btn{
    if (btn.tag==6) {
        self.title_label.tfy_text(@"图片已经保存到相册里面,请去查看!");
        [TFY_CommonUtils saveImage:self.thumeimage assetCollectionName:@"thumeimage"];
    }
    if (self.Sharblock) {
        self.Sharblock(btn.tag);
    }
}

-(void)setThumeiImages:(NSArray *)thumeiImages{
    _thumeiImages = thumeiImages;
    
    [self showMKPAlertView];
    
    //设置动画图片
    self.back_imaeView.animationImages = _thumeiImages;
    
    //动画时间
    
    self.back_imaeView.animationDuration = 1;
    
    //动画播放重复次数，值为0时，无限循环
    
    self.back_imaeView.animationRepeatCount = 0;
    
    //开始动画
    
    [self.back_imaeView startAnimating];
    
}


#pragma mark - 弹出
-(void)showMKPAlertView
{
//    Window_root(self);
    [self creatShowAnimation];
}

-(void)creatShowAnimation
{
    self.transform = CGAffineTransformMakeScale(0.50, 0.50);
    [UIView animateWithDuration:1.0f delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {}];
}

-(void)hideMKPAlertView{
    self.hidden = YES;
//    [self removeFromSuperview];
}

-(UIButton *)close_btn{
    if (!_close_btn) {
        _close_btn = tfy_button();
        _close_btn.tfy_image(@"videoImages.bundle/close", UIControlStateNormal).tfy_action(self, @selector(close_btnClick));
    }
    return _close_btn;
}

-(UIImageView *)back_imaeView{
    if (!_back_imaeView) {
        _back_imaeView = tfy_imageView();
        _back_imaeView.userInteractionEnabled = YES;
    }
    return _back_imaeView;
}

-(UILabel *)title_label{
    if (!_title_label) {
        _title_label = tfy_label();
        _title_label.tfy_textcolor(@"ffffff", 1).tfy_fontSize(14).tfy_numberOfLines(0).tfy_alignment(1).tfy_text(@"获取的图片可以进行以下分享!");
    }
    return _title_label;
}
-(TFY_StackView *)stackView{
    if (!_stackView) {
        _stackView = [TFY_StackView new];
        _stackView.tfy_Edge = UIEdgeInsetsMake(1, 1, 1, 1);
        _stackView.tfy_Orientation = Horizontal;
        _stackView.tfy_HSpace = 1;
        _stackView.tfy_VSpace = 1;
    }
    return _stackView;
}

-(void)close_btnClick{
    if (self.picturevideoback) {
        self.picturevideoback();
    }
    [self hideMKPAlertView];
}
@end
