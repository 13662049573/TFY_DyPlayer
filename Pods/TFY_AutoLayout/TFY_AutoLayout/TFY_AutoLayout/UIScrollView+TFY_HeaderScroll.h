//
//  UIScrollView+TFY_HeaderScroll.h
//  TFY_AutoLayoutModelTools
//
//  Created by 田风有 on 2019/5/15.
//  Copyright © 2019 恋机科技. All rights reserved.
//  使用方法如下
/**
 self.tableView.tfy_headerScaleImage = [UIImage imageNamed:@"header"];
 self.tableView.tfy_headerScaleImageHeight=200;
 // 设置tableView头部视图，必须设置头部视图背景颜色为clearColor,否则会被挡住
 UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 200)];
 headerView.backgroundColor = [UIColor clearColor];
 self.tableView.tableHeaderView = headerView;
 *
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (TFY_HeaderScroll)
/**
 *  头部缩放视图图片
 */
@property (nonatomic, strong) UIImage *tfy_headerScaleImage;
/**
 *  头部缩放视图图片高度
 */
@property (nonatomic, assign) CGFloat tfy_headerScaleImageHeight;
@end

NS_ASSUME_NONNULL_END
