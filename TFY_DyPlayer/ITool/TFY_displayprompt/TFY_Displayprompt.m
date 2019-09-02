//
//  TFY_Displayprompt.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/17.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_Displayprompt.h"

@interface TFY_Displayprompt ()
@property(nonatomic , strong)UIImageView *back_imageView;
@end

@implementation TFY_Displayprompt

+(instancetype)showWithdisplayprompt:(UIView *)backView back_imageView:(NSString *)imagestr WithCGSize:(CGSize)size{
    
    TFY_Displayprompt *prompt = [[self alloc] initWithDisplaypromptView:backView back_imageView:imagestr WithCGSize:size];
    return prompt;
}

- (instancetype)initWithDisplaypromptView:(nonnull UIView *)containerView back_imageView:(NSString *)imagestr WithCGSize:(CGSize)size{
    TFY_Displayprompt *prompt = [self init];
    [containerView addSubview:self.back_imageView];
    self.back_imageView.tfy_se = size;
    self.back_imageView.tfy_cx = containerView.center.x;
    self.back_imageView.tfy_cy = containerView.center.y-kNavBarHeight;
    self.back_imageView.image = [[UIImage imageNamed:imagestr] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return prompt;
}

-(UIImageView *)back_imageView{
    if (!_back_imageView) {
        _back_imageView = tfy_imageView();
    }
    return _back_imageView;
}


@end
