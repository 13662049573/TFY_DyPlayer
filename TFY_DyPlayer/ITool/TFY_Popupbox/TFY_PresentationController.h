//
//  TFY_PresentationController.h
//  TFY_CHESHI
//
//  Created by 田风有 on 2018/8/7.
//  Copyright © 2018年 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFY_PopoverMacro.h"

@interface TFY_PresentationController : UIPresentationController
@property(nonatomic,assign)CGSize           presentedSize;
@property(nonatomic,assign)CGFloat          presentedHeight;
@property(nonatomic,strong)UIView           *coverView;
@property(nonatomic,assign)TFY_PopoverType    popoverType;
@end
