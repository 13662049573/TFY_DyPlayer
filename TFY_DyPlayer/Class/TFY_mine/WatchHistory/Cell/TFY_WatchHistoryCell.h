//
//  TFY_WatchHistoryCell.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/10.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_WatchHistoryCell : UITableViewCell

@property(nonatomic , strong)TFY_PlayerVideoModel *models;

+ (instancetype)infoCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
