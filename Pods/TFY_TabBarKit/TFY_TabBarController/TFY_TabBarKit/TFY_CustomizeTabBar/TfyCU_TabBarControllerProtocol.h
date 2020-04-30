//
//  TfyCU_TabBarControllerProtocol.h
//  TFY_TabBarController
//
//  Created by tiandengyou on 2019/11/28.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class TfyCU_TabBar;
@class TfyCU_TabBarView;

@protocol TfyCU_TabBarControllerProtocol <NSObject>

@property (nonatomic, strong, readonly) TfyCU_TabBar *tabBar;

@property (nonatomic, strong, readonly) TfyCU_TabBarView *tabContentView;

@property (nonatomic, copy) NSArray <UIViewController *> *viewControllers;

@end
