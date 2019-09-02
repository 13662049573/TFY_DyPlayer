//
//  TFY_QuickregistrationCell.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/25.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFY_QuickregistrationModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TFY_QuickregistrationCell : UITableViewCell

@property(nonatomic , strong)Quickitems *models;

@property(nonatomic , strong)NSIndexPath *indexPath;

@property (nonatomic, copy) void(^phonefiledBlock)(NSString *text);

@property (nonatomic, copy) void(^passwordfiledBlock)(NSString *text);

@property (nonatomic, copy) void(^codefiledBlock)(NSString *text);


@end

NS_ASSUME_NONNULL_END
