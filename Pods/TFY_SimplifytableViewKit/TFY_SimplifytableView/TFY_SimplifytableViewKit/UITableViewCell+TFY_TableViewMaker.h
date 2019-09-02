//
//  UITableViewCell+TFY_TableViewMaker.h
//  TFY_SimplifytableView
//
//  Created by 田风有 on 2019/5/29.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (TFY_TableViewMaker)
/**
 *  创建tableview
 */
@property (nonatomic,weak) UITableView *tableView;
/**
 *  行数
 */
@property (nonatomic, strong) NSIndexPath *indexPath;
/**
 *  动画
 */
- (void)reloadRow:(UITableViewRowAnimation)animation;
/**
 * 计算高度
 */
+(CGFloat)CellHeightForIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView identifier:(NSString *)identifier layoutBlock:(void (^)(UITableViewCell *cell))block;
@end

NS_ASSUME_NONNULL_END
