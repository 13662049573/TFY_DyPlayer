//
//  TFY_MycollectionViewCell.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/16.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_MycollectionViewCell : UITableViewCell

+ (instancetype)infoCellWithTableView:(UITableView *)tableView;

@property(nonatomic , strong)TFY_CollectionModel *models;

@property(nonatomic , strong)NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END
