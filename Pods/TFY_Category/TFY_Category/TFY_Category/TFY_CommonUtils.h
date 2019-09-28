//
//  TFY_CommonUtils.h
//  TFY_AutoLayoutModelTools
//
//  Created by 田风有 on 2019/5/10.
//  Copyright © 2019 恋机科技. All rights reserved.
//  版本 2.5.0

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

#pragma *******************************************判断获取网络数据****************************************

typedef enum : NSInteger {
    TFY_NotReachable = 0,
    TFY_ReachableViaWiFi,
    TFY_ReachableViaWWAN
} TFY_NetworkStatus;

extern NSString *kReachabilityChangedNotification;

#pragma ****************************************手机权限授权方法开始****************************************

//权限类型
typedef enum : NSUInteger{
    TFY_PermissionTypeCamera,           //相机权限
    TFY_PermissionTypeMic,              //麦克风权限
    TFY_PermissionTypePhoto,            //相册权限
    TFY_PermissionTypeLocationWhen,     //获取地理位置When
    TFY_PermissionTypeCalendar,         //日历
    TFY_PermissionTypeContacts,         //联系人
    TFY_PermissionTypeBlue,             //蓝牙
    TFY_PermissionTypeRemaine,          //提醒
    TFY_PermissionTypeHealth,           //健康
    TFY_PermissionTypeMediaLibrary      //多媒体
}TFY_PermissionType;

typedef void (^callBack) (BOOL granted, id  data);


@interface TFY_CommonUtils : NSObject

#pragma ------------------------------------------手机获取网络监听方法---------------------------------------
/*!
 * v用于检查给定主机名的可访问性。
 */
+ (instancetype)reachabilityWithHostName:(NSString *)hostName;

/*!
 * 用于检查给定IP地址的可达性。
 */
