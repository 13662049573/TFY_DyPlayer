//
//  TFY_ReachabilityManager.m
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/30.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_ReachabilityManager.h"
#if !TARGET_OS_WATCH
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

NSString * const ReachabilityDidChangeNotification = @"com.TFY_Player.reachability.change";
NSString * const ReachabilityNotificationStatusItem = @"NetworkingReachabilityNotificationStatusItem";

typedef void (^ReachabilityStatusBlock)(ReachabilityStatus status);

NSString * StringFromNetworkReachabilityStatus(ReachabilityStatus status) {
    switch (status) {
        case ReachabilityStatusNotReachable:
            return NSLocalizedStringFromTable(@"Not Reachable", @"TFY_Player", nil);
        case ReachabilityStatusReachableViaWiFi:
            return NSLocalizedStringFromTable(@"Reachable via WiFi", @"TFY_Player", nil);
        case ReachabilityStatusReachableVia2G:
            return NSLocalizedStringFromTable(@"Reachable via 2G", @"TFY_Player", nil);
        case ReachabilityStatusReachableVia3G:
            return NSLocalizedStringFromTable(@"Reachable via 3G", @"TFY_Player", nil);
        case ReachabilityStatusReachableVia4G:
            return NSLocalizedStringFromTable(@"Reachable via 4G", @"TFY_Player", nil);
        case ReachabilityStatusUnknown:
        default:
            return NSLocalizedStringFromTable(@"Unknown", @"TFY_Player", nil);
    }
}

static ReachabilityStatus ReachabilityStatusForFlags(SCNetworkReachabilityFlags flags) {
    BOOL isReachable = ((flags & kSCNetworkReachabilityFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkReachabilityFlagsConnectionRequired) != 0);
    BOOL canConnectionAutomatically = (((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) || ((flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0));
    BOOL canConnectWithoutUserInteraction = (canConnectionAutomatically && (flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0);
    BOOL isNetworkReachable = (isReachable && (!needsConnection || canConnectWithoutUserInteraction));
    
    ReachabilityStatus status = ReachabilityStatusUnknown;
    if (isNetworkReachable == NO) {
        status = ReachabilityStatusNotReachable;
    }
#if TARGET_OS_IPHONE
    else if ((flags & kSCNetworkReachabilityFlagsIsWWAN) != 0) {
        CTTelephonyNetworkInfo * info = [[CTTelephonyNetworkInfo alloc] init];
        NSString *currentRadioAccessTechnology = info.currentRadioAccessTechnology;
        if (currentRadioAccessTechnology) {
            if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE]) {
                status = ReachabilityStatusReachableVia4G;
            } else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS]) {
                status = ReachabilityStatusReachableVia2G;
            } else {
                status = ReachabilityStatusReachableVia3G;
            }
        }
    }
#endif
    else {
        status = ReachabilityStatusReachableViaWiFi;
    }
    return status;
    
}

static void PostReachabilityStatusChange(SCNetworkReachabilityFlags flags, ReachabilityStatusBlock block) {
    ReachabilityStatus status = ReachabilityStatusForFlags(flags);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (block) block(status);
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        NSDictionary *userInfo = @{ ReachabilityNotificationStatusItem: @(status) };
        [notificationCenter postNotificationName:ReachabilityDidChangeNotification object:nil userInfo:userInfo];
    });
}

static void AFNetworkReachabilityCallback(SCNetworkReachabilityRef __unused target, SCNetworkReachabilityFlags flags, void *info) {
    PostReachabilityStatusChange(flags, (__bridge ReachabilityStatusBlock)info);
}


static const void * ReachabilityRetainCallback(const void *info) {
    return Block_copy(info);
}

static void ReachabilityReleaseCallback(const void *info) {
    if (info) {
        Block_release(info);
    }
}

@interface TFY_ReachabilityManager ()
@property (readonly, nonatomic, assign) SCNetworkReachabilityRef networkReachability;
@property (readwrite, nonatomic, assign) ReachabilityStatus networkReachabilityStatus;
@property (readwrite, nonatomic, copy) ReachabilityStatusBlock networkReachabilityStatusBlock;

