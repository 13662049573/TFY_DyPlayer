//
//  TFY_ColorSwitch.h
//  XJK
//
//  Created by 田风有 on 2018/8/2.
//  Copyright © 2018年 zhegndi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TFY_ColorSwitchShapeOval,
    TFY_ColorSwitchShapeRectangle,
    TFY_ColorSwitchShapeRectangleNoCorner
} TFY_ColorSwitchShape;


@interface TFY_ColorSwitch : UIControl<UIGestureRecognizerDelegate>

/* 一个布尔值，用于确定交换机的关闭/打开状态。*/
@property (nonatomic, getter = isOn) BOOL on;

/* 确定开关控件形状的值 */
@property (nonatomic, assign) TFY_ColorSwitchShape shape;

/* 用于在开关打开时为开关外观着色的颜色。 */
@property (nonatomic, strong) UIColor *onTintColor;

/* 用于在禁用开关时为外观着色的颜色。 */
@property (nonatomic, strong) UIColor *tintColor;

/* 用于着色拇指外观的颜色。*/
@property (nonatomic, strong) UIColor *thumbTintColor;

/* 拇指投下阴影开/关 */
@property (nonatomic, assign) BOOL shadow;

/* 用于在禁用开关时为外观着色的边框颜色。*/
@property (nonatomic, strong) UIColor *tintBorderColor;

/* 用于在开关打开时为开关外观着色的边框颜色。 */
@property (nonatomic, strong) UIColor *onTintBorderColor;

@end
