//
//  TFY_PlayerToolsHeader.h
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/7/1.
//  Copyright © 2019 田风有. All rights reserved.
//

#ifndef TFY_PlayerToolsHeader_h
#define TFY_PlayerToolsHeader_h

// 屏幕尺寸
#define TFY_PLAYER_ScreenW  [UIScreen mainScreen].bounds.size.width
#define TFY_PLAYER_ScreenH  [UIScreen mainScreen].bounds.size.height

#define TFY_PLAYER_WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//等比宽
#define TFY_PLAYER_DEBI_WIDTH(CGFloat) (double)CGFloat/(double)375*PLAYER_ScreenW
//等比高
#define TFY_PLAYER_DEBI_HEIGHT(CGFloat) (double)CGFloat/(double)667*PLAYER_ScreenH


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "TFY_PlayerController.h"
#import "TFY_AVPlayerManager.h"
#import "TFY_PlayerGestureControl.h"
#import "TFY_PlayerNotification.h"
#import "TFY_PlayerMediaControl.h"
#import "TFY_PlayerMediaPlayback.h"
#import "TFY_PlayerBaseView.h"
#import "TFY_FloatView.h"
#import "TFY_KVOController.h"
#import "TFY_ReachabilityManager.h"
#import "UIScrollView+TFY_Player.h"
#import "TFY_OrientationObserver.h"
#import "TFY_NetworkSpeedMonitor.h"
#import "TFY_LoadingView.h"
#import "TFY_PlayerVideoModel.h"

#endif /* TFY_PlayerToolsHeader_h */
