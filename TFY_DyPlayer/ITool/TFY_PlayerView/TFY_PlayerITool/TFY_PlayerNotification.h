//
//  TFY_PlayerNotification.h
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/30.
//  Copyright © 2019 田风有. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPMusicPlayerController.h>

typedef NS_ENUM(NSUInteger, PlayerBackgroundState) {
    PlayerBackgroundStateForeground,  // 从背景输入前景。
    PlayerBackgroundStateBackground,  // 从前景到背景。
};

NS_ASSUME_NONNULL_BEGIN

@interface TFY_PlayerNotification : NSObject
@property (nonatomic, readonly) PlayerBackgroundState backgroundState;

@property (nonatomic, copy, nullable) void(^willResignActive)(TFY_PlayerNotification *registrar);

@property (nonatomic, copy, nullable) void(^didBecomeActive)(TFY_PlayerNotification *registrar);

@property (nonatomic, copy, nullable) void(^newDeviceAvailable)(TFY_PlayerNotification *registrar);

@property (nonatomic, copy, nullable) void(^oldDeviceUnavailable)(TFY_PlayerNotification *registrar);

@property (nonatomic, copy, nullable) void(^categoryChange)(TFY_PlayerNotification *registrar);

@property (nonatomic, copy, nullable) void(^volumeChanged)(float volume);

@property (nonatomic, copy, nullable) void(^audioInterruptionCallback)(AVAudioSessionInterruptionType interruptionType);

- (void)addNotification;

- (void)removeNotification;
@end

NS_ASSUME_NONNULL_END
