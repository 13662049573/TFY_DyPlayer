//
//  TFY_PersonalinformatiolModel.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/18.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonCommand : NSObject

@property(nonatomic , strong)RACCommand *personCommand;

@end


@interface Personitems : NSObject
@property (nonatomic , copy) NSString     *controller;
@property (nonatomic , copy) NSString     *title_str;
@property (nonatomic , copy) NSString     *desc_str;
@property (nonatomic , copy) NSString     *arrow_str;

@end

@interface TFY_PersonalinformatiolModel : NSObject
@property (nonatomic , copy) NSArray<Personitems *>     *personitems;

@end

NS_ASSUME_NONNULL_END
