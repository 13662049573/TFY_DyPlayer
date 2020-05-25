//
//  UITableViewCell+TFY_AutoHeightForCell.m
//  TFY_AutoLayoutModelTools
//
//  Created by 田风有 on 2019/4/30.
//  Copyright © 2019 恋机科技. All rights reserved.
//  


#import "UITableViewCell+TFY_AutoHeightForCell.h"

#if TARGET_OS_IPHONE || TARGET_OS_TV

#import <objc/runtime.h>
#import "UIView+TFY_Frame.h"
#import "UIView+TFY_AutoLayout.h"

@interface UITableView (TFY_CacheCellHeight)
@end

@implementation UITableView (TFY_CacheCellHeight)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *actions = @[
                             NSStringFromSelector(@selector(reloadData)),
                             NSStringFromSelector(@selector(reloadRowsAtIndexPaths:withRowAnimation:)),
                             NSStringFromSelector(@selector(reloadSections:withRowAnimation:)),
                             NSStringFromSelector(@selector(deleteItemsAtIndexPaths:)),
                             NSStringFromSelector(@selector(deleteSections:)),
                             NSStringFromSelector(@selector(moveSection:toSection:)),
                             NSStringFromSelector(@selector(moveRowAtIndexPath:toIndexPath:)),
                             NSStringFromSelector(@selector(insertSections:withRowAnimation:)),
                             NSStringFromSelector(@selector(insertRowsAtIndexPaths:withRowAnimation:))
                             ];
        
        for (NSString *str in actions) {
            Method original = class_getInstanceMethod(self, NSSelectorFromString(str));
            Method swizzled = class_getInstanceMethod(self, NSSelectorFromString([@"tfy_" stringByAppendingString:str]));
            method_exchangeImplementations(original, swizzled);
        }
    });
}

-(void)setTfy_CacheHeightDictionary:(NSMutableDictionary *)tfy_CacheHeightDictionary{
    objc_setAssociatedObject(self, @selector(tfy_CacheHeightDictionary), tfy_CacheHeightDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSMutableDictionary *)tfy_CacheHeightDictionary{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)tfy_reloadData{
    if (self.tfy_CacheHeightDictionary != nil) {
        [self.tfy_CacheHeightDictionary removeAllObjects];
    }
    [self tfy_reloadData];
}


-(void)tfy_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    if (indexPaths && self.tfy_CacheHeightDictionary) {
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *cacheHeightKey = @(indexPath.section).stringValue;
            NSMutableDictionary *sectionCacheHeightDictionary = self.tfy_CacheHeightDictionary[cacheHeightKey];
            if (sectionCacheHeightDictionary != nil) {
                [sectionCacheHeightDictionary removeObjectForKey:@(indexPath.row).stringValue];
            }
        }];
    }
    [self tfy_reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}


-(void)tfy_reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    if (sections && self.tfy_CacheHeightDictionary) {
        [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
            [self.tfy_CacheHeightDictionary removeObjectForKey:@(idx).stringValue];
        }];
        [self tfy_handleCacheHeightDictionary];
    }
    [self tfy_reloadSections:sections withRowAnimation:animation];
}

-(void)tfy_deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    if (indexPaths && self.tfy_CacheHeightDictionary) {
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *cacheHeightKey = @(indexPath.section).stringValue;
            NSMutableDictionary *sectionCacheHeightDictionary = self.tfy_CacheHeightDictionary[cacheHeightKey];
            if (sectionCacheHeightDictionary != nil) {
                [sectionCacheHeightDictionary removeObjectForKey:@(indexPath.row).stringValue];
            }
        }];
    }
    [self tfy_deleteItemsAtIndexPaths:indexPaths];
}

-(void)tfy_deleteSections:(NSIndexSet *)sections{
    if (sections && self.tfy_CacheHeightDictionary) {
        [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
            [self.tfy_CacheHeightDictionary removeObjectForKey:@(idx).stringValue];
        }];
        [self tfy_handleCacheHeightDictionary];
    }
    [self tfy_deleteSections:sections];
}

-(void)tfy_moveSection:(NSInteger)section toSection:(NSInteger)newSection{
    if (self.tfy_CacheHeightDictionary) {
        NSMutableDictionary *sectionMap = [NSMutableDictionary dictionaryWithDictionary:self.tfy_CacheHeightDictionary[@(section).stringValue]];
        self.tfy_CacheHeightDictionary[@(section).stringValue] = self.tfy_CacheHeightDictionary[@(newSection).stringValue];
        self.tfy_CacheHeightDictionary[@(newSection).stringValue] = sectionMap;
    }
    [self tfy_moveSection:section toSection:newSection];
}

