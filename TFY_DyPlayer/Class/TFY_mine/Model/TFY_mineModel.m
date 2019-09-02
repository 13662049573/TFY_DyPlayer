//
//  TFY_mineModel.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/9.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_mineModel.h"

@implementation MineCommand

-(RACCommand *)dataCommand{
    if (!_dataCommand) {
        _dataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                NSDictionary *dict = [NSDictionary tfy_NSDictionpathForResource:@"TFY_MineData.json" ofType:nil];
                
                TFY_mineModel *model = [TFY_mineModel tfy_ModelWithJson:dict];
                [subscriber sendNext:model];
                [subscriber sendCompleted];
                return nil;
            }];
        }];
    }
    return _dataCommand;
}

@end

@implementation Mineitems

@end

@implementation TFY_mineModel
+(NSDictionary <NSString *, Class> *)tfy_ModelReplaceContainerElementClassMapper{
    return @{@"mineitems":[Mineitems class]};
}
@end
