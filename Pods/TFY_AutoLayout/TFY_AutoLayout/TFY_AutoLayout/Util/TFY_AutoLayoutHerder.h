//
//  TFY_AutoLayoutHerder.h
//  TFY_AutoLayoutModelTools
//
//  Created by 田风有 on 2019/4/30.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#if TARGET_OS_IPHONE || TARGET_OS_TV

#import <UIKit/UIKit.h>
#define TFY_CLASS_VIEW UIView
#define TFY_CLASS_LGUIDE UILayoutGuide

#define TFY_VIEW NSObject
#define TFY_LayoutPriority UILayoutPriority
#define TFY_ConstraintAxis UILayoutConstraintAxis
#define TFY_COLOR UIColor

#elif TARGET_OS_MAC

#import <AppKit/AppKit.h>
#define TFY_CLASS_VIEW NSView
#define TFY_CLASS_LGUIDE NSLayoutGuide

#define TFY_VIEW NSObject
#define TFY_LayoutPriority NSLayoutPriority
#define TFY_ConstraintAxis NSLayoutConstraintOrientation
#define TFY_COLOR NSColor

#endif


