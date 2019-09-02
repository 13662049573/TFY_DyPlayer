//
//  TFY_MoreController.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/8.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "BaseCollectionController.h"
#import "TFY_recommendModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TFY_MoreController : BaseCollectionController

@property(nonatomic , strong)TFY_recommendModel *models;

@property (nonatomic , strong) Data *model;

@property (nonatomic , strong) NSMutableArray *array;

@end

NS_ASSUME_NONNULL_END
