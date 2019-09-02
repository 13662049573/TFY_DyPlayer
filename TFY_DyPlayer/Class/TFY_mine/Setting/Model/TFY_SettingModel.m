//
//  TFY_SettingModel.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/11.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_SettingModel.h"

@implementation SettingCommand

-(RACCommand *)settingCommand{
    if (!_settingCommand) {
        _settingCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                NSDictionary *dict = [NSDictionary tfy_NSDictionpathForResource:@"TFY_SettingDict" ofType:@"json"];
                TFY_SettingModel *model = [TFY_SettingModel tfy_ModelWithJson:dict];
                [subscriber sendNext:model];
                [subscriber sendCompleted];
                return nil;
            }];
        }];
    }
    return _settingCommand;
}

@end

@implementation Items

@end
@implementation Settinggroup
+(NSDictionary <NSString *, Class> *)tfy_ModelReplaceContainerElementClassMapper{
    return @{@"items":[Items class]};
}
@end
@implementation TFY_SettingModel
+(NSDictionary <NSString *, Class> *)tfy_ModelReplaceContainerElementClassMapper{
    return @{@"settinggroup":[Settinggroup class]};
}
@end
