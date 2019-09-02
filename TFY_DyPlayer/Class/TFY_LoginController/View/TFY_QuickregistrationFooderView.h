//
//  TFY_QuickregistrationFooderView.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/25.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_QuickregistrationFooderView : UIView
/**
 * 登录按钮监听
 */
@property (nonatomic, assign)BOOL buttombool;
/**
 *  完成回调
 */
@property (nonatomic, copy) void(^carryoutBlock)(void);

@end

NS_ASSUME_NONNULL_END