@end

@implementation TFY_ReachabilityManager
+ (instancetype)sharedManager {
    static TFY_ReachabilityManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [self manager];
    });
    return _sharedManager;
}

+ (instancetype)managerForDomain:(NSString *)domain {
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, [domain UTF8String]);
    TFY_ReachabilityManager *manager = [[self alloc] initWithReachability:reachability];
    CFRelease(reachability);
    return manager;
}

+ (instancetype)managerForAddress:(const void *)address {
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)address);
    TFY_ReachabilityManager *manager = [[self alloc] initWithReachability:reachability];
    CFRelease(reachability);
    return manager;
}

+ (instancetype)manager {
#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED >= 90000) || (defined(__MAC_OS_X_VERSION_MIN_REQUIRED) && __MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
    struct sockaddr_in6 address;
    bzero(&address, sizeof(address));
    address.sin6_len = sizeof(address);
    address.sin6_family = AF_INET6;
#else
    struct sockaddr_in address;
    bzero(&address, sizeof(address));
    address.sin_len = sizeof(address);
    address.sin_family = AF_INET;
#endif
    return [self managerForAddress:&address];
}

- (instancetype)initWithReachability:(SCNetworkReachabilityRef)reachability {
    self = [super init];
    if (!self) {
        return nil;
    }
    _networkReachability = CFRetain(reachability);
    self.networkReachabilityStatus = ReachabilityStatusUnknown;
    
    return self;
}

- (instancetype)init NS_UNAVAILABLE
{
    return nil;
}

- (void)dealloc {
    [self stopMonitoring];
    if (_networkReachability != NULL) {
        CFRelease(_networkReachability);
    }
}

#pragma mark -

- (BOOL)isReachable {
    return [self isReachableViaWWAN] || [self isReachableViaWiFi];
}

- (BOOL)isReachableViaWWAN {
    return (self.networkReachabilityStatus == ReachabilityStatusReachableVia2G ||self.networkReachabilityStatus == ReachabilityStatusReachableVia3G || self.networkReachabilityStatus == ReachabilityStatusReachableVia4G);
}

- (BOOL)isReachableViaWiFi {
    return self.networkReachabilityStatus == ReachabilityStatusReachableViaWiFi;
}

#pragma mark -

- (void)startMonitoring {
    [self stopMonitoring];
    if (!self.networkReachability) {
        return;
    }
    
    __weak __typeof(self)weakSelf = self;
    ReachabilityStatusBlock callback = ^(ReachabilityStatus status) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.networkReachabilityStatus = status;
        if (strongSelf.networkReachabilityStatusBlock) {
            strongSelf.networkReachabilityStatusBlock(status);
        }
    };
    
    SCNetworkReachabilityContext context = {0, (__bridge void *)callback, ReachabilityRetainCallback, ReachabilityReleaseCallback, NULL};
    SCNetworkReachabilitySetCallback(self.networkReachability, AFNetworkReachabilityCallback, &context);
    SCNetworkReachabilityScheduleWithRunLoop(self.networkReachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(self.networkReachability, &flags)) {
            PostReachabilityStatusChange(flags, callback);
        }
    });
}

- (void)stopMonitoring {
    if (!self.networkReachability) {
        return;
    }
    
    SCNetworkReachabilityUnscheduleFromRunLoop(self.networkReachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
}

#pragma mark -

- (NSString *)localizedNetworkReachabilityStatusString {
    return StringFromNetworkReachabilityStatus(self.networkReachabilityStatus);
}

#pragma mark -

- (void)setReachabilityStatusChangeBlock:(void (^)(ReachabilityStatus status))block {
    self.networkReachabilityStatusBlock = block;
}

#pragma mark - NSKeyValueObserving

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    if ([key isEqualToString:@"reachable"] || [key isEqualToString:@"reachableViaWWAN"] || [key isEqualToString:@"reachableViaWiFi"]) {
        return [NSSet setWithObject:@"networkReachabilityStatus"];
    }
    return [super keyPathsForValuesAffectingValueForKey:key];
}
@end
#endif
