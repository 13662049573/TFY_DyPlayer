//
//  TFY_AutoLayout.h
//  TFY_AutoLayout
//
//  Created by 田风有 on 2019/5/23.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#define TFY_AutoLayoutKitRelease 0

#if TFY_AutoLayoutKitRelease

#import <TFY_AutoLayout/TFY_CellHeight/UITableViewCell+TFY_AutoHeightForCell.h>
#import <TFY_AutoLayout/TFY_LayoutView/UIView+TFY_AutoLayout.h>
#import <TFY_AutoLayout/UIScrollView+TFY_HeaderScroll.h>
#import <TFY_AutoLayout/UITableView+TFY_LayoutCell.h>

#else

#import "UITableViewCell+TFY_AutoHeightForCell.h"
#import "UIView+TFY_AutoLayout.h"
#import "UIScrollView+TFY_HeaderScroll.h"
#import "UITableView+TFY_LayoutCell.h"

#endif

