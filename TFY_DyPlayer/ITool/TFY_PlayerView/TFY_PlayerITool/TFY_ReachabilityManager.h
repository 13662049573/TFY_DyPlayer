//
//  TFY_ReachabilityManager.h
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/30.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>
#if !TARGET_OS_WATCH
#import <SystemConfiguration/SystemConfiguration.h>

typedef NS_ENUM(NSInteger, ReachabilityStatus) {
    ReachabilityStatusUnknown          = -1,
    ReachabilityStatusNotReachable     = 0,
    ReachabilityStatusReachableViaWiFi = 1,
    ReachabilityStatusReachableVia2G   = 2,
    ReachabilityStatusReachableVia3G   = 3,
    ReachabilityStatusReachableVia4G   = 4,
};

NS_ASSUME_NONNULL_BEGIN

@interface TFY_ReachabilityManager : NSObject
/**
 * 当前网络可达性状态。
 */
@property (readonly, nonatomic, assign) ReachabilityStatus networkReachabilityStatus;

/**
 * 网络当前是否可访问。
 */
@property (readonly, nonatomic, assign, getter = isReachable) BOOL reachable;

/**
 * 是否可通过WWAN访问网络。
 */
@property (readonly, nonatomic, assign, getter = isReachableViaWWAN) BOOL reachableViaWWAN;

/**
 *  是否可通过WiFi访问网络。
 */
@property (readonly, nonatomic, assign, getter = isReachableViaWiFi) BOOL reachableViaWiFi;

///---------------------
/// 初始化
///---------------------

/**
 * 返回共享网络可访问性管理器。
 */
+ (instancetype)sharedManager;

/**
 * 使用默认套接字地址创建并返回网络可访问性管理器。 始化网络可访问性管理器，主动监视默认套接字地址。
 */
+ (instancetype)manager;

/**
 创建并返回指定域的网络可访问性管理器。
 
 用于评估网络可访问性的域。
 
 初始化网络可访问性管理器，主动监视指定的域
 */
+ (instancetype)managerForDomain:(NSString *)domain;

/**
 为套接字地址创建并返回网络可访问性管理器。
 
 用于评估网络可达性的套接字地址（`sockaddr_in6`）。
 
 初始化网络可访问性管理器，主动监视指定的套接字地址。
 */
+ (instancetype)managerForAddress:(const void *)address;

/**
 从指定的可访问性对象初始化网络可访问性管理器的实例。
 
 reachability要监视的可访问性对象。
 
 始化网络可访问性管理器，主动监视指定的可达性。
 */
- (instancetype)initWithReachability:(SCNetworkReachabilityRef)reachability NS_DESIGNATED_INITIALIZER;

///--------------------------------------------------
/// 启动和停止可达性监控
///--------------------------------------------------

/**
 * 开始监视网络可达性状态的变化。
 */
- (void)startMonitoring;

/**
 * 停止监视网络可达性状态的变化
 */
- (void)stopMonitoring;

///-------------------------------------------------
/// 获取本地化可达性描述
///-------------------------------------------------

/**
 * 返回当前网络可访问性状态的本地化字符串表示形式。
 */
- (NSString *)localizedNetworkReachabilityStatusString;

///---------------------------------------------------
/// 设置网络可达性更改回调
///---------------------------------------------------

/**
 设置当`baseURL`主机的网络可用性发生变化时要执行的回调
 
 当`baseURL`主机的网络可用性发生变化时要执行的块对象。该块没有返回值，只取一个参数，表示从设备到`baseURL`的各种可达性状态。
 */
- (void)setReachabilityStatusChangeBlock:(nullable void (^)(ReachabilityStatus status))block;

@end
///--------------------
/// 通知
///--------------------

FOUNDATION_EXPORT NSString * const ReachabilityDidChangeNotification;
FOUNDATION_EXPORT NSString * const ReachabilityNotificationStatusItem;

///--------------------
/// 函数
///--------------------

/**
 * 返回“ReachabilityStatus”值的本地化字符串表示形式。
 */
FOUNDATION_EXPORT NSString * StringFromNetworkReachabilityStatus(ReachabilityStatus status);

NS_ASSUME_NONNULL_END
#endif
