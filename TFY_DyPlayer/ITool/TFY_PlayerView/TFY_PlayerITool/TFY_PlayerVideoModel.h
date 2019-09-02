//
//  TFY_PlayerVideoModel.h
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/7/12.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_PlayerVideoModel : NSObject
/**
 *  网络视频地址
 */
@property(nonatomic , copy)NSString *tfy_url;
/**
 *  视频名字
 */
@property(nonatomic , copy)NSString *tfy_name;
/**
 *  视频播放集数ID
 */
@property(nonatomic , copy)NSString *tfy_videoId;
/**
 *  默认图片
 */
@property(nonatomic , copy)NSString *tfy_pic;
/**
 *  播放视频所获得时间
 */
@property(nonatomic , assign)NSInteger tfy_seconds;
/**
 *  视频ID
 */
@property(nonatomic , copy)NSString *tfy_ids;
@end

NS_ASSUME_NONNULL_END
