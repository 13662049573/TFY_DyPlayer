//
//  UITableViewCell+TFY_TableViewMaker.m
//  TFY_SimplifytableView
//
//  Created by 田风有 on 2019/5/29.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "UITableViewCell+TFY_TableViewMaker.h"
#import "UITableView+TFY_TableViewMaker.h"
#import <objc/runtime.h>

@implementation UITableViewCell (TFY_TableViewMaker)

-(NSIndexPath *)indexPath{
    NSIndexPath *indexPath=objc_getAssociatedObject(self, _cmd);
    return indexPath;
}
-(void)setIndexPath:(NSIndexPath *)indexPath{
    objc_setAssociatedObject(self, @selector(indexPath), indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UITableView *)tableView
{
    UITableView *curTableView = objc_getAssociatedObject(self, _cmd);
    if (curTableView) return curTableView;
    
    return curTableView;
}

- (void)setTableView:(UITableView *)tableView
{
    objc_setAssociatedObject(self, @selector(tableView), tableView, OBJC_ASSOCIATION_ASSIGN);
    
}

- (void)reloadRow:(UITableViewRowAnimation)animation{
    [self.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:animation];
}


+(CGFloat)CellHeightForIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView identifier:(NSString *)identifier layoutBlock:(void (^)(UITableViewCell *cell))block{
    if (tableView.tableViewRegisterCell == nil) {
        tableView.tableViewRegisterCell = [NSMutableDictionary dictionary];
    }
    NSString *cacheHeightKey = @(indexPath.section).stringValue;
    NSMutableDictionary *sectionCacheHeightDictionary = tableView.tableViewRegisterCell[cacheHeightKey];
    if (sectionCacheHeightDictionary != nil) {
        NSNumber *cellHeight = sectionCacheHeightDictionary[@(indexPath.row).stringValue];
        if (cellHeight) {
            return cellHeight.floatValue;
        }
    }
    else{
        sectionCacheHeightDictionary = [NSMutableDictionary dictionary];
        [tableView.tableViewRegisterCell setObject:sectionCacheHeightDictionary forKey:cacheHeightKey];
    }
    UITableViewCell *cell = nil;
    if (identifier && identifier.length > 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (block) {
            block(cell);
        }
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
    }
    else{
        cell = [tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    CGFloat tableViewWidth = 0;
    if (tableViewWidth == 0) {
        [tableView layoutIfNeeded];
        tableViewWidth = CGRectGetWidth(tableView.frame);
    }
    if (tableViewWidth == 0) {
        return 0;
    }
    CGRect cellFrame = cell.frame;
    cellFrame.size.width = tableViewWidth;
    cell.frame = cellFrame;
    CGRect contenFrame = cell.contentView.frame;
    contenFrame.size.width = tableViewWidth;
    cell.contentView.frame = contenFrame;
    [cell layoutIfNeeded];
    
    UIView *bottomView = nil;
    
    NSArray *cellSubViewArray = cell.contentView.subviews;
    if (cellSubViewArray.count > 0) {
        bottomView = cellSubViewArray[0];
        for (int i =1; i < cellSubViewArray.count; i++) {
            UIView *view = cellSubViewArray[i];
            if (CGRectGetMaxY(bottomView.frame) < CGRectGetMaxY(view.frame)) {
                bottomView = view;
            }
        }
    }
    else{
        bottomView = cell.contentView;
    }
    CGFloat cacheHeight = CGRectGetMaxY(bottomView.frame);
    [sectionCacheHeightDictionary setValue:@(cacheHeight) forKey:@(indexPath.row).stringValue];
    return cacheHeight;
}

@end
