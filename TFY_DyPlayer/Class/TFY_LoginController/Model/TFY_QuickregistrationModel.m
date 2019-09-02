//
//  TFY_QuickregistrationModel.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/25.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_QuickregistrationModel.h"

@implementation QuickCommand

-(RACCommand *)quickCommand{
    if (!_quickCommand) {
        _quickCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                NSDictionary *dict = [NSDictionary tfy_NSDictionpathForResource:@"QuickregistrationData" ofType:@"json"];
                
                TFY_QuickregistrationModel *models = [TFY_QuickregistrationModel tfy_ModelWithJson:dict];
                [subscriber sendNext:models];
                [subscriber sendCompleted];
                return nil;
            }];
        }];
    }
    return _quickCommand;
}

@end

@implementation Quickitems

@end

@implementation TFY_QuickregistrationModel
+(NSDictionary <NSString *, Class> *)tfy_ModelReplaceContainerElementClassMapper{
    return @{@"quickitems":[Quickitems class]};
}
@end
