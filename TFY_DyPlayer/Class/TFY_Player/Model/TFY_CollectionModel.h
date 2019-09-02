//
//  TFY_CollectionModel.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/16.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionCommand : NSObject

@property (nonatomic , copy) NSString     *ids;

//视频播放
@property(nonatomic , strong)RACCommand *showCollectionCommand;

//收藏
-(void)CollectionDelegateClick:(BOOL)selected;

//检测是否收藏过本视频
-(void)collectionSqlite:(void(NS_NOESCAPE ^)(bool selectedbool))selectedbool;
@end

@interface TFY_CollectionModel : NSObject
@property (nonatomic , copy) NSString     *id;
@property (nonatomic , copy) NSString     *pic;
@property (nonatomic , copy) NSString     *daoyan;
@property (nonatomic , copy) NSString     *zhuyan;
@property (nonatomic , copy) NSString     *pf;
@property (nonatomic , copy) NSString     *hits;
@property (nonatomic , copy) NSString     *name;
@property (nonatomic , copy) NSString     *type;
@property (nonatomic , copy) NSString     *yuyan;
@property (nonatomic , copy) NSString     *addtime;
@property (nonatomic , copy) NSString     *state;
@end

NS_ASSUME_NONNULL_END
