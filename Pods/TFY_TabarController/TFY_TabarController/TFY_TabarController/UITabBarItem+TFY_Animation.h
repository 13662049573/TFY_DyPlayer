//
//  UITabBarItem+TFY_Animation.h
//  TFY_TabarController
//
//  Created by 田风有 on 2019/7/23.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFY_AnimationProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@protocol TFY_AnimationProtocol;
@interface UITabBarItem (TFY_Animation)

@property(nonatomic, strong) id <TFY_AnimationProtocol>animation;
@end

NS_ASSUME_NONNULL_END
