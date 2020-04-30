//
//  UIDevice+Orientation.h
//  TFY_Category
//
//  Created by 田风有 on 2019/6/20.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (Orientation)

+ (double)systemVersion;

+ (NSString *)localVersion;

+ (NSString *)localBuild;

+ (NSString *)storeUrlWithAppId:(NSString *)appId;

@property (nonatomic, readonly) BOOL isJailbroken;

@property (nonatomic, readonly) BOOL isPad;

@property (nonatomic, readonly) BOOL isSimulator;

@property (nullable, nonatomic, readonly) NSString *machineModel;

@property (nullable, nonatomic, readonly) NSString *machineModelName;

/**
 系统启动时间
 */
@property (nonatomic, readonly) NSDate *systemUptime;

@property (nonatomic, readonly) BOOL canMakePhoneCalls NS_EXTENSION_UNAVAILABLE_IOS("");
/**
 wifi IP
 */
@property (nullable, nonatomic, readonly) NSString *ipAddressWIFI;

/**
 cell IP
 */
@property (nullable, nonatomic, readonly) NSString *ipAddressCell;

typedef NS_OPTIONS(NSUInteger, NetworkTrafficType) {
    NetworkTrafficTypeWWANSent     = 1 << 0,
    NetworkTrafficTypeWWANReceived = 1 << 1,
    NetworkTrafficTypeWIFISent     = 1 << 2,
    NetworkTrafficTypeWIFIReceived = 1 << 3,
    NetworkTrafficTypeAWDLSent     = 1 << 4,
    NetworkTrafficTypeAWDLReceived = 1 << 5,
    
    NetworkTrafficTypeWWAN = NetworkTrafficTypeWWANSent | NetworkTrafficTypeWWANReceived,
    NetworkTrafficTypeWIFI = NetworkTrafficTypeWIFISent | NetworkTrafficTypeWIFIReceived,
    NetworkTrafficTypeAWDL = NetworkTrafficTypeAWDLSent | NetworkTrafficTypeAWDLReceived,
    
    NetworkTrafficTypeALL = NetworkTrafficTypeWWAN |
    NetworkTrafficTypeWIFI |
    NetworkTrafficTypeAWDL,
};

- (uint64_t)getNetworkTrafficBytes:(NetworkTrafficType)types;


#pragma mark - Disk Space


@property (nonatomic, readonly) int64_t diskSpace;

@property (nonatomic, readonly) int64_t diskSpaceFree;

@property (nonatomic, readonly) int64_t diskSpaceUsed;

#pragma mark - Memory Information

@property (nonatomic, readonly) int64_t memoryTotal;

@property (nonatomic, readonly) int64_t memoryUsed;

@property (nonatomic, readonly) int64_t memoryFree;

@property (nonatomic, readonly) int64_t memoryActive;

@property (nonatomic, readonly) int64_t memoryInactive;

@property (nonatomic, readonly) int64_t memoryWired;

@property (nonatomic, readonly) int64_t memoryPurgable;

@property (nonatomic, readonly) NSUInteger cpuCount;

@property (nonatomic, readonly) float cpuUsage;

@property (nullable, nonatomic, readonly) NSArray<NSNumber *> *cpuUsagePerProcessor;

@end

NS_ASSUME_NONNULL_END
