//
//  UIScrollView+TFY_Player.m
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/30.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "UIScrollView+TFY_Player.h"
#import <objc/runtime.h>
#import "TFY_ReachabilityManager.h"
#import "TFY_KVOController.h"
#import "TFY_PlayerToolsHeader.h"


#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

@interface UIScrollView ()
@property (nonatomic) CGFloat tfy_lastOffsetY;
@property (nonatomic) CGFloat tfy_lastOffsetX;
@property (nonatomic) PlayerScrollDirection tfy_scrollDirection;
@end


@implementation UIScrollView (TFY_Player)

- (void)tfy_scrollViewDidStopScroll {
    [self tfy_filterShouldPlayCellWhileScrolled:^(NSIndexPath * _Nonnull indexPath) {
        
        if (self.tfy_scrollViewDidStopScrollCallback) self.tfy_scrollViewDidStopScrollCallback(indexPath);
    }];
}

- (void)tfy_scrollViewBeginDragging {
    if (self.tfy_scrollViewDirection == PlayerScrollViewDirectionVertical) {
        self.tfy_lastOffsetY = self.contentOffset.y;
    } else {
        self.tfy_lastOffsetX = self.contentOffset.x;
    }
}

/**
 垂直滚动中处理的滚动百分比。
 */
- (void)tfy_scrollViewScrollingDirectionVertical {
    CGFloat offsetY = self.contentOffset.y;
    self.tfy_scrollDirection = (offsetY - self.tfy_lastOffsetY > 0) ? PlayerScrollDirectionUp : PlayerScrollDirectionDown;
    self.tfy_lastOffsetY = offsetY;
    if (self.tfy_stopPlay) return;
    
    UIView *playerView;
    if (self.tfy_containerType == PlayerContainerTypeCell) {
        // Avoid being paused the first time you play it.
        if (self.contentOffset.y < 0) return;
        if (!self.tfy_playingIndexPath) return;
        
        UIView *cell = [self tfy_getCellForIndexPath:self.tfy_playingIndexPath];
        if (!cell) {
            if (self.tfy_playerDidDisappearInScrollView) self.tfy_playerDidDisappearInScrollView(self.tfy_playingIndexPath);
            return;
        }
        playerView = [cell viewWithTag:self.tfy_containerViewTag];
    } else if (self.tfy_containerType == PlayerContainerTypeView) {
        if (!self.tfy_containerView) return;
        playerView = self.tfy_containerView;
    }
    
    CGRect rect1 = [playerView convertRect:playerView.frame toView:self];
    CGRect rect = [self convertRect:rect1 toView:self.superview];
    /// playerView top to scrollView顶部空间。
    CGFloat topSpacing = CGRectGetMinY(rect) - CGRectGetMinY(self.frame) - CGRectGetMinY(playerView.frame);
    /// playerView底部滚动查看底部空间。
    CGFloat bottomSpacing = CGRectGetMaxY(self.frame) - CGRectGetMaxY(rect) + CGRectGetMinY(playerView.frame);
    /// 内容区域的高度。
    CGFloat contentInsetHeight = CGRectGetMaxY(self.frame) - CGRectGetMinY(self.frame);
    
    CGFloat playerDisapperaPercent = 0;
    CGFloat playerApperaPercent = 0;
    
    if (self.tfy_scrollDirection == PlayerScrollDirectionUp) { /// 向上滑动
        /// 播放正在消失。
        if (topSpacing <= 0 && CGRectGetHeight(rect) != 0) {
            playerDisapperaPercent = -topSpacing/CGRectGetHeight(rect);
            if (playerDisapperaPercent > 1.0) playerDisapperaPercent = 1.0;
            if (self.tfy_playerDisappearingInScrollView) self.tfy_playerDisappearingInScrollView(self.tfy_playingIndexPath, playerDisapperaPercent);
        }
        
        /// 顶部区域
        if (topSpacing <= 0 && topSpacing > -CGRectGetHeight(rect)/2) {
            /// 当播放消失时。
            if (self.tfy_playerWillDisappearInScrollView) self.tfy_playerWillDisappearInScrollView(self.tfy_playingIndexPath);
        } else if (topSpacing <= -CGRectGetHeight(rect)) {
            /// 当播放确实消失了。
            if (self.tfy_playerDidDisappearInScrollView) self.tfy_playerDidDisappearInScrollView(self.tfy_playingIndexPath);
        } else if (topSpacing > 0 && topSpacing <= contentInsetHeight) {
            ///播放正在出现。
            if (CGRectGetHeight(rect) != 0) {
                playerApperaPercent = -(topSpacing-contentInsetHeight)/CGRectGetHeight(rect);
                if (playerApperaPercent > 1.0) playerApperaPercent = 1.0;
                if (self.tfy_playerAppearingInScrollView) self.tfy_playerAppearingInScrollView(self.tfy_playingIndexPath, playerApperaPercent);
            }
            /// 在可见区域
            if (topSpacing <= contentInsetHeight && topSpacing > contentInsetHeight-CGRectGetHeight(rect)/2) {
                /// 当播放出现时。
                if (self.tfy_playerWillAppearInScrollView) self.tfy_playerWillAppearInScrollView(self.tfy_playingIndexPath);
            } else {
                /// 当播放出现时。
                if (self.tfy_playerDidAppearInScrollView) self.tfy_playerDidAppearInScrollView(self.tfy_playingIndexPath);
            }
        }
        
    } else if (self.tfy_scrollDirection == PlayerScrollDirectionDown) { /// 向下滚动
        /// 播放正在消失。
        if (bottomSpacing <= 0 && CGRectGetHeight(rect) != 0) {
            playerDisapperaPercent = -bottomSpacing/CGRectGetHeight(rect);
            if (playerDisapperaPercent > 1.0) playerDisapperaPercent = 1.0;
            if (self.tfy_playerDisappearingInScrollView) self.tfy_playerDisappearingInScrollView(self.tfy_playingIndexPath, playerDisapperaPercent);
        }
        
        ///底部区域
        if (bottomSpacing <= 0 && bottomSpacing > -CGRectGetHeight(rect)/2) {
            /// 当播放消失时。
            if (self.tfy_playerWillDisappearInScrollView) self.tfy_playerWillDisappearInScrollView(self.tfy_playingIndexPath);
        } else if (bottomSpacing <= -CGRectGetHeight(rect)) {
            /// 当播放确实消失了。
            if (self.tfy_playerDidDisappearInScrollView) self.tfy_playerDidDisappearInScrollView(self.tfy_playingIndexPath);
        } else if (bottomSpacing > 0 && bottomSpacing <= contentInsetHeight) {
            /// 播放正在出现。
            if (CGRectGetHeight(rect) != 0) {
                playerApperaPercent = -(bottomSpacing-contentInsetHeight)/CGRectGetHeight(rect);
                if (playerApperaPercent > 1.0) playerApperaPercent = 1.0;
                if (self.tfy_playerAppearingInScrollView) self.tfy_playerAppearingInScrollView(self.tfy_playingIndexPath, playerApperaPercent);
            }
            /// 在可见区域
            if (bottomSpacing <= contentInsetHeight && bottomSpacing > contentInsetHeight-CGRectGetHeight(rect)/2) {
                /// 当播放出现时。
                if (self.tfy_playerWillAppearInScrollView) self.tfy_playerWillAppearInScrollView(self.tfy_playingIndexPath);
            } else {
                /// 当播放出现时。
                if (self.tfy_playerDidAppearInScrollView) self.tfy_playerDidAppearInScrollView(self.tfy_playingIndexPath);
            }
        }
    }
}

