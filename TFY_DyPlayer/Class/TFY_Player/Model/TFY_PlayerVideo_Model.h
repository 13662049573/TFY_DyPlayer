//
//  TFY_PlayerVideo_Model.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/15.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TFY_PlayerVideState)
{
    PlayertypeStateVideo,
    PlayertypeStateCollection,
    PlayertypeStateCache,
    PlayertypeStateWatchistor
};


NS_ASSUME_NONNULL_BEGIN

@interface VideoCommand : NSObject

@property (nonatomic , copy) NSString     *ids;
//视频播放
@property(nonatomic , strong)RACCommand *showCommand;

//本地数据保存于更新
+(void)ModelSqliteData:(TFY_PlayerController *)dictplayer Playertype:(TFY_PlayerVideState)type;

@end

@interface Tags : NSObject

@end

@interface Ji : NSObject
@property (nonatomic , assign) NSInteger     id;
@property (nonatomic , copy) NSString     *ext;
@property (nonatomic , copy) NSString     *name;
@property (nonatomic , copy) NSString     *purl;

@end

@interface Zu : NSObject
@property (nonatomic , assign) NSInteger     id;
@property (nonatomic , copy) NSArray<Ji *>     *ji;
@property (nonatomic , assign) NSInteger     count;
@property (nonatomic , copy) NSString     *name;
@property (nonatomic , copy) NSString     *ly;

@end

@interface VideoData : NSObject
@property (nonatomic , copy) NSString     *cion;
@property (nonatomic , assign) NSInteger     dhits;
@property (nonatomic , copy) NSArray<Tags *>     *tags;
@property (nonatomic , copy) NSString     *zhuyan;
@property (nonatomic , copy) NSString     *pf;
@property (nonatomic , copy) NSString     *fid;
@property (nonatomic , copy) NSString     *shareurl;
@property (nonatomic , copy) NSString     *hits;
@property (nonatomic , copy) NSString     *cname;
@property (nonatomic , copy) NSString     *daoyan;
@property (nonatomic , copy) NSString     *name;
@property (nonatomic , copy) NSString     *year;
@property (nonatomic , copy) NSString     *type;
@property (nonatomic , copy) NSString     *state;
@property (nonatomic , copy) NSString     *cid;
@property (nonatomic , copy) NSString     *id;
@property (nonatomic , copy) NSString     *yuyan;
@property (nonatomic , copy) NSString     *pic;
@property (nonatomic , copy) NSString     *info;
@property (nonatomic , copy) NSString     *addtime;
@property (nonatomic , assign) NSInteger     look;
@property (nonatomic , assign) NSInteger     looktime;
@property (nonatomic , copy) NSArray<Zu *>     *zu;
@property (nonatomic , copy) NSString     *text;
@property (nonatomic , copy) NSString     *vip;
@property (nonatomic , copy) NSString     *diqu;
@property (nonatomic , assign) NSInteger     comment_count;

@end

@interface TFY_PlayerVideo_Model : NSObject<TFY_ModelSqlite>
@property (nonatomic , strong) VideoData     *data;
@property (nonatomic , assign) NSInteger     code;
@end

NS_ASSUME_NONNULL_END
