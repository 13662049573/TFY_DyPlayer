//
//  TFY_DanMuManager.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/23.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFY_SubtitlepopupView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_DanMuManager : NSObject

/**
 * 直接添加文本和头像数据  width 宽度  uniform 随机高度 需要加载的View
 */
+(void)addModel:(TFY_SubtitlepopupModel *)model Heightarc4random:(CGFloat)uniform backView:(UIView *)backview;

@end

NS_ASSUME_NONNULL_END