/**
 在水平滚动中处理的滚动百分比。
 */
- (void)tfy_scrollViewScrollingDirectionHorizontal {
    CGFloat offsetX = self.contentOffset.x;
    self.tfy_scrollDirection = (offsetX - self.tfy_lastOffsetX > 0) ? PlayerScrollDirectionLeft : PlayerScrollDirectionRight;
    self.tfy_lastOffsetX = offsetX;
    if (self.tfy_stopPlay) return;
    
    UIView *playerView;
    if (self.tfy_containerType == PlayerContainerTypeCell) {
        // 第一次玩它时避免被暂停。
        if (self.contentOffset.x < 0) return;
        if (!self.tfy_playingIndexPath) return;
        
        UIView *cell = [self tfy_getCellForIndexPath:self.tfy_playingIndexPath];
        if (!cell) {
            if (self.tfy_playerDidDisappearInScrollView) self.tfy_playerDidDisappearInScrollView(self.tfy_playingIndexPath);
            return;
        }
        playerView = [cell viewWithTag:self.tfy_containerViewTag];
    } else if (self.tfy_containerType == PlayerContainerTypeView) {
        if (!self.tfy_containerView) return;
        playerView = self.tfy_containerView;
    }
    
    CGRect rect1 = [playerView convertRect:playerView.frame toView:self];
    CGRect rect = [self convertRect:rect1 toView:self.superview];
    /// playerView左侧滚动查看左侧空间。
    CGFloat leftSpacing = CGRectGetMinX(rect) - CGRectGetMinX(self.frame) - CGRectGetMinX(playerView.frame);
    /// playerView底部滚动查看右侧空间。
    CGFloat rightSpacing = CGRectGetMaxX(self.frame) - CGRectGetMaxX(rect) + CGRectGetMinX(playerView.frame);
    /// 内容区域的高度。
    CGFloat contentInsetWidth = CGRectGetMaxX(self.frame) - CGRectGetMinX(self.frame);
    
    CGFloat playerDisapperaPercent = 0;
    CGFloat playerApperaPercent = 0;
    
    if (self.tfy_scrollDirection == PlayerScrollDirectionLeft) { /// 向左滚动
        /// 播放正在消失。
        if (leftSpacing <= 0 && CGRectGetWidth(rect) != 0) {
            playerDisapperaPercent = -leftSpacing/CGRectGetWidth(rect);
            if (playerDisapperaPercent > 1.0) playerDisapperaPercent = 1.0;
            if (self.tfy_playerDisappearingInScrollView) self.tfy_playerDisappearingInScrollView(self.tfy_playingIndexPath, playerDisapperaPercent);
        }
        
        ///顶部区域
        if (leftSpacing <= 0 && leftSpacing > -CGRectGetWidth(rect)/2) {
            /// 当播放消失时。
            if (self.tfy_playerWillDisappearInScrollView) self.tfy_playerWillDisappearInScrollView(self.tfy_playingIndexPath);
        } else if (leftSpacing <= -CGRectGetWidth(rect)) {
            /// 当播放确实消失了。
            if (self.tfy_playerDidDisappearInScrollView) self.tfy_playerDidDisappearInScrollView(self.tfy_playingIndexPath);
        } else if (leftSpacing > 0 && leftSpacing <= contentInsetWidth) {
            ///播放正在出现。
            if (CGRectGetWidth(rect) != 0) {
                playerApperaPercent = -(leftSpacing-contentInsetWidth)/CGRectGetWidth(rect);
                if (playerApperaPercent > 1.0) playerApperaPercent = 1.0;
                if (self.tfy_playerAppearingInScrollView) self.tfy_playerAppearingInScrollView(self.tfy_playingIndexPath, playerApperaPercent);
            }
            /// 在可见区域
            if (leftSpacing <= contentInsetWidth && leftSpacing > contentInsetWidth-CGRectGetWidth(rect)/2) {
                /// 当播放出现时。
                if (self.tfy_playerWillAppearInScrollView) self.tfy_playerWillAppearInScrollView(self.tfy_playingIndexPath);
            } else {
                /// 当播放出现时。
                if (self.tfy_playerDidAppearInScrollView) self.tfy_playerDidAppearInScrollView(self.tfy_playingIndexPath);
            }
        }
        
    } else if (self.tfy_scrollDirection == PlayerScrollDirectionRight) { /// 向右滚动
        /// 播放正在消失。
        if (rightSpacing <= 0 && CGRectGetWidth(rect) != 0) {
            playerDisapperaPercent = -rightSpacing/CGRectGetWidth(rect);
            if (playerDisapperaPercent > 1.0) playerDisapperaPercent = 1.0;
            if (self.tfy_playerDisappearingInScrollView) self.tfy_playerDisappearingInScrollView(self.tfy_playingIndexPath, playerDisapperaPercent);
        }
        
        /// 底部区域
        if (rightSpacing <= 0 && rightSpacing > -CGRectGetWidth(rect)/2) {
            /// 当播放消失时。
            if (self.tfy_playerWillDisappearInScrollView) self.tfy_playerWillDisappearInScrollView(self.tfy_playingIndexPath);
        } else if (rightSpacing <= -CGRectGetWidth(rect)) {
            ///当播放确实消失了。
            if (self.tfy_playerDidDisappearInScrollView) self.tfy_playerDidDisappearInScrollView(self.tfy_playingIndexPath);
        } else if (rightSpacing > 0 && rightSpacing <= contentInsetWidth) {
            /// 播放正在出现。
            if (CGRectGetWidth(rect) != 0) {
                playerApperaPercent = -(rightSpacing-contentInsetWidth)/CGRectGetWidth(rect);
                if (playerApperaPercent > 1.0) playerApperaPercent = 1.0;
                if (self.tfy_playerAppearingInScrollView) self.tfy_playerAppearingInScrollView(self.tfy_playingIndexPath, playerApperaPercent);
            }
            /// 在可见区域
            if (rightSpacing <= contentInsetWidth && rightSpacing > contentInsetWidth-CGRectGetWidth(rect)/2) {
                /// 当播放出现时。
                if (self.tfy_playerWillAppearInScrollView) self.tfy_playerWillAppearInScrollView(self.tfy_playingIndexPath);
            } else {
                /// 当播放出现时。
                if (self.tfy_playerDidAppearInScrollView) self.tfy_playerDidAppearInScrollView(self.tfy_playingIndexPath);
            }
        }
    }
}

