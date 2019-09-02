//
//  TFY_SmallFloatControlView.h
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/7/3.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_SmallFloatControlView : UIView
@property (nonatomic, copy, nullable) void(^closeClickCallback)(void);
@end

NS_ASSUME_NONNULL_END
