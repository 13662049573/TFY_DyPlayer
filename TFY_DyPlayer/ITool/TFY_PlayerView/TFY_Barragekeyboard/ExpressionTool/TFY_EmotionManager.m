//
//  TFY_EmotionManager.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/26.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_EmotionManager.h"
#import <UIKit/UIKit.h>

@implementation TFY_EmotionManager
static NSArray *_custumEmotions;

+(NSArray *)customEmotion{
    if (_custumEmotions) {
        return _custumEmotions;
    }
    _custumEmotions = [TFY_EmotionModel tfy_objectArrayWithFilename:@"Expression.bundle/normal_face.plist"];
    return _custumEmotions;
}

+ (NSMutableAttributedString *)transferMessageString:(NSString *)message font:(UIFont *)font lineHeight:(CGFloat)lineHeight
{
    NSMutableAttributedString *attributeStr
    = [[NSMutableAttributedString alloc] initWithString:message];
    NSString *regEmj  = @"\\[[a-zA-Z0-9\\/\\u4e00-\\u9fa5]+\\]";// [微笑]、［哭］等自定义表情处理
    NSError *error    = nil;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regEmj options:NSRegularExpressionCaseInsensitive error:&error];
    if (!expression) {
        NSLog(@"%@",error);
        return attributeStr;
    }
    [attributeStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributeStr.length)];
    NSArray *resultArray = [expression matchesInString:message options:0 range:NSMakeRange(0, message.length)];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    for (NSTextCheckingResult *match in resultArray) {
        NSRange range    = match.range;
        NSString *subStr = [message substringWithRange:range];
        NSArray *faceArr = [TFY_EmotionManager customEmotion];
        for (TFY_EmotionModel *face in faceArr) {
            if ([face.face_name isEqualToString:subStr]) {
                NSTextAttachment *attach   = [[NSTextAttachment alloc] init];
                attach.image               = [UIImage imageNamed:face.face_name];
                // 位置调整Y值就行
                attach.bounds              = CGRectMake(0, -4, lineHeight, lineHeight);
                NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attach];
                NSMutableDictionary *imagDic   = [NSMutableDictionary dictionaryWithCapacity:2];
                [imagDic setObject:imgStr forKey:@"image"];
                [imagDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                [mutableArray addObject:imagDic];
            }
        }
    }
    for (int i =(int) mutableArray.count - 1; i >= 0; i --) {
        NSRange range;
        [mutableArray[i][@"range"] getValue:&range];
        [attributeStr replaceCharactersInRange:range withAttributedString:mutableArray[i][@"image"]];
    }
    return attributeStr;
}

@end