/**
 在scrollDirection为垂直时找到播放单元格。
 */
- (void)tfy_findCorrectCellWhenScrollViewDirectionVertical:(void (^ __nullable)(NSIndexPath *indexPath))handler {
    if (!self.tfy_shouldAutoPlay) return;
    if (self.tfy_containerType == PlayerContainerTypeView) return;
    
    NSArray *visiableCells = nil;
    NSIndexPath *indexPath = nil;
    if ([self isTableView]) {
        UITableView *tableView = (UITableView *)self;
        visiableCells = [tableView visibleCells];
        // 第一个可见单元索引路径
        indexPath = tableView.indexPathsForVisibleRows.firstObject;
        if (self.contentOffset.y <= 0 && (!self.tfy_playingIndexPath || [indexPath compare:self.tfy_playingIndexPath] == NSOrderedSame)) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.tfy_containerViewTag];
            if (playerView) {
                if (handler) handler(indexPath);
                self.tfy_shouldPlayIndexPath = indexPath;
                return;
            }
        }
        
        // 最后一个可见单元格indexPath
        indexPath = tableView.indexPathsForVisibleRows.lastObject;
        if (self.contentOffset.y + self.frame.size.height >= self.contentSize.height && (!self.tfy_playingIndexPath || [indexPath compare:self.tfy_playingIndexPath] == NSOrderedSame)) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.tfy_containerViewTag];
            if (playerView) {
                if (handler) handler(indexPath);
                self.tfy_shouldPlayIndexPath = indexPath;
                return;
            }
        }
    } else if ([self isCollectionView]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        visiableCells = [collectionView visibleCells];
        NSArray *sortedIndexPaths = [collectionView.indexPathsForVisibleItems sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }];
        
        visiableCells = [visiableCells sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSIndexPath *path1 = (NSIndexPath *)[collectionView indexPathForCell:obj1];
            NSIndexPath *path2 = (NSIndexPath *)[collectionView indexPathForCell:obj2];
            return [path1 compare:path2];
        }];
        
        // 第一个可见单元索引路径
        indexPath = sortedIndexPaths.firstObject;
        if (self.contentOffset.y <= 0 && (!self.tfy_playingIndexPath || [indexPath compare:self.tfy_playingIndexPath] == NSOrderedSame)) {
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.tfy_containerViewTag];
            if (playerView) {
                if (handler) handler(indexPath);
                self.tfy_shouldPlayIndexPath = indexPath;
                return;
            }
        }
        
        // 最后一个可见单元格indexPath
        indexPath = sortedIndexPaths.lastObject;
        if (self.contentOffset.y + self.frame.size.height >= self.contentSize.height && (!self.tfy_playingIndexPath || [indexPath compare:self.tfy_playingIndexPath] == NSOrderedSame)) {
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.tfy_containerViewTag];
            if (playerView) {
                if (handler) handler(indexPath);
                self.tfy_shouldPlayIndexPath = indexPath;
                return;
            }
        }
    }
    
    NSArray *cells = nil;
    if (self.tfy_scrollDirection == PlayerScrollDirectionUp) {
        cells = visiableCells;
    } else {
        cells = [visiableCells reverseObjectEnumerator].allObjects;
    }
    
    /// 中线。
    CGFloat scrollViewMidY = CGRectGetHeight(self.frame)/2;
    /// T他最后玩indexPath。
    __block NSIndexPath *finalIndexPath = nil;
    /// 距离中心线的最终距离。
    __block CGFloat finalSpace = 0;
    TFY_PLAYER_WS(myself);
    [cells enumerateObjectsUsingBlock:^(UIView *cell, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIView *playerView = [cell viewWithTag:myself.tfy_containerViewTag];
        if (!playerView) return;
        CGRect rect1 = [playerView convertRect:playerView.frame toView:myself];
        CGRect rect = [myself convertRect:rect1 toView:myself.superview];
        /// playerView top to scrollView顶部空间。
        CGFloat topSpacing = CGRectGetMinY(rect) - CGRectGetMinY(myself.frame) - CGRectGetMinY(playerView.frame);
        /// playerView底部滚动查看底部空间。
        CGFloat bottomSpacing = CGRectGetMaxY(myself.frame) - CGRectGetMaxY(rect) + CGRectGetMinY(playerView.frame);
        CGFloat centerSpacing = ABS(scrollViewMidY - CGRectGetMidY(rect));
        NSIndexPath *indexPath = [myself tfy_getIndexPathForCell:cell];
        
        /// 视频播放部分可见时播放。
        if ((topSpacing >= -(1 - myself.tfy_playerApperaPercent) * CGRectGetHeight(rect)) && (bottomSpacing >= -(1 - myself.tfy_playerApperaPercent) * CGRectGetHeight(rect))) {
            /// 如果您正在播放正在播放的小区，请停止遍历。
            if (myself.tfy_playingIndexPath) {
                indexPath = myself.tfy_playingIndexPath;
                finalIndexPath = indexPath;
                *stop = YES;
                return;
            }
            if (!finalIndexPath || centerSpacing < finalSpace) {
                finalIndexPath = indexPath;
                finalSpace = centerSpacing;
            }
        }
    }];
    /// 如果找到播放indexPath。
    if (finalIndexPath) {
        if (handler) handler(finalIndexPath);
        self.tfy_shouldPlayIndexPath = finalIndexPath;
    }
}

