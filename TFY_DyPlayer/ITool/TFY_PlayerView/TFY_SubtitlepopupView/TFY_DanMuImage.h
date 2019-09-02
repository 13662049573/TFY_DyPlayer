//
//  TFY_DanMuImage.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/23.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_DanMuImage : UIImage
//每个弹幕的视图都需要一个自己的坐标
@property (nonatomic, assign) CGFloat image_x;
@property (nonatomic, assign) CGFloat image_y;

@end

NS_ASSUME_NONNULL_END
