//
//  TFY_FeedbackModel.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/18.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeedbackData : NSObject

@property(nonatomic , strong)RACCommand *nopublicCommand;

@end

@interface Feedbackitems : NSObject
@property (nonatomic , copy) NSString     *placeholder;

@end

@interface FeedbackItem : NSObject
@property (nonatomic , copy) NSArray<Feedbackitems *>     *feedbackitems;

@end

@interface TFY_FeedbackModel : NSObject
@property (nonatomic , copy) NSString     *btntext;
@property (nonatomic , copy) NSArray<FeedbackItem *>     *feedbackItem;

@end

NS_ASSUME_NONNULL_END