/**
 在scrollDirection为水平时找到播放单元格。
 */
- (void)tfy_findCorrectCellWhenScrollViewDirectionHorizontal:(void (^ __nullable)(NSIndexPath *indexPath))handler {
    if (!self.tfy_shouldAutoPlay) return;
    if (self.tfy_containerType == PlayerContainerTypeView) return;
    
    NSArray *visiableCells = nil;
    NSIndexPath *indexPath = nil;
    if ([self isTableView]) {
        UITableView *tableView = (UITableView *)self;
        visiableCells = [tableView visibleCells];
        // 第一个可见单元索引路径
        indexPath = tableView.indexPathsForVisibleRows.firstObject;
        if (self.contentOffset.x <= 0 && (!self.tfy_playingIndexPath || [indexPath compare:self.tfy_playingIndexPath] == NSOrderedSame)) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.tfy_containerViewTag];
            if (playerView) {
                if (handler) handler(indexPath);
                self.tfy_shouldPlayIndexPath = indexPath;
                return;
            }
        }
        
        //最后一个可见单元格indexPath
        indexPath = tableView.indexPathsForVisibleRows.lastObject;
        if (self.contentOffset.x + self.frame.size.width >= self.contentSize.width && (!self.tfy_playingIndexPath || [indexPath compare:self.tfy_playingIndexPath] == NSOrderedSame)) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.tfy_containerViewTag];
            if (playerView) {
                if (handler) handler(indexPath);
                self.tfy_shouldPlayIndexPath = indexPath;
                return;
            }
        }
    } else if ([self isCollectionView]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        visiableCells = [collectionView visibleCells];
        NSArray *sortedIndexPaths = [collectionView.indexPathsForVisibleItems sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }];
        
        visiableCells = [visiableCells sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSIndexPath *path1 = (NSIndexPath *)[collectionView indexPathForCell:obj1];
            NSIndexPath *path2 = (NSIndexPath *)[collectionView indexPathForCell:obj2];
            return [path1 compare:path2];
        }];
        
        // 第一个可见单元索引路径
        indexPath = sortedIndexPaths.firstObject;
        if (self.contentOffset.x <= 0 && (!self.tfy_playingIndexPath || [indexPath compare:self.tfy_playingIndexPath] == NSOrderedSame)) {
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.tfy_containerViewTag];
            if (playerView) {
                if (handler) handler(indexPath);
                self.tfy_shouldPlayIndexPath = indexPath;
                return;
            }
        }
        
        // 最后一个可见单元格indexPath
        indexPath = sortedIndexPaths.lastObject;
        if (self.contentOffset.x + self.frame.size.width >= self.contentSize.width && (!self.tfy_playingIndexPath || [indexPath compare:self.tfy_playingIndexPath] == NSOrderedSame)) {
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.tfy_containerViewTag];
            if (playerView) {
                if (handler) handler(indexPath);
                self.tfy_shouldPlayIndexPath = indexPath;
                return;
            }
        }
    }
    
    NSArray *cells = nil;
    if (self.tfy_scrollDirection == PlayerScrollDirectionUp) {
        cells = visiableCells;
    } else {
        cells = [visiableCells reverseObjectEnumerator].allObjects;
    }
    
    /// 中线。
    CGFloat scrollViewMidX = CGRectGetWidth(self.frame)/2;
    /// 最后播放indexPath。
    __block NSIndexPath *finalIndexPath = nil;
    /// 距离中心线的最终距离。
    __block CGFloat finalSpace = 0;
    TFY_PLAYER_WS(myself);
    [cells enumerateObjectsUsingBlock:^(UIView *cell, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIView *playerView = [cell viewWithTag:myself.tfy_containerViewTag];
        if (!playerView) return;
        CGRect rect1 = [playerView convertRect:playerView.frame toView:myself];
        CGRect rect = [myself convertRect:rect1 toView:myself.superview];
        /// playerView左侧滚动查看顶部空间。
        CGFloat leftSpacing = CGRectGetMinX(rect) - CGRectGetMinX(myself.frame) - CGRectGetMinX(playerView.frame);
        /// playerView右侧滚动查看顶部空间。
        CGFloat rightSpacing = CGRectGetMaxX(myself.frame) - CGRectGetMaxX(rect) + CGRectGetMinX(playerView.frame);
        CGFloat centerSpacing = ABS(scrollViewMidX - CGRectGetMidX(rect));
        NSIndexPath *indexPath = [myself tfy_getIndexPathForCell:cell];
        
        /// 视频播放部分可见时播放。
        if ((leftSpacing >= -(1 - myself.tfy_playerApperaPercent) * CGRectGetWidth(rect)) && (rightSpacing >= -(1 - myself.tfy_playerApperaPercent) * CGRectGetWidth(rect))) {
            /// 如果您正在播放正在播放的小区，请停止遍历。
            if (myself.tfy_playingIndexPath) {
                indexPath = myself.tfy_playingIndexPath;
                finalIndexPath = indexPath;
                *stop = YES;
                return;
            }
            if (!finalIndexPath || centerSpacing < finalSpace) {
                finalIndexPath = indexPath;
                finalSpace = centerSpacing;
            }
        }
    }];
    /// 如果找到播放indexPath。
    if (finalIndexPath) {
        if (handler) handler(finalIndexPath);
        self.tfy_shouldPlayIndexPath = finalIndexPath;
    }
}

