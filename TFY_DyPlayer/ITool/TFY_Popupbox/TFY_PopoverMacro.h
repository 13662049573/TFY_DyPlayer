//
//  TFY_PopoverMacro.h
//  TFY_CHESHI
//
//  Created by 田风有 on 2018/8/7.
//  Copyright © 2018年 田风有. All rights reserved.
//  版本 2.5.0

#ifndef TFY_PopoverMacro_h
#define TFY_PopoverMacro_h

#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;

typedef void(^TFY_CompleteHandle)(BOOL presented);

typedef NS_ENUM(NSUInteger, TFY_PopoverType){
    TFY_PopoverTypeActionSheet = 1,
    TFY_PopoverTypeAlert = 2
};


#endif /* TFY_PopoverMacro_h */