+ (instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress;

/*!
 * 检查默认路由是否可用。应该由未连接到特定主机的应用程序使用。
 */
+ (instancetype)reachabilityForInternetConnection;

/*!
 * 开始侦听当前运行循环的可达性通知。
 */
- (BOOL)startNotifier;
- (void)stopNotifier;

- (TFY_NetworkStatus)currentReachabilityStatus;

/*!
 * WWAN可能可用，但在建立连接之前不会处于活动状态。 WiFi可能需要VPN on Demand连接。
 */
- (BOOL)connectionRequired;
/**
 获取网络状态 2G/3G/4G/wifi
 */
+(NSString *)getNetconnType;

#pragma ---------------------------------------手机权限授权方法开始---------------------------------------
/**
 * 单例
 */
+ (instancetype)shareInstance;
/**
 * 获取权限 type       类型  block      回调
 */
- (void)permissonType:(TFY_PermissionType)type withHandle:(callBack)block;


#pragma ------------------------------------------各种方法使用------------------------------------------
#pragma ****************************************字符串方法***************************************
/**
 *  NSDictionary或NSArray转换为NSString
 */
+(NSString *)toJSONString:(id)theData;
/**
 *  //获取某个时间字符串 formart时间戳格式("yyyy-MM-dd HH-mm-ss")
 */
+(NSString *)dateStringWithDate:(NSDate *)date formart:(NSString *)formart;
/**
 *  //时间戳转化为NSDate formart时间戳格式("yyyy-MM-dd HH-mm-ss")
 */
+(NSDate *)dateWithNSString:(NSString*)string formart:(NSString *)formart;
/**
 *  根据日期计算N个月前的日期
 */
+(NSDate *)dateOfPreviousMonth:(NSInteger)previousMonthCount WithDate:(NSDate *)fromDate;
/**
 *  获取长度为stringLength的随机字符串, 随机数字字符混合类型字符串函数
 */
+(NSString *)getRandomString:(NSInteger)stringLength;
/**
 *  随机数字类型字符串函数
 */
+(NSString *)getRandomNumberString:(NSInteger)stringLength;
/**
 *  随机字符类型字符串函数
 */
+(NSString *)getRandomCharacterString:(NSInteger)stringLength;
/**
 *  获取wifi信号 method
 */
+(NSString*)currentWifiSSID;
/**
 *  获取设备的UUID
 */
+(NSString *)gen_uuid;
/**
 *  替换掉Json字符串中的换行符
 */
+(NSString *)ReplacingNewLineAndWhitespaceCharactersFromJson:(NSString *)jsonStr;
/**
 * 直接调用这个方法即可签名成功
 */
+ (NSString *)serializeURL:(NSString *)baseURL Token:(NSString *)token params:(NSDictionary *)params;
/**
 *  需要给字符串加密排序
 */
+(NSString *)HTTPBodyWithParameters:(NSDictionary *)parameters Token:(NSString *)token;
/**
 *  返回一个请求头
 */
+(NSString *)parmereaddWithDict:(NSDictionary *)dict Token:(NSString *)token;
/**
 *  把多个json字符串转为一个json字符串
 */
+(NSString *)objArrayToJSON:(NSArray *)array;
/**
 *   获取当前时间
 */
+(NSString *)audioTime;
/**
 *   字符串时间——时间戳
 */
+(NSString *)cTimestampFromString:(NSString *)theTime;
/**
 *   时间戳——字符串时间
 */
+(NSString *)cStringFromTimestamp:(NSString *)timestamp;
/**
 *  两个时间之差
 */
+(NSString *)intervalFromLastDate:(NSString *)dateString1 toTheDate:(NSString *)dateString2;
/**
 *   一个时间距现在的时间
 */
+(NSString *)intervalSinceNow:(NSString *)theDate;
/**
 *  将字符串转化为中文时间
 */
+(NSString *)Formatter:(NSString *)time;
/**
 *  去掉手机号码上的+号和+86
 */
+(NSString *)formatPhoneNum:(NSString *)phone;
/**
 *  手机系统版本
 */
+(NSString *)phoneVersions;
/**
 *  设备名称
 */
+(NSString *)deviceName;
/**
 *  获取当前版本号
 */
+(NSString *)cfbundleVersion;
/**
 *  获取当前应用名称
 */
+(NSString *)cfbundleDisplayName;
/**
 *  当前应用软件版本
 */
+(NSString *)cfbundleShortVersionString;
/**
 *  国际化区域名称
 */
+(NSString *)localizedModel;
/**
 *  获取当前年份
 */
+(NSString *)setDateFormat;
/**
 *  当前使用的语言
 */
+(NSString *)defaultsTH;
/**
 *  程序主目录，可见子目录(3个):Documents、Library、tmp
 */
+(NSString *)homePath;
/**
 *   程序目录，不能存任何东西
 */
+(NSString *)appPath;
/**
 *  文档目录，需要ITUNES同步备份的数据存这里，可存放用户数据
 */
+(NSString *)docPath;
/**
 *  配置目录，配置文件存这里
 */
+(NSString *)libPrefPath;
/**
 *  缓存目录，系统永远不会删除这里的文件，ITUNES会删除
 */
+(NSString *)libCachePath;
/**
 *  临时缓存目录，APP退出后，系统可能会删除这里的内容
 */
+(NSString *)tmpPath;
/**
 *  获取本机IP
 */
+(NSString *)getIPAddress;
/**
 *  获取WIFI的MAC地址
 */
+(NSString *)getWifiBSSID;
/**
 *   获取WIFI名字
 */
+(NSString *)getWifiSSID;
/**
 *  针对蜂窝网络判断是3G或者4G
 */
+(NSString *)getNetType;
/**
 * 获取设备IDFA
 */
+(NSString *)getDeviceIDFA;
/**
 *  获取设备IDFV
 */
+(NSString *)getDeviceIDFV;
/**
 *  获取设备IMEI
 */
+(NSString*)getDeviceIMEI;
/**
 *  获取设备MAC
 */
+(NSString*)getDeviceMAC;
/**
 *  获取设备UUID
 */
+(NSString*)getDeviceUUID;
/**
 *  截取字符串后几位
 */
+(NSString *)substring:(NSString *)substring length:(NSInteger )lengths;
/**
 *  不需要加密的参数请求
 */
+(NSString *)requestparmereaddWithDict:(NSDictionary *)dict;
/**
 *  秒数转换成时间,时，分，秒 转换成时分秒
 */
+(NSString *)timeFormatted:(int)totalSeconds;
/**
 *  视频显示时间
 */
+(NSString *)convertSecond2Time:(int)second;
/**
 *   将时间数据（毫秒）转换为天和小时
 */
+(NSString*)getOvertime:(NSString*)mStr;
/**
 *   获取图片格式
 */
+(NSString *)typeForImageData:(NSData *)data;
/**
 *  指定字符串末尾倒数第5个 是 . 替换成自己需要的字符
 */
+(NSString *)stringByReplacing_String:(NSString *)str withString:(NSString *)String;
/**
 *  字典转化成字符串
 */
+(NSString*)dictionaryToJsonString:(NSDictionary *)dic;
/**
 *  图片转f字符串
 */
+(NSString *)imageToString:(UIImage *)image;
/**
 *   出生日期计算星座
 */
+(NSString *)getAstroWithMonth:(int)m day:(int)d;
/**
 *   计算生肖
 */
+(NSString *)getZodiacWithYear:(NSString *)year;
/**
 *  将中文字符串转为拼音
 */
+(NSString *)chineseStringToPinyin:(NSString *)string;
/**
 *  iOS 隐藏手机号码中间的四位数字
 */
+(NSString *)numberSuitScanf:(NSString*)number;
/**
 *  银行卡号的格式只显示最后四个数字其他*代替
 */
+(NSString *)getNewBankNumWitOldBankNum:(NSString *)bankNum;
/**
 *  去掉小数点后无效的0
 */
+ (NSString *)deleteFailureZero:(NSString *)string;
/**
 *  根据字节大小返回文件大小字符KB、MB
 */
+ (NSString *)stringFromByteCount:(long long)byteCount;
/**
 *  获得设备型号
 */
+ (NSString *)getCurrentDeviceModel;
/**
 *  根据字节大小返回文件大小字符KB、MB GB
 */
+(NSString *)convertFileSize:(long long)size;
#pragma ****************************************判断方法****************************************
/**
 *  判断字符串是否是纯数字
 */
+(BOOL)isPureNumber:(NSString *)string;
/**
 *  判断数组是否为空
 */
+(BOOL)isBlankArray:(NSArray *)array;
/**
 *  拿去存储的当前状态
 */
+(BOOL)addWithisLink:(NSString *)isLink;
/**
 *  判断目录是否存在，不存在则创建
 */
+(BOOL)hasLive:(NSString *)path;
/**
 *   判断字符串是否为空  @return YES or NO
 */
+(BOOL)judgeIsEmptyWithString:(NSString *)string;
/**
 * 检测字符串中是否包含表情符号
 */
+(BOOL)stringContainsEmoji:(NSString *)string;
/**
 * 判断字符串是否是整形数字
 */
+(BOOL)isPureInt:(NSString *)string;
/**
 * 判断是否为空NSNumber对象，nil,NSNull都为空，不是NSNumber对象也判为空
 */
+(BOOL)emptyNSNumber:(NSNumber *)number;
/**
 *  判断是否为空NSDictionary对象，nil,NSNull,@{}都为空,零个键值对也是空，不是NSDictionary对象也判为空
 */
+(BOOL)emptyNSDictionary:(NSDictionary *)dictionary;
/**
 *  判断是否为空NSSet对象，nil,NSNull,@{}都为空，零个键值对也是空不是NSSet对象也判为空
 */
+(BOOL)emptyNSSet:(NSSet *)set;
/**
 *  判断email格式是否正确，符合格式则YES，否则为NO
 */
+(BOOL)email:(NSString *)email;
/**
 *  验证手机号 符合则为YES，不符合则为NO
 */
+(BOOL)mobilePhoneNumber:(NSString *)mobile;
/**
 *  判断是否全数字 符合则为YES，不符合则为NO
 */
+(BOOL)OnlyDigitalNumber:(NSString *)number;
/**
 * 判断是不是小数，如1.2这样  符合则为YES，不符合则为NO
 */
+(BOOL)floatNumber:(NSString *)number;
/**
 *   判断版本号是否发生变化，有为 yes
 */
+(BOOL)version_CFBundleShortVersionString;
/*
 *  判断手机是否越狱
 */
+(BOOL)isJailBreak;
/**
 *  判断是否需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
 */
+(BOOL)isIncludeSpecialCharact:(NSString *)str;
/**
 *  验证身份证号码
 */
+ (BOOL)isIdentityCardNumber:(NSString *)number;
/**
 *  验证香港身份证号码
 */
+ (BOOL)isIdentityHKCardNumber:(NSString *)number;
/**
 *  验证密码格式（包含大写、小写、数字）
 */
+ (BOOL)isConformSXPassword:(NSString *)password;
/**
 *  验证护照
 */
+ (BOOL)isPassportNumber:(NSString *)number;
#pragma ****************************************没有返回方法****************************************

#pragma  mark - NSUserDefaults存取操作
/**
 *  存储当前BOOL
 */
+(void)saveBoolValueInUD:(BOOL)value forKey:(NSString *)key;
/**
 *  存储当前NSString
 */
+(void)saveStrValueInUD:(NSString *)str forKey:(NSString *)key;
/**
 *  存储当前NSData
 */
+(void)saveDataValueInUD:(NSData *)data forKey:(NSString *)key;
/**
 *  存储当前NSDictionary
 */
+(void)saveDicValueInUD:(NSDictionary *)dic forKey:(NSString *)key;
/**
 *  存储当前NSArray
 */
+(void)saveArrValueInUD:(NSArray *)arr forKey:(NSString *)key;
/**
 *  存储当前NSDate
 */
+(void)saveDateValueInUD:(NSDate *)date forKey:(NSString *)key;
/**
 *  存储当前NSInteger
 */
+(void)saveIntValueInUD:(NSInteger)value forKey:(NSString *)key;
/**
 *   保存模型id
 */
+(void)saveValueInUD:(id)value forKey:(NSString *)key;
/**
 *  获取保存的id
 */
+(id)getValueInUDWithKey:(NSString *)key;
/**
 *   图片点击放大缩小
 */
+(void)showImage:(UIImageView*)avatarImageView;
/**
 *  获取保存的NSDate
 */
+(NSDate *)getDateValueInUDWithKey:(NSString *)key;
/**
 *  获取保存的NSString
 */
+(NSString *)getStrValueInUDWithKey:(NSString *)key;
/**
 *  获取保存的NSInteger
 */
+(NSInteger )getIntValueInUDWithKey:(NSString *)key;
/**
 *  获取保存的NSDictionary
 */
+(NSDictionary *)getDicValueInUDWithKey:(NSString *)key;
/**
 *  获取保存的NSArray
 */
+(NSArray *)getArrValueInUDWithKey:(NSString *)key;
/**
 *  获取保存的NSData
 */
+(NSData *)getdataValueInUDWithKey:(NSString *)key;
/**
 *   归档
 */
+ (void)keyedArchiverObject:(id)object ForKey:(NSString *)key ToFile:(NSString *)path;
/**
 *  反归档
 */
+(NSArray *)keyedUnArchiverForKey:(NSString *)key FromFile:(NSString *)path;

/**
 *  获取保存的BOOL
 */
+(BOOL)getBoolValueInUDWithKey:(NSString *)key;
/**
 *  删除对应的KEY
 */
+(void)removeValueInUDWithKey:(NSString *)key;
/**
 *  直接跳转到手机浏览器
 */
+(void)openURLAtSafari:(NSString *)urlString;
/**
 *  设置语音提示
 */
+(void)SpeechSynthesizer:(NSString *)SpeechUtterancestring;
/**
 *  心跳动画
 */
+(void)heartbeatView:(UIView *)view duration:(CGFloat)fDuration maxSize:(CGFloat)fMaxSize durationPerBeat:(CGFloat)fDurationPerBeat;
/**
 *  保存数组数据以  data.plist
 */
+(void)save:(NSArray *)Array data_plist:(NSString *)plistname;
/**
 *  拨打电话号码
 */
+(void)makePhoneCallWithNumber:(NSString *)number;
/**
 *   调转到系统邮箱
 */
+(void)makeEmil:(NSString *)mailbox;
/**
 *  保存相应viwe的图片到相册
 */
+(void)savePhoto:(UIView *)views;
+(void)saveImage:(UIImage *)image assetCollectionName:(NSString *)collectionName;
/**
 *  修改状态栏的颜色
 */
+ (void)statusBarBackgroundColor:(UIColor *)statusBarColor;
/**
 *  改变导航栏工具条字体颜色 0 为白色 1 为黑色
 */
+(void)BackstatusBarStyle:(NSInteger)index;
/**
 *  按钮旋转动画
 */
+(void)RotatinganimationView:(UIButton *)btn animateWithDuration:(NSTimeInterval)duration;
/**
 *  得到中英文混合字符串长度
 */
+ (int)lengthForText:(NSString *)text;
/**
 *  清楚缓存数据
 */
+(void)clearFile;
/**
 *  打印成员变量列表
 */
+ (void)runTimeConsoleMemberListWithClassName:(Class)className;
/**
 *  打印属性列表
 */
+ (void)runTimeConsolePropertyListWithClassName:(Class)className;
#pragma ****************************************其他方法****************************************
/**
 *  过滤数组中相等的数据
 */
+(NSArray *)filterSameObject:(NSArray *)array;
/**
 *  获取保存好的数组数据以  data.plist
 */
+(NSArray *)readsenderArraydata_plist:(NSString *)plistname;
/**
 *  新建UICollectionViewFlowLayout容器
 */
+(UICollectionViewFlowLayout *)setUICollectionViewFlowLayoutWidths:(float)width High:(float)high minHspacing:(float)minhs minVspacing:(float)minvs UiedgeUp:(float)up Uiedgeleft:(float)left Uiedgebottom:(float)bottom Uiedgeright:(float)right Scdirection:(BOOL) direction;
/**
 *  获取某个view在屏幕上的frame
 */
+(CGRect)rectFromSunView:(UIView *)view;
/**
 *  获取缓存数据单位 M
 */
+(float)readCacheSize;

@end

NS_ASSUME_NONNULL_END
