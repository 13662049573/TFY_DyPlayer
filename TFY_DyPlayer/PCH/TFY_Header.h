//
//  TFY_Header.h
//  TFY_AutoLMTools
//
//  Created by 田风有 on 2019/5/16.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#ifndef TFY_Header_h
#define TFY_Header_h
/**
 * 界面主色区
 */
#define LCColor_A1   @"FF9217" //主色
#define LCColor_A2   @"FE453F"
#define LCColor_A3   @"2C93FF"
#define LCColor_A4   @"FF9A00"
#define LCColor_A5   @"00C6FF"
#define LCColor_A6   @"CA5252"
/**
 * 字体主色区
 */
#define LCColor_B1   @"031D39"
#define LCColor_B2   @"333333"
#define LCColor_B3   @"666666"
#define LCColor_B4   @"999999"
#define LCColor_B5   @"FFFFFF"
#define LCColor_B6   @"EBEBEB"
#define LCColor_B7   @"fafafa"
#define LCColor_B8   @"3D4453"
#define LCColor_B9   @"B2BBC3"


#ifdef DEBUG

#define NSLog(FORMAT, ...) fprintf(stderr, "\n\n******(class)%s(begin)******\n(SEL)%s\n(line)%d\n(data)%s\n******(class)%s(end)******\n\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __FUNCTION__, __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String], [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String])

#else

#define NSLog(FORMAT, ...) nil

#endif


#define TFY_APPDelegate  ((AppDelegate*)[UIApplication sharedApplication].delegate)

//处理循环引用问题(处理当前类对象)
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
//拿到主视图
#define KeyWindow [UIApplication sharedApplication].keyWindow
//屏幕高
#define  Height_H [UIScreen mainScreen].bounds.size.height
//屏幕宽
#define  Width_W  [UIScreen mainScreen].bounds.size.width

#define Ipad ((double)Height_H/(double)Width_W) < 1.6 ? YES : NO

//等比宽
#define DEBI_width(CGFloat) (double)CGFloat/(double)375*Width_W
//等比高
#define DEBI_height(CGFloat) (double)CGFloat/(double)1334*Height_H

//将需要的view添加windoes
#define Window_root(UIView)  [[[UIApplication sharedApplication] keyWindow] addSubview:UIView]

// 设备
/// iPhoneX  iPhoneXS  iPhoneXS Max  iPhoneXR 机型判断
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ((NSInteger)(([[UIScreen mainScreen] currentMode].size.height/[[UIScreen mainScreen] currentMode].size.width)*100) == 216) : NO)


#define kNavBarHeight           (iPhoneX ? 88.0 : 64.0)
#define kBottomBarHeight        (iPhoneX ? 34.0 : 0)
#define kContentHeight          (Height_H - kNavBarHeight-kBottomBarHeight)


#endif /* TFY_Header_h */
