//
//  TFY_EmotionManager.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/26.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFY_EmotionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TFY_EmotionManager : NSObject

+(NSArray *)customEmotion;

+ (NSMutableAttributedString *)transferMessageString:(NSString *)message font:(UIFont *)font lineHeight:(CGFloat)lineHeight;
@end

NS_ASSUME_NONNULL_END
