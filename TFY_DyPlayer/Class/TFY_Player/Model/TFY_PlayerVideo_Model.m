//
//  TFY_PlayerVideo_Model.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/15.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_PlayerVideo_Model.h"

@implementation VideoCommand

-(void)setIds:(NSString *)ids{
    _ids = ids;
}

-(RACCommand *)showCommand{
    if (!_showCommand) {
        _showCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                [TFY_NetWorking getWithUrl:GET_SHOW_KEY refreshCache:YES params:@{@"id":self.ids} success:^(id response) {
                    
                    TFY_PlayerVideo_Model *model = [TFY_PlayerVideo_Model tfy_ModelWithJson:response];
                    [subscriber sendNext:model];
                    [subscriber sendCompleted];
                } fail:^(NSError *error) {
                    [subscriber sendError:error];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _showCommand;
}

//本地数据保存于更新
+(void)ModelSqliteData:(TFY_PlayerController *)dictplayer Playertype:(TFY_PlayerVideState)type{
    NSDictionary *dcit =  [dictplayer ModelDict];
    
    if (![TFY_CommonUtils emptyNSDictionary:dcit]) {
        
        if (type == PlayertypeStateVideo) {
            
            TFY_PlayerVideoModel *models = [TFY_PlayerVideoModel tfy_ModelWithJson:dcit];
            
            NSArray *arrsqlist = [TFY_ModelSqlite query:[TFY_PlayerVideoModel class] where:[NSString stringWithFormat:@"tfy_ids=%@",models.tfy_ids]];
            if (arrsqlist.count>0) {
                [arrsqlist enumerateObjectsUsingBlock:^(TFY_PlayerVideoModel  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if ([models.tfy_ids isEqualToString:obj.tfy_ids]) {
                        [TFY_ModelSqlite update:models where:[NSString stringWithFormat:@"tfy_ids=%@",models.tfy_ids]];
                    }
                }];
            }
            else{
                //保存数据到数据库
                [TFY_ModelSqlite insert:models];
            }
        }
        else{
            //更新数据库
            TFY_PlayerVideoModel *models = [TFY_PlayerVideoModel tfy_ModelWithJson:dcit];
            [TFY_ModelSqlite update:models where:[NSString stringWithFormat:@"tfy_ids=%@",models.tfy_ids]];
        }
    }
}

@end

@implementation Tags

@end
@implementation Ji

@end
@implementation Zu
+(NSDictionary <NSString *, Class> *)tfy_ModelReplaceContainerElementClassMapper{
    return @{@"ji":[Ji class]};
}
@end
@implementation VideoData
+(NSDictionary <NSString *, Class> *)tfy_ModelReplaceContainerElementClassMapper{
    return @{@"zu":[Zu class],
             @"tags":[Tags class],
             };
}
@end

@implementation TFY_PlayerVideo_Model
+(NSDictionary <NSString *, Class> *)tfy_ModelReplaceContainerElementClassMapper{
    return @{@"data":[VideoData class]};
}
@end