- (BOOL)isTableView {
    return [self isKindOfClass:[UITableView class]];
}

- (BOOL)isCollectionView {
    return [self isKindOfClass:[UICollectionView class]];
}

- (NSIndexPath *)tfy_getIndexPathForCell:(UIView *)cell {
    if ([self isTableView]) {
        UITableView *tableView = (UITableView *)self;
        NSIndexPath *indexPath = [tableView indexPathForCell:(UITableViewCell *)cell];
        return indexPath;
    } else if ([self isCollectionView]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        NSIndexPath *indexPath = [collectionView indexPathForCell:(UICollectionViewCell *)cell];
        return indexPath;
    }
    return nil;
}

#pragma mark - public method

- (void)tfy_filterShouldPlayCellWhileScrolling:(void (^ __nullable)(NSIndexPath *indexPath))handler {
    if (self.tfy_scrollViewDirection == PlayerScrollViewDirectionVertical) {
        [self tfy_findCorrectCellWhenScrollViewDirectionVertical:handler];
    } else {
        [self tfy_findCorrectCellWhenScrollViewDirectionHorizontal:handler];
    }
}

- (void)tfy_filterShouldPlayCellWhileScrolled:(void (^ __nullable)(NSIndexPath *indexPath))handler {
    if (!self.tfy_shouldAutoPlay) return;
    TFY_PLAYER_WS(myself);
    [self tfy_filterShouldPlayCellWhileScrolling:^(NSIndexPath *indexPath) {
        
        /// 如果当前控制器已经消失，直接return
        if (myself.tfy_viewControllerDisappear) return;
        if ([TFY_ReachabilityManager sharedManager].isReachableViaWWAN && !myself.tfy_WWANAutoPlay) {
            /// 移动网络
            self.tfy_shouldPlayIndexPath = indexPath;
            return;
        }
        if (handler) handler(indexPath);
        self.tfy_playingIndexPath = indexPath;
    }];
}

