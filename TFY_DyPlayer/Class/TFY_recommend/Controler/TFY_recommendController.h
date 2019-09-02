//
//  TFY_recommendController.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/5.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "BaseCollectionController.h"
#import "TFY_recommendModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TFY_recommendController : BaseCollectionController

@property(nonatomic , strong)TFY_recommendModel *models;

-(void)HerderDelegateClick:(NSInteger)index model:(nonnull Data *)model;
@end

NS_ASSUME_NONNULL_END