-(void)tfy_moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath{
    if (indexPath && newIndexPath && self.tfy_CacheHeightDictionary) {
        NSMutableDictionary *indexPathMap = self.tfy_CacheHeightDictionary[@(indexPath.section).stringValue];
        CGFloat indexPathHeight = [indexPathMap[@(indexPath.row).stringValue] floatValue];
        
        NSMutableDictionary *newIndexPathMap = self.tfy_CacheHeightDictionary[@(newIndexPath.section).stringValue];
        CGFloat newIndexPathHeight = [newIndexPathMap[@(newIndexPath.row).stringValue] floatValue];
        
        indexPathMap[@(indexPath.row).stringValue] = @(newIndexPathHeight);
        newIndexPathMap[@(newIndexPath.row).stringValue] = @(indexPathHeight);
    }
    [self tfy_moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
}

-(void)tfy_insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    if (sections && self.tfy_CacheHeightDictionary) {
        NSUInteger firstSection = sections.firstIndex;
        NSUInteger moveSection = self.tfy_CacheHeightDictionary.count;
        if (moveSection > firstSection) {
            for (NSInteger section = firstSection; section < moveSection; section++) {
                NSMutableDictionary *sectionMap = self.tfy_CacheHeightDictionary[@(section).stringValue];
                if (sectionMap != nil) {
                    self.tfy_CacheHeightDictionary[@(section + sections.count).stringValue] = sectionMap;
                    [self.tfy_CacheHeightDictionary removeObjectForKey:@(section)];
                }
            }
        }
    }
    [self tfy_insertSections:sections withRowAnimation:animation];
}

-(void)tfy_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    if (self.tfy_CacheHeightDictionary && indexPaths) {
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *sectionMap = self.tfy_CacheHeightDictionary[@(indexPath.section).stringValue];
            if (sectionMap != nil) {
                NSInteger moveRow = sectionMap.count;
                if (moveRow > indexPath.row) {
                    for (NSInteger index = indexPath.row; index < moveRow; index++) {
                        id heightObject = sectionMap[@(index).stringValue];
                        if (heightObject) {
                            sectionMap[@(index + 1).stringValue] = @([heightObject floatValue]);
                            [sectionMap removeObjectForKey:@(index).stringValue];
                        }
                    }
                }
            }
        }];
    }
    [self tfy_insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

-(void)tfy_handleCacheHeightDictionary{
    if (self.tfy_CacheHeightDictionary) {
        NSArray <NSString *> *allKey = [self.tfy_CacheHeightDictionary.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString  * _Nonnull obj1, NSString  *_Nonnull obj2) {
            return obj1.floatValue < obj2.floatValue;
        }];
        __block NSString *frontKey = nil;
        __block NSInteger index = 0;
        [allKey enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            if (frontKey == nil) {
                frontKey = key;
            }
            else{
                if (key.integerValue - frontKey.integerValue > 1) {
                    if (index == 0) {
                        index = frontKey.integerValue;
                    }
                    [self.tfy_CacheHeightDictionary setObject:self.tfy_CacheHeightDictionary[key] forKey:@(allKey[index].integerValue + 1).stringValue];
                    [self.tfy_CacheHeightDictionary removeObjectForKey:key];
                    index = idx;
                }
                frontKey = key;
            }
        }];
    }
}

@end


@implementation UITableViewCell (TFY_AutoHeightForCell)