- (UIView *)tfy_getCellForIndexPath:(NSIndexPath *)indexPath {
    if ([self isTableView]) {
        UITableView *tableView = (UITableView *)self;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        return cell;
    } else if ([self isCollectionView]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        return cell;
    }
    return [UIView new];
}

- (void)tfy_scrollToRowAtIndexPath:(NSIndexPath *)indexPath completionHandler:(void (^ __nullable)(void))completionHandler {
    [self tfy_scrollToRowAtIndexPath:indexPath animated:YES completionHandler:completionHandler];
}

- (void)tfy_scrollToRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated completionHandler:(void (^ __nullable)(void))completionHandler {
    [self tfy_scrollToRowAtIndexPath:indexPath animateWithDuration:animated ? 0.4 : 0.0 completionHandler:completionHandler];
}

/// 使用动画持续时间滚动到indexPath
- (void)tfy_scrollToRowAtIndexPath:(NSIndexPath *)indexPath animateWithDuration:(NSTimeInterval)duration completionHandler:(void (^ __nullable)(void))completionHandler {
    BOOL animated = duration > 0.0;
    if ([self isTableView]) {
        UITableView *tableView = (UITableView *)self;
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:animated];
    } else if ([self isCollectionView]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:animated];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (completionHandler) completionHandler();
    });
}

