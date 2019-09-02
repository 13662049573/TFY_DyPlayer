//
//  TFY_SubtitlepopupModel.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/23.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_SubtitlepopupModel : NSObject
/**
 * 内容
 */
@property (nonatomic, copy)NSString *text;
/**
 *  用户昵称
 */
@property (nonatomic, copy)NSString *username;
/**
 *  表情数组
 */
@property (nonatomic, strong)NSArray *enmotios;
/**
 *  0 :标示自己 1:标示他人
 */
@property (nonatomic, assign,getter=isType) BOOL type;
/**
 *  用户自己头像
 */
@property (nonatomic, strong)UIImage *userimage;
/**
 *  其他用户头像
 */
@property (nonatomic, strong)UIImage *otherimage;
/**
 *  用户自己背景颜色
 */
@property (nonatomic, strong)UIColor *usercolor;
/**
 *  其他用户背景颜色
 */
@property (nonatomic, strong)UIColor *othercolor;
@end

NS_ASSUME_NONNULL_END
