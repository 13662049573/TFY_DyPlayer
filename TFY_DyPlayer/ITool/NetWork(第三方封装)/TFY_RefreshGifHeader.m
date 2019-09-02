//
//  TFY_RefreshGifHeader.m
//  daerOA
//
//  Created by 田风有 on 2017/3/30.
//  Copyright © 2017年 田风有. All rights reserved.
//

#import "TFY_RefreshGifHeader.h"

@implementation TFY_RefreshGifHeader

#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSArray *idleImages = [self getRefreshingImageArrayWithStartIndex:0 endIndex:19];
    
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSArray *refreshingImages = [self getRefreshingImageArrayWithStartIndex:0 endIndex:19];
    
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    NSArray *startImages = [self getRefreshingImageArrayWithStartIndex:0 endIndex:19];

    // 设置正在刷新状态的动画图片
    [self setImages:startImages forState:MJRefreshStateRefreshing];
    
    // 隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    
    // 隐藏状态
    self.stateLabel.hidden = YES;
}
- (NSArray *)getRefreshingImageArrayWithStartIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    NSMutableArray * imageArray = [NSMutableArray array];
    for (NSUInteger i = startIndex; i <= endIndex; i++) {
        NSString *imageName = [NSString stringWithFormat:@"img_mj_stateRefreshing_00%ld", (unsigned long)i];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImage *newImage = [self imageByScalingToSize:CGSizeMake(40, 40) andSourceImage:image];
        if (newImage) {
            [imageArray addObject:newImage];
        }
    }
    return imageArray;
}


-(UIImage *)imageByScalingToSize:(CGSize)targetSize andSourceImage:(UIImage *)sourceImage
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if (widthFactor < heightFactor) {
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage ;
}

@end
