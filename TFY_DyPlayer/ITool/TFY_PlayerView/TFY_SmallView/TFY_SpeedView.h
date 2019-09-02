//
//  TFY_SpeedView.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/19.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_SpeedView : UIView

@property (nonatomic, copy) void(^Speekback)(CGFloat rate);

@end

NS_ASSUME_NONNULL_END
