//
//  TFY_PersonalinformatiolModel.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/18.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_PersonalinformatiolModel.h"

@implementation PersonCommand

-(RACCommand *)personCommand{
    if (!_personCommand) {
        _personCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                NSDictionary *dict = [NSDictionary tfy_NSDictionpathForResource:@"TFY_PersonData" ofType:@"json"];
                
                TFY_PersonalinformatiolModel *model = [TFY_PersonalinformatiolModel tfy_ModelWithJson:dict];
                [subscriber sendNext:model];
                [subscriber sendCompleted];
                return nil;
            }];
        }];
    }
    return _personCommand;
}

@end

@implementation Personitems

@end
@implementation TFY_PersonalinformatiolModel
+(NSDictionary <NSString *, Class> *)tfy_ModelReplaceContainerElementClassMapper{
    return @{@"personitems":[Personitems class]};
}
@end
