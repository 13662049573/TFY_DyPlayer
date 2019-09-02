//
//  TFY_SubtitlepopupView.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/23.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFY_DanMuImage.h"
#import "TFY_SubtitlepopupModel.h"

@class TFY_DanMuImage,TFY_SubtitlepopupModel;

NS_ASSUME_NONNULL_BEGIN

@interface TFY_SubtitlepopupView : UIView
/**
 * 根据模型构建一个弹幕
 */
- (TFY_DanMuImage *)imageWithDanMuModel:(TFY_SubtitlepopupModel *)danMuModel;
/**
 *  添加弹幕
 */
- (void)addDanMuImage:(TFY_DanMuImage *)image;

@end

NS_ASSUME_NONNULL_END