- (void)tfy_scrollViewDidEndDecelerating {
    BOOL scrollToScrollStop = !self.tracking && !self.dragging && !self.decelerating;
    if (scrollToScrollStop) {
        [self tfy_scrollViewDidStopScroll];
    }
}

- (void)tfy_scrollViewDidEndDraggingWillDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        BOOL dragToDragStop = self.tracking && !self.dragging && !self.decelerating;
        if (dragToDragStop) {
            [self tfy_scrollViewDidStopScroll];
        }
    }
}

- (void)tfy_scrollViewDidScrollToTop {
    [self tfy_scrollViewDidStopScroll];
}

- (void)tfy_scrollViewDidScroll {
    if (self.tfy_scrollViewDirection == PlayerScrollViewDirectionVertical) {
        [self tfy_scrollViewScrollingDirectionVertical];
    } else {
        [self tfy_scrollViewScrollingDirectionHorizontal];
    }
}

- (void)tfy_scrollViewWillBeginDragging {
    [self tfy_scrollViewBeginDragging];
}

#pragma mark - getter

-(NSIndexPath *)tfy_playingIndexPath{
    return objc_getAssociatedObject(self, _cmd);
}
- (NSIndexPath *)tfy_shouldPlayIndexPath {
    return objc_getAssociatedObject(self, _cmd);
}

