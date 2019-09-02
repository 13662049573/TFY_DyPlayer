//
//  TFY_SettingModel.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/11.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFY_SettingModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SettingCommand : NSObject

@property(nonatomic , strong)RACCommand *settingCommand;


@end

@interface Items : NSObject
@property (nonatomic , copy) NSString     *controller_str;
@property (nonatomic , copy) NSString     *title_str;
@property (nonatomic , assign) NSInteger     count_str;
@property (nonatomic , copy) NSString     *image_str;
@property (nonatomic , copy) NSString     *arrow_str;
@end

@interface Settinggroup : NSObject
@property (nonatomic , copy) NSArray<Items *>     *items;
@property (nonatomic , copy) NSString     *herder;

@end

@interface TFY_SettingModel : NSObject
@property (nonatomic , copy) NSArray<Settinggroup *>     *settinggroup;

@end

NS_ASSUME_NONNULL_END
