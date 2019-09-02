//
//  TFY_FeedbackModel.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/18.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_FeedbackModel.h"

@implementation FeedbackData

-(RACCommand *)nopublicCommand{
    if (!_nopublicCommand) {
        _nopublicCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                NSDictionary *dict = [NSDictionary tfy_NSDictionpathForResource:@"TFY_FeedbackData" ofType:@"json"];
                
                TFY_FeedbackModel *models = [TFY_FeedbackModel tfy_ModelWithJson:dict];
                [subscriber sendNext:models];
                [subscriber sendCompleted];
                return nil;
            }];
        }];
    }
    return _nopublicCommand;
}

@end

@implementation Feedbackitems

@end
@implementation FeedbackItem
+(NSDictionary *)tfy_ModelReplaceContainerElementClassMapper{
    return @{@"feedbackitems":[Feedbackitems class]};
}
@end
@implementation TFY_FeedbackModel
+(NSDictionary *)tfy_ModelReplaceContainerElementClassMapper{
    return @{@"feedbackItem":[FeedbackItem class]};
}
@end
