//
//  TFY_recommendCell.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/5.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFY_recommendModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_recommendCell : UICollectionViewCell

@property(nonatomic , strong)Vod *model;

@property(nonatomic , strong)Data *datamodel;
@end

NS_ASSUME_NONNULL_END
