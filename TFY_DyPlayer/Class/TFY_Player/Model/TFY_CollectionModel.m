//
//  TFY_CollectionModel.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/16.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_CollectionModel.h"


@implementation CollectionCommand

-(void)setIds:(NSString *)ids{
    _ids = [ids copy];
}

-(RACCommand *)showCollectionCommand{
    if (!_showCollectionCommand) {
        _showCollectionCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                [TFY_NetWorking getWithUrl:GET_SHOW_KEY refreshCache:YES params:@{@"id":self.ids} success:^(id response) {
                    
                    NSDictionary *dict = response[@"data"];
                    TFY_CollectionModel *model = [TFY_CollectionModel tfy_ModelWithJson:dict];
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
    return _showCollectionCommand;
}


//收藏代理返回
-(void)CollectionDelegateClick:(BOOL)selected{
    CollectionCommand *data = [CollectionCommand new];
    data.ids = self.ids;
    if (selected) {
        [[data.showCollectionCommand execute:@1] subscribeNext:^(id  _Nullable x) {
            if ([x isKindOfClass:[TFY_CollectionModel class]]) {
                TFY_CollectionModel *model = x;
                BOOL sqlitebool = [TFY_ModelSqlite insert:model];
                if (sqlitebool) {
                    [TFY_ProgressHUD showSuccessWithStatus:@"收藏成功!"];
                }
            }
        } error:^(NSError * _Nullable error) {
            [TFY_ProgressHUD showErrorWithStatus:@"收藏数据失败!"];
        }];
    }
    else{
        BOOL sqlitebool = [TFY_ModelSqlite deletes:[TFY_CollectionModel class] where:[NSString stringWithFormat:@"id=%@",self.ids]];
        if (sqlitebool) {
            [TFY_ProgressHUD showSuccessWithStatus:@"取消收藏!"];
        }
    }
}


//检测是否收藏过本视频
-(void)collectionSqlite:(void(NS_NOESCAPE ^)(bool selectedbool))selectedbool{
    NSArray *arrsqlist = [TFY_ModelSqlite query:[TFY_CollectionModel class] where:[NSString stringWithFormat:@"id=%@",self.ids]];
    if (arrsqlist.count>0) {
        [arrsqlist enumerateObjectsUsingBlock:^(TFY_CollectionModel  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([self.ids isEqualToString:obj.id]) {
                selectedbool(YES);
            }
            else{
                selectedbool(NO);
            }
        }];
    }
}

@end


@implementation TFY_CollectionModel

@end
