//
//  TFY_DanMuManager.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/23.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_DanMuManager.h"

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]

#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))



@implementation TFY_DanMuManager

/**
 * 直接model 数据模型  uniform 随机高度 需要加载的View
 */
+(void)addModel:(TFY_SubtitlepopupModel *)model Heightarc4random:(CGFloat)uniform backView:(UIView *)backview{
    if (![model.userimage isKindOfClass:[UIImage class]] || model.userimage == nil) {
       model.userimage = [UIImage imageNamed:@"videoImages.bundle/placeholder"];
    }
    if (![model.otherimage isKindOfClass:[UIImage class]] || model.otherimage == nil) {
        model.otherimage = [UIImage imageNamed:@"videoImages.bundle/placeholder"];
    }
    if (![model.usercolor isKindOfClass:[UIColor class]] || model.usercolor == nil) {
        model.usercolor = randomColor;
    }
    if (![model.othercolor isKindOfClass:[UIColor class]] || model.othercolor == nil) {
        model.othercolor = randomColor;
    }
    
    TFY_SubtitlepopupView *pupusView = [TFY_SubtitlepopupView new];
    pupusView.backgroundColor = [UIColor clearColor];
    [backview addSubview:pupusView];
    pupusView.tfy_LeftSpace(0).tfy_TopSpace(0).tfy_RightSpace(0).tfy_Height(uniform);
    
    TFY_DanMuImage *danmuImage = [pupusView imageWithDanMuModel:model];
    danmuImage.image_x = [UIApplication sharedApplication].keyWindow.bounds.size.width;
    danmuImage.image_y = arc4random_uniform(uniform-70);
    
    [pupusView addDanMuImage:danmuImage];
}

@end
