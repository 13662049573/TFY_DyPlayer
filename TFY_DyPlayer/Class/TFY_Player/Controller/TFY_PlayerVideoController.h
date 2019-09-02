//
//  TFY_PlayerVideoController.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/8.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "BaseTableViewController.h"
#import "TFY_PlayerVideo_Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_PlayerVideoController : BaseTableViewController

@property (nonatomic) NSInteger currentPlayIndex;

-(void)VideoID:(NSString *)ids Playertype:(TFY_PlayerVideState)type PlayerSeektime:(NSInteger)time;


@end

NS_ASSUME_NONNULL_END
