//
//  TFY_TabBarAnimation.h
//  TFY_TabarController
//
//  Created by 田风有 on 2019/7/23.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFY_AnimationProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/** 弹性动画 */
@interface BounceAnimation : NSObject <TFY_AnimationProtocol>
@end

/** 仿烟动画 */
@interface FumeAnimation : NSObject <TFY_AnimationProtocol>
@end

/** 旋转动画 */
@interface RotationAnimation : NSObject <TFY_AnimationProtocol>
@end

/** 贞动画 */
@interface FrameAnimation : NSObject <TFY_AnimationProtocol>
@property(nonatomic, strong) NSArray <CIImage *>*images;
@end


/** 转场动画 */
@interface TransitionAniamtion : NSObject <TFY_AnimationProtocol>
/** direction 翻转方向, 取值1-6，默认1
 * UIViewAnimationOptionTransitionFlipFromLeft    = 1,
 * UIViewAnimationOptionTransitionFlipFromRight   = 2,
 * UIViewAnimationOptionTransitionFlipFromTop     = 3,
 * UIViewAnimationOptionTransitionFlipFromBottom  = 4,
 * UIViewAnimationOptionTransitionCurlUp          = 5,
 * UIViewAnimationOptionTransitionCurlDown        = 6,
 */
@property(nonatomic, assign) NSUInteger direction;
/// 不播放撤销选择动画， default ： NO
@property(nonatomic, assign) BOOL disableDeselectAnimation;

@end
NS_ASSUME_NONNULL_END
