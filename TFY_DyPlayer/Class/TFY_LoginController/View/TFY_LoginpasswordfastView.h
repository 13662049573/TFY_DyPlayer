//
//  TFY_LoginpasswordfastView.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/24.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_LoginpasswordfastView : UIView
/**
 *  点击返回回调 100 登录 101 快速注册 102 找回密码
 */
@property (nonatomic, copy) void(^fastBlock)(NSInteger index);
/**
 * 登录按钮监听
 */
@property (nonatomic, assign)BOOL buttombool;
@end

NS_ASSUME_NONNULL_END
