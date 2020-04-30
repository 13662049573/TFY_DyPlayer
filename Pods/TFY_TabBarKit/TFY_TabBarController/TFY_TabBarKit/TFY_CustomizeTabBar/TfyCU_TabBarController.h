//
//  TfyCU_TabBarController.h
//  TFY_TabBarController
//
//  Created by tiandengyou on 2019/11/28.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TfyCU_TabBarControllerProtocol.h"
#import "TfyCU_TabBarView.h"

typedef NS_ENUM(NSInteger, ScenestobeusedStyle) {
    NavigationbaruseStyle,//导航栏使用，需要隐藏之前的导航栏
    TabarbaruseStyle //底部使用
};


NS_ASSUME_NONNULL_BEGIN

@interface TfyCU_TabBarController : UIViewController<TfyCU_TabBarViewDelegate,TfyCU_TabBarControllerProtocol>
/***必须要设置的属性*/
@property(nonatomic , assign)ScenestobeusedStyle  Style;
/**
 *  设置tabBar和contentView的大小
 *  默认是tabBar在底部，contentView填充其余空间
 *  如果设置了headerView，此方法不生效
 *  ScenestobeusedStyle 使用场景选择
 */
- (void)setTabBarFrame:(CGSize)tabBarSize contentViewFrame:(CGSize)contentViewSize ScenestobeusedStyle:(ScenestobeusedStyle)Style;
@end

NS_ASSUME_NONNULL_END
