//
//  TFY_EmotionModel.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/26.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_EmotionModel.h"

@implementation TFY_EmotionModel

- (BOOL)isEqual:(TFY_EmotionModel *)emotion
{
    return [self.face_name isEqualToString:emotion.face_name] || [self.code isEqualToString:emotion.code];
}
@end
