//
//  TfySY_TabBarDefine.h
//  TFY_TabarController
//
//  Created by tiandengyou on 2019/11/25.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#ifndef TfySY_TabBarDefine_h
#define TfySY_TabBarDefine_h

#define TfySY_IsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ((NSInteger)(([[UIScreen mainScreen] currentMode].size.height/[[UIScreen mainScreen] currentMode].size.width)*100) == 216) : NO)

#define WeakSelf __weak typeof(self)weakSelf = self

#define TfySY_TabBarRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define TfySY_TabBarRGB(r,g,b) TfySY_TabBarRGBA(r,g,b,1.0f)

#define TfySY_TabBarItemSlectBlue TfySY_TabBarRGB(59,185,222)
#define TfySY_TabBarItemBadgeRed  TfySY_TabBarRGB(255,38,0)

#endif /* TfySY_TabBarDefine_h */
