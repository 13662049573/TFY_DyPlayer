//
//  TFY_mineViewTwoViewCell.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/9.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFY_mineModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TFY_mineViewTwoViewCell : UICollectionViewCell
@property(nonatomic , strong)Mineitems *models;

@property(nonatomic , strong)NSIndexPath *indexPath;
@end

NS_ASSUME_NONNULL_END
