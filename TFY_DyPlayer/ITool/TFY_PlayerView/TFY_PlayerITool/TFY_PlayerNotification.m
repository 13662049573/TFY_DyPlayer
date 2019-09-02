//
//  TFY_PlayerNotification.m
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/30.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_PlayerNotification.h"

@interface TFY_PlayerNotification ()
@property (nonatomic, assign) PlayerBackgroundState backgroundState;
@end

@implementation TFY_PlayerNotification
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioSessionRouteChangeNotification:)
                                                 name:AVAudioSessionRouteChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActiveNotification)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActiveNotification)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(volumeDidChangeNotification:)
                                                 name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioSessionInterruptionNotification:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:nil];
    
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionInterruptionNotification object:nil];
}

- (void)dealloc {
    [self removeNotification];
}

- (void)audioSessionRouteChangeNotification:(NSNotification*)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *interuptionDict = notification.userInfo;
        NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
        switch (routeChangeReason) {
            case AVAudioSessionRouteChangeReasonNewDeviceAvailable: {
                if (self.newDeviceAvailable) self.newDeviceAvailable(self);
            }
                break;
            case AVAudioSessionRouteChangeReasonOldDeviceUnavailable: {
                if (self.oldDeviceUnavailable) self.oldDeviceUnavailable(self);
            }
                break;
            case AVAudioSessionRouteChangeReasonCategoryChange: {
                if (self.categoryChange) self.categoryChange(self);
            }
                break;
        }
    });
}

- (void)volumeDidChangeNotification:(NSNotification *)notification {
    float volume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    if (self.volumeChanged) {
        self.volumeChanged(volume);
    }
}

- (void)applicationWillResignActiveNotification {
    self.backgroundState = PlayerBackgroundStateBackground;
    if (self.willResignActive) {
        self.willResignActive(self);
    }
}

- (void)applicationDidBecomeActiveNotification {
    self.backgroundState = PlayerBackgroundStateForeground;
    if (self.didBecomeActive) {
        self.didBecomeActive(self);
    }
}

- (void)audioSessionInterruptionNotification:(NSNotification *)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    AVAudioSessionInterruptionType interruptionType = [[interuptionDict valueForKey:AVAudioSessionInterruptionTypeKey] integerValue];
    if (self.audioInterruptionCallback) {
        self.audioInterruptionCallback(interruptionType);
    }
}

@end
