//
//  TFY_NetworkSpeedMonitor.h
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/30.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * _Nonnull const DownloadNetworkSpeedNotificationKey;
extern NSString * _Nonnull const UploadNetworkSpeedNotificationKey;
extern NSString * _Nonnull const NetworkSpeedNotificationKey;

NS_ASSUME_NONNULL_BEGIN

@interface TFY_NetworkSpeedMonitor : NSObject
@property (nonatomic, copy, readonly) NSString *downloadNetworkSpeed;
@property (nonatomic, copy, readonly) NSString *uploadNetworkSpeed;

- (void)startNetworkSpeedMonitor;
- (void)stopNetworkSpeedMonitor;
@end

NS_ASSUME_NONNULL_END
