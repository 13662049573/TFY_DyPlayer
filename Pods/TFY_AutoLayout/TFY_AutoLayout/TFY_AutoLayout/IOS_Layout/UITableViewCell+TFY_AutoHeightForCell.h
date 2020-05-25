//
//  UITableViewCell+TFY_AutoHeightForCell.h
//  TFY_AutoLayoutModelTools
//
//  Created by 田风有 on 2019/4/30.
//  Copyright © 2019 恋机科技. All rights reserved.
//  https://github.com/13662049573/TFY_AutoLayoutModelTools



#import "TFY_AutoLayoutHerder.h"

#if TARGET_OS_IPHONE || TARGET_OS_TV

@interface UITableViewCell (TFY_AutoHeightForCell)
/**
 *  cell最底部视图
 */
@property(nonatomic , strong)UIView *tfy_CellBottomView;
/**
 *  cell最底部视图集合
 */
@property(nonatomic , strong)NSArray *tfy_CellBottomViewArray;
/**
*  cell最底部视图与cell底部的间隙
*/
@property(nonatomic , assign)CGFloat tfy_CellBottomOffset;
/**
*  cell中包含的UITableView
*/
@property(nonatomic , strong)UITableView *tfy_CellTableView;
/**
*  指定tableview宽度（有助于提高自动计算效率）
*/
@property(nonatomic , assign)CGFloat tfy_TableViewWidth;
/**
*   自动计算cell高度
*/
+(CGFloat)tfy_CellHeightForIndexPath:(NSIndexPath *)indexPath tableVView:(UITableView *)tableView;
/**
*  自动计算cell高度: 重用cell api  identifier 重用标示 block cell 布局回调  cell高度  改api定要实现block回调才能正确计算cell高度
*/
+(CGFloat)tfy_CellHeightForIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView identifier:(NSString *)identifier layoutBlock:(void (^)(UITableViewCell *cell))block;

@end

#endif
