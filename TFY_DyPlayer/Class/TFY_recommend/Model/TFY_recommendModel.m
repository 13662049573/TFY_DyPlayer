//
//  TFY_recommendModel.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/5.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_recommendModel.h"

@implementation RecommendCommand

-(void)setVsize:(NSInteger)vsize{
    _vsize = vsize;
}

-(void)setIds:(NSString *)ids{
    _ids = ids;
}

-(void)setSize:(NSInteger)size{
    _size = size;
}

-(RACCommand *)topicCommand{
    if (!_topicCommand) {
        _topicCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                [TFY_NetWorking getWithUrl:GET_TOPIC_KEY refreshCache:NO params:@{@"vsize":@(self.vsize)} success:^(id response) {
                    
                    
                    
                    TFY_recommendModel *models = [TFY_recommendModel tfy_ModelWithJson:response];
                    [subscriber sendNext:models];
                    [subscriber sendCompleted];
                    
                } fail:^(NSError *error) {
                    [subscriber sendError:error];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _topicCommand;
}

-(RACCommand *)indexCommand{
    if (!_indexCommand) {
        _indexCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                [TFY_NetWorking getWithUrl:GET_INDEX_KEY refreshCache:NO params:@{@"page":@(1),@"size":@(10000),@"ztid":@(self.vsize)} success:^(id response) {
                    
                    TFY_recommendModel *models = [TFY_recommendModel tfy_ModelWithJson:response];
                    [subscriber sendNext:models];
                    [subscriber sendCompleted];

                } fail:^(NSError *error) {
                    [subscriber sendError:error];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _indexCommand;
}

-(RACCommand *)typeCommand{
    if (!_typeCommand) {
        _typeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                [TFY_NetWorking getWithUrl:GET_TYPE_KEY refreshCache:NO params:@{@"vsize":@(self.vsize),@"id":self.ids} success:^(id response) {
                    
                    TFY_recommendModel *models = [TFY_recommendModel tfy_ModelWithJson:response];
                    [subscriber sendNext:models];
                    [subscriber sendCompleted];
                    
                } fail:^(NSError *error) {
                    
                    [subscriber sendError:error];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _typeCommand;
}

-(RACCommand *)cidCommand{
    if (!_cidCommand) {
        _cidCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                [TFY_NetWorking getWithUrl:GET_INDEX_KEY refreshCache:NO params:@{@"size":@(self.size),@"cid":self.ids,@"page":@(1)} success:^(id response) {
                    
                    TFY_recommendModel *models = [TFY_recommendModel tfy_ModelWithJson:response];
                    [subscriber sendNext:models];
                    [subscriber sendCompleted];
                    
                } fail:^(NSError *error) {
                    
                    [subscriber sendError:error];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _cidCommand;
}

@end

@implementation Vod

@end
@implementation Data
+(NSDictionary <NSString *, Class> *)tfy_ModelReplaceContainerElementClassMapper{
    return @{@"vod":[Vod class]};
}
@end
@implementation TFY_recommendModel
+(NSDictionary <NSString *, Class> *)tfy_ModelReplaceContainerElementClassMapper{
    return @{@"data":[Data class]};
}
@end
