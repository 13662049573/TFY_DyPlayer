//
//  TFY_QuickregistrationController.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/25.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_BaseLoginAVPlayerController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_QuickregistrationController : TFY_BaseLoginAVPlayerController

@property (nonatomic, copy) void(^quickregistrationBlock)(NSString *phone,NSString *code,NSString *passwolrd);

@end

NS_ASSUME_NONNULL_END
