//
//  TFY_recommendModel.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/5.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecommendCommand : NSObject

@property(nonatomic , assign)NSInteger vsize;

@property(nonatomic , copy)NSString     *ids;

@property(nonatomic , assign)NSInteger size;
//推荐
@property(nonatomic , strong)RACCommand *topicCommand;
//更多
@property(nonatomic , strong)RACCommand *indexCommand;
//韩剧
@property(nonatomic , strong)RACCommand *typeCommand;

@property(nonatomic , strong)RACCommand *cidCommand;
@end

@interface Vod : NSObject
@property (nonatomic , copy) NSString     *name;
@property (nonatomic , copy) NSString     *info;
@property (nonatomic , copy) NSString     *id;
@property (nonatomic , copy) NSString     *pic;
@property (nonatomic , copy) NSString     *cion;
@property (nonatomic , copy) NSString     *vip;
@property (nonatomic , copy) NSString     *type;
@property (nonatomic , copy) NSString     *hits;
@property (nonatomic , copy) NSString     *state;
@property (nonatomic , copy) NSString     *pf;

@end

@interface Data : NSObject
@property (nonatomic , copy) NSString     *id;
@property (nonatomic , copy) NSArray<Vod *>     *vod;
@property (nonatomic , copy) NSString     *pic;
@property (nonatomic , copy) NSString     *name;
@property (nonatomic , copy) NSString     *url;
@property (nonatomic , assign) NSInteger     ad;
@property (nonatomic , copy) NSString     *state;
@property (nonatomic , copy) NSString     *vip;
@property (nonatomic , copy) NSString     *fid;
@property (nonatomic , copy) NSString     *cid;
@property (nonatomic , copy) NSString     *type;
@property (nonatomic , copy) NSString     *pf;
@property (nonatomic , copy) NSString     *hits;
@property (nonatomic , copy) NSString     *cion;
@property (nonatomic , copy) NSString     *info;
@property (nonatomic , copy) NSString     *pic2;

@end

@interface TFY_recommendModel : NSObject
@property (nonatomic , copy) NSArray<Data *>     *data;
@property (nonatomic , assign) NSInteger     code;

@end

NS_ASSUME_NONNULL_END
