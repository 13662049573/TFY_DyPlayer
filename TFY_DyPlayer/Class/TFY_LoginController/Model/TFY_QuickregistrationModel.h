//
//  TFY_QuickregistrationModel.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/25.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuickCommand : NSObject

@property(nonatomic , strong)RACCommand *quickCommand;

@end


@interface Quickitems : NSObject
@property (nonatomic , assign) NSInteger     secureText_bool;
@property (nonatomic , copy) NSString     *title_str;
@property (nonatomic , assign) NSInteger     borderStyle;
@property (nonatomic , copy) NSString     *placeholder_str;
@property (nonatomic , assign) NSInteger     code_bool;

@end

@interface TFY_QuickregistrationModel : NSObject
@property (nonatomic , copy) NSArray<Quickitems *>     *quickitems;

@end

NS_ASSUME_NONNULL_END
