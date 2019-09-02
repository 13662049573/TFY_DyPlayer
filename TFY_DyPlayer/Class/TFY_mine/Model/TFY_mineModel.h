//
//  TFY_mineModel.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/9.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineCommand : NSObject

@property(nonatomic , strong)RACCommand *dataCommand;

@end

@interface Mineitems : NSObject
@property (nonatomic , copy) NSString     *controller;
@property (nonatomic , assign) NSInteger     whether;
@property (nonatomic , copy) NSString     *title_str;
@property (nonatomic , copy) NSString     *image_str;
@property (nonatomic , copy) NSString     *arrow_str;

@end

@interface TFY_mineModel : NSObject
@property (nonatomic , copy) NSArray<Mineitems *>     *mineitems;

@end

NS_ASSUME_NONNULL_END