-(void)setTfy_CellBottomOffset:(CGFloat)tfy_CellBottomOffset{
    objc_setAssociatedObject(self, @selector(tfy_CellBottomOffset), @(tfy_CellBottomOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(CGFloat)tfy_CellBottomOffset{
    id bottomoffset = objc_getAssociatedObject(self, _cmd);
    return bottomoffset != nil ? [bottomoffset floatValue] : 0;
}

-(void)setTfy_CellBottomViewArray:(NSArray *)tfy_CellBottomViewArray{
    objc_setAssociatedObject(self, @selector(tfy_CellBottomViewArray), tfy_CellBottomViewArray, OBJC_ASSOCIATION_COPY);
}
-(NSArray *)tfy_CellBottomViewArray{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setTfy_CellBottomView:(UIView *)tfy_CellBottomView{
    objc_setAssociatedObject(self, @selector(tfy_CellBottomView), tfy_CellBottomView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIView *)tfy_CellBottomView{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setTfy_CellTableView:(UITableView *)tfy_CellTableView{
    objc_setAssociatedObject(self, @selector(tfy_CellTableView), tfy_CellTableView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UITableView *)tfy_CellTableView{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setTfy_TableViewWidth:(CGFloat)tfy_TableViewWidth{
    objc_setAssociatedObject(self, @selector(tfy_TableViewWidth), @(tfy_TableViewWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(CGFloat)tfy_TableViewWidth{
    id value = objc_getAssociatedObject(self, _cmd);
    return value != nil? [value floatValue] : 0;
}

+(CGFloat)tfy_CellHeightForIndexPath:(NSIndexPath *)indexPath tableVView:(UITableView *)tableView{
    if (tableView.tfy_CacheHeightDictionary == nil) {
        tableView.tfy_CacheHeightDictionary = [NSMutableDictionary dictionary];
    }
    NSString *cacheHeightKey = @(indexPath.section).stringValue;
    NSMutableDictionary *sectionCacheHeightDictionary = tableView.tfy_CacheHeightDictionary[cacheHeightKey];
    if (sectionCacheHeightDictionary != nil) {
        NSNumber *cellHeight = sectionCacheHeightDictionary[@(indexPath.row).stringValue];
        if (cellHeight) {
            return cellHeight.floatValue;
        }
    }
    else{
        sectionCacheHeightDictionary = [NSMutableDictionary dictionary];
        [tableView.tfy_CacheHeightDictionary setObject:sectionCacheHeightDictionary forKey:cacheHeightKey];
    }
    UITableViewCell *cell = [tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell.tfy_CellTableView) {
        [cell.tfy_CellTableView tfy_Height:cell.tfy_CellTableView.contentSize.height];
    }
    CGFloat tableViewWidth = cell.tfy_TableViewWidth;
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
    CGRect contentFrame = cell.contentView.frame;
    contentFrame.size.width = tableViewWidth;
    cell.contentView.frame = contentFrame;
    [cell layoutIfNeeded];
    UIView *bottomView = nil;
    if (cell.tfy_CellBottomView != nil) {
        bottomView = cell.tfy_CellBottomView;
    }
    else if (cell.tfy_CellBottomViewArray != nil && cell.tfy_CellBottomViewArray.count > 0){
        bottomView = cell.tfy_CellBottomViewArray[0];
        for (int i = 1; i < cell.tfy_CellBottomViewArray.count; i++) {
            UIView *view = cell.tfy_CellBottomViewArray[i];
            if (CGRectGetMaxY(bottomView.frame) < CGRectGetMaxY(view.frame)) {
                bottomView = view;
            }
        }
    }
    else{
        NSArray *cellSubViewArray = cell.contentView.subviews;
        if (cellSubViewArray.count > 0) {
            bottomView = cellSubViewArray[0];
            for (int i = 1; i < cellSubViewArray.count; i++) {
                UIView *view = cellSubViewArray[i];
                if (CGRectGetMaxY(bottomView.frame) < CGRectGetMaxY(view.frame)) {
                    bottomView = view;
                }
            }
        }
        else{
            bottomView = cell.contentView;
        }
    }
    CGFloat cacheHeight = CGRectGetMaxY(bottomView.frame) + cell.tfy_CellBottomOffset;
    [sectionCacheHeightDictionary setValue:@(cacheHeight) forKey:@(indexPath.row).stringValue];
    return cacheHeight;
}



+(CGFloat)tfy_CellHeightForIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView identifier:(NSString *)identifier layoutBlock:(void (^)(UITableViewCell *cell))block{
    if (tableView.tfy_CacheHeightDictionary == nil) {
        tableView.tfy_CacheHeightDictionary = [NSMutableDictionary dictionary];
    }
    NSString *cacheHeightKey = @(indexPath.section).stringValue;
    NSMutableDictionary *sectionCacheHeightDictionary = tableView.tfy_CacheHeightDictionary[cacheHeightKey];
    if (sectionCacheHeightDictionary != nil) {
        NSNumber *cellHeight = sectionCacheHeightDictionary[@(indexPath.row).stringValue];
        if (cellHeight) {
            return cellHeight.floatValue;
        }
    }
    else{
        sectionCacheHeightDictionary = [NSMutableDictionary dictionary];
        [tableView.tfy_CacheHeightDictionary setObject:sectionCacheHeightDictionary forKey:cacheHeightKey];
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
    if (cell.tfy_CellTableView) {
        [cell.tfy_CellTableView tfy_Height:cell.tfy_CellTableView.contentSize.height];
    }
    CGFloat tableViewWidth = cell.tfy_TableViewWidth;
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
    if (cell.tfy_CellBottomView != nil) {
        bottomView = cell.tfy_CellBottomView;
    }
    else if(cell.tfy_CellBottomViewArray != nil && cell.tfy_CellBottomViewArray.count > 0){
        bottomView = cell.tfy_CellBottomViewArray[0];
        for (int i = 1; i < cell.tfy_CellBottomViewArray.count; i++) {
            UIView *view = cell.tfy_CellBottomViewArray[i];
            if (CGRectGetMaxY(bottomView.frame) < CGRectGetMaxY(view.frame)) {
                bottomView = view;
            }
        }
    }
    else{
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
    }
    CGFloat cacheHeight = CGRectGetMaxY(bottomView.frame) + cell.tfy_CellBottomOffset;
    [sectionCacheHeightDictionary setValue:@(cacheHeight) forKey:@(indexPath.row).stringValue];
    return cacheHeight;
}
@end

#endif
