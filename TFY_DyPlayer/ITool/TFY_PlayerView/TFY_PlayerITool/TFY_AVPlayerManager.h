//
//  TFY_AVPlayerManager.h
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/30.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "TFY_PlayerMediaPlayback.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_AVPlayerManager : NSObject<TFY_PlayerMediaPlayback>

@property (nonatomic, strong, readonly) AVURLAsset *asset;
@property (nonatomic, strong, readonly) AVPlayerItem *playerItem;
@property (nonatomic, strong, readonly) AVPlayer *player;
@property (nonatomic, assign) NSTimeInterval timeRefreshInterval;
/// 视频请求头
@property (nonatomic, strong) NSDictionary *requestHeader;
@end

NS_ASSUME_NONNULL_END
