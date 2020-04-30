//
//  TFY_TabBarHeader.h
//  TFY_TabarController
//
//  Created by 田风有 on 2019/5/23.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define TFY_AutoLayoutKitRelease 0

#if TFY_AutoLayoutKitRelease
//自定义的
#import <TFY_CustomizeTabBar/TfySY_TabBarController.h>
#import <TFY_CustomizeTabBar/TfyCU_TabBarView.h>
//系统自带
#import <TFY_SystemTabBar/TfySY_TabBarController.h>
#import <TFY_SystemTabBar/TfySY_TestTabBar.h>

#else

//自定义的
#import "TfySY_TabBarController.h"
#import "TfyCU_TabBarView.h"
//系统自带
#import "TfySY_TabBarController.h"
#import "TfySY_TestTabBar.h"

#endif

