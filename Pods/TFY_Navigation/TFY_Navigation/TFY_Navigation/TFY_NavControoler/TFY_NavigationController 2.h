//
//  TFY_NavigationController.h
//
//  Created by 田风有 on 2019/03/27.
//  Copyright © 2019 恋机科技. All rights reserved.


/**
 * 功能：为每个控制器配置单独的导航栏
 *
 * 使用说明：
 *  前提说明：本代码是针对公司项目做的适配，有些场景可能覆盖不全；
 *          如果你的项目在使用上遇到任何问题，欢迎提 Issue。
 *
 *  1、将`TFY_NavigationController.{h/m}`文件拖入项目
 *
 *  2、只需将导航栏类设置为`TFY_NavigationController`即可
 *
 *  3、目前返回按钮仅支持图片，如果你设置了`backIconImage`属性但是发现图标还是蓝色的，
 *     请检查图片的渲染模式是否为`UIImageRenderingModeAlwaysOriginal`
 *
 *  4、如果你的项目有自定义的UINavigationController，
 *     则请在你的项目中定义`kTFYNavigationControllerClassName`这个宏(参考下面示例)，
 *     如果是个别页面有定制的导航栏，控制器也可以通过重写`-xp_navigationControllerClass`方法返回对应的导航栏
 */

#import <UIKit/UIKit.h>

/// 仅限于内部使用
@interface TFYContainerNavigationController : UINavigationController
@end

@interface TFY_NavigationController : TFYContainerNavigationController
/**
 *  按钮图标,默认`白色箭头`
 */
@property (nonatomic, strong)UIImage *backIconImage;
/**
 *  初始导航栏颜色为黑色，也可以自己创建的时候设置颜色
 */
@property (nonatomic, strong)UIColor *barBackgroundColor;
/**
 *  初始y字体颜色为白色 ，也可以自己创建设置自定义颜色
 */
@property (nonatomic, strong)UIColor *titleColor;
/**
 * 导航栏背景图片
 */
@property (nonatomic, strong)UIImage *backimage;
@end


@interface UIViewController (TFYNavigationContainer)

/**
 返回控制器的导航栏,默认`TFYContainerNavigationController.class`
 
 你可以通过定义`kTFYNavigationControllerClassName`这个宏来返回默认的导航栏,
 子类也可以通过重写这个方法返回单独的导航栏,
 如果你自定义了导航栏之后,记得自己处理状态栏和屏幕旋转等问题

 @return 导航栏控制器类,必须是`UINavigationController`或其子类
 */
- (Class)tfy_navigationControllerClass;

/// Default is `nil`
- (TFY_NavigationController *)tfy_rootNavigationController;

@end
