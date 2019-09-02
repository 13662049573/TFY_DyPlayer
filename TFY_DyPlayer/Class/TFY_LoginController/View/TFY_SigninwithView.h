//
//  TFY_SigninwithView.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/24.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_SigninwithView : UIView
/**
 *  点击返回回调 200 QQ 201 微信 202 新良
 */
@property (nonatomic, copy) void(^signinwithBlock)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