- (NSInteger)tfy_containerViewTag {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (PlayerScrollDirection)tfy_scrollDirection {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (BOOL)tfy_stopWhileNotVisible {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (BOOL)tfy_isWWANAutoPlay {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (BOOL)tfy_shouldAutoPlay {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number.boolValue) return number.boolValue;
    self.tfy_shouldAutoPlay = YES;
    return YES;
}

- (PlayerScrollViewDirection)tfy_scrollViewDirection {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (BOOL)tfy_stopPlay {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (PlayerContainerType)tfy_containerType {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (UIView *)tfy_containerView {
    return objc_getAssociatedObject(self, _cmd);
}

- (CGFloat)tfy_lastOffsetY {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (CGFloat)tfy_lastOffsetX {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void (^)(NSIndexPath * _Nonnull))tfy_scrollViewDidStopScrollCallback {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))tfy_shouldPlayIndexPathCallback {
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - setter

- (void)setTfy_playingIndexPath:(NSIndexPath *)tfy_playingIndexPath {
    objc_setAssociatedObject(self, @selector(tfy_playingIndexPath), tfy_playingIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (tfy_playingIndexPath) self.tfy_shouldPlayIndexPath = tfy_playingIndexPath;
}

- (void)setTfy_shouldPlayIndexPath:(NSIndexPath *)tfy_shouldPlayIndexPath {
    if (self.tfy_shouldPlayIndexPathCallback) self.tfy_shouldPlayIndexPathCallback(tfy_shouldPlayIndexPath);
    objc_setAssociatedObject(self, @selector(tfy_shouldPlayIndexPath), tfy_shouldPlayIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTfy_containerViewTag:(NSInteger)tfy_containerViewTag {
    objc_setAssociatedObject(self, @selector(tfy_containerViewTag), @(tfy_containerViewTag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTfy_scrollDirection:(PlayerScrollDirection)tfy_scrollDirection {
    objc_setAssociatedObject(self, @selector(tfy_scrollDirection), @(tfy_scrollDirection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTfy_stopWhileNotVisible:(BOOL)tfy_stopWhileNotVisible {
    objc_setAssociatedObject(self, @selector(tfy_stopWhileNotVisible), @(tfy_stopWhileNotVisible), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTfy_WWANAutoPlay:(BOOL)tfy_WWANAutoPlay {
    objc_setAssociatedObject(self, @selector(tfy_isWWANAutoPlay), @(tfy_WWANAutoPlay), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTfy_scrollViewDirection:(PlayerScrollViewDirection)tfy_scrollViewDirection {
    objc_setAssociatedObject(self, @selector(tfy_scrollViewDirection), @(tfy_scrollViewDirection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTfy_stopPlay:(BOOL)tfy_stopPlay {
    objc_setAssociatedObject(self, @selector(tfy_stopPlay), @(tfy_stopPlay), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTfy_containerType:(PlayerContainerType)tfy_containerType {
    objc_setAssociatedObject(self, @selector(tfy_containerType), @(tfy_containerType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTfy_containerView:(UIView *)tfy_containerView {
    objc_setAssociatedObject(self, @selector(tfy_containerView), tfy_containerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTfy_shouldAutoPlay:(BOOL)tfy_shouldAutoPlay {
    objc_setAssociatedObject(self, @selector(tfy_shouldAutoPlay), @(tfy_shouldAutoPlay), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTfy_lastOffsetY:(CGFloat)tfy_lastOffsetY {
    objc_setAssociatedObject(self, @selector(tfy_lastOffsetY), @(tfy_lastOffsetY), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTfy_lastOffsetX:(CGFloat)tfy_lastOffsetX {
    objc_setAssociatedObject(self, @selector(tfy_lastOffsetX), @(tfy_lastOffsetX), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTfy_scrollViewDidStopScrollCallback:(void (^)(NSIndexPath * _Nonnull))tfy_scrollViewDidStopScrollCallback {
    objc_setAssociatedObject(self, @selector(tfy_scrollViewDidStopScrollCallback), tfy_scrollViewDidStopScrollCallback, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTfy_shouldPlayIndexPathCallback:(void (^)(NSIndexPath * _Nonnull))tfy_shouldPlayIndexPathCallback {
    objc_setAssociatedObject(self, @selector(tfy_shouldPlayIndexPathCallback), tfy_shouldPlayIndexPathCallback, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

@implementation UIScrollView (PlayerCannotCalled)

#pragma mark - getter

- (void (^)(NSIndexPath * _Nonnull, CGFloat))tfy_playerDisappearingInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull, CGFloat))tfy_playerAppearingInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))tfy_playerDidAppearInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))tfy_playerWillDisappearInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))tfy_playerWillAppearInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))tfy_playerDidDisappearInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (CGFloat)tfy_playerApperaPercent {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (CGFloat)tfy_playerDisapperaPercent {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (BOOL)tfy_viewControllerDisappear {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

#pragma mark - setter

- (void)setTfy_playerDisappearingInScrollView:(void (^)(NSIndexPath * _Nonnull, CGFloat))tfy_playerDisappearingInScrollView {
    objc_setAssociatedObject(self, @selector(tfy_playerDisappearingInScrollView), tfy_playerDisappearingInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTfy_playerAppearingInScrollView:(void (^)(NSIndexPath * _Nonnull, CGFloat))tfy_playerAppearingInScrollView {
    objc_setAssociatedObject(self, @selector(tfy_playerAppearingInScrollView), tfy_playerAppearingInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTfy_playerDidAppearInScrollView:(void (^)(NSIndexPath * _Nonnull))tfy_playerDidAppearInScrollView {
    objc_setAssociatedObject(self, @selector(tfy_playerDidAppearInScrollView), tfy_playerDidAppearInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTfy_playerWillDisappearInScrollView:(void (^)(NSIndexPath * _Nonnull))tfy_playerWillDisappearInScrollView {
    objc_setAssociatedObject(self, @selector(tfy_playerWillDisappearInScrollView), tfy_playerWillDisappearInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTfy_playerWillAppearInScrollView:(void (^)(NSIndexPath * _Nonnull))tfy_playerWillAppearInScrollView {
    objc_setAssociatedObject(self, @selector(tfy_playerWillAppearInScrollView), tfy_playerWillAppearInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTfy_playerDidDisappearInScrollView:(void (^)(NSIndexPath * _Nonnull))tfy_playerDidDisappearInScrollView {
    objc_setAssociatedObject(self, @selector(tfy_playerDidDisappearInScrollView), tfy_playerDidDisappearInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTfy_playerApperaPercent:(CGFloat)tfy_playerApperaPercent {
    objc_setAssociatedObject(self, @selector(tfy_playerApperaPercent), @(tfy_playerApperaPercent), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTfy_playerDisapperaPercent:(CGFloat)tfy_playerDisapperaPercent {
    objc_setAssociatedObject(self, @selector(tfy_playerDisapperaPercent), @(tfy_playerDisapperaPercent), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTfy_viewControllerDisappear:(BOOL)tfy_viewControllerDisappear {
    objc_setAssociatedObject(self, @selector(tfy_viewControllerDisappear), @(tfy_viewControllerDisappear), OBJC_ASSOCIATION_COPY_NONATOMIC);
}


@end
#pragma clang diagnostic pop
