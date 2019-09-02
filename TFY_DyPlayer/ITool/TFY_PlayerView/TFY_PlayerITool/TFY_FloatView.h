//
//  TFY_FloatView.h
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/30.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_FloatView : UIView
/**
 * 父视图
 */
@property(nonatomic, weak) UIView *parentView;
/**
 *  安全边距，主要针对那些使用Navbar和tabbar的边距
 */
@property(nonatomic, assign) UIEdgeInsets safeInsets;
@end

NS_ASSUME_NONNULL_END
