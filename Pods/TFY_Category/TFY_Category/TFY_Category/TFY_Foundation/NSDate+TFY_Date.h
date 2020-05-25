//
//  NSDate+TFY_Date.h
//  TFY_AutoLMTools
//
//  Created by 田风有 on 2019/5/20.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (TFY_Date)
/**
 * 获取日、月、年、小时、分钟、秒
 */
- (NSUInteger)day;
- (NSUInteger)month;
- (NSUInteger)year;
- (NSUInteger)hour;
- (NSUInteger)minute;
- (NSUInteger)second;
+ (NSUInteger)day:(NSDate *)date;
+ (NSUInteger)month:(NSDate *)date;
+ (NSUInteger)year:(NSDate *)date;
+ (NSUInteger)hour:(NSDate *)date;
+ (NSUInteger)minute:(NSDate *)date;
+ (NSUInteger)second:(NSDate *)date;

/**
 * 获取一年中的总天数
 */
- (NSUInteger)daysInYear;
+ (NSUInteger)daysInYear:(NSDate *)date;

/**
 * 判断是否是润年
 * @return YES表示润年，NO表示平年
 */
- (BOOL)isLeapYear;
+ (BOOL)isLeapYear:(NSDate *)date;

/**
 * 获取该日期是该年的第几周
 */
- (NSUInteger)weekOfYear;
+ (NSUInteger)weekOfYear:(NSDate *)date;

/**
 * 获取格式化为YYYY-MM-dd格式的日期字符串
 */
- (NSString *)formatYMD;
+ (NSString *)formatYMD:(NSDate *)date;

/**
 * 返回当前月一共有几周(可能为4,5,6)
 */
- (NSUInteger)weeksOfMonth;
+ (NSUInteger)weeksOfMonth:(NSDate *)date;

/**
 * 获取该月的第一天的日期
 */
- (NSDate *)begindayOfMonth;
+ (NSDate *)begindayOfMonth:(NSDate *)date;

/**
 * 获取该月的最后一天的日期
 */
- (NSDate *)lastdayOfMonth;
+ (NSDate *)lastdayOfMonth:(NSDate *)date;

/**
 * 返回day天后的日期(若day为负数,则为|day|天前的日期)
 */
- (NSDate *)dateAfterDay:(NSUInteger)day;
+ (NSDate *)dateAfterDate:(NSDate *)date day:(NSInteger)day;

/**
 * 返回day天后的日期(若day为负数,则为|day|天前的日期)
 */
- (NSDate *)dateAfterMonth:(NSUInteger)month;
+ (NSDate *)dateAfterDate:(NSDate *)date month:(NSInteger)month;

/**
 * 返回numYears年后的日期
 */
- (NSDate *)offsetYears:(int)numYears;
+ (NSDate *)offsetYears:(int)numYears fromDate:(NSDate *)fromDate;

/**
 * 返回numMonths月后的日期
 */
- (NSDate *)offsetMonths:(int)numMonths;
+ (NSDate *)offsetMonths:(int)numMonths fromDate:(NSDate *)fromDate;

/**
 * 返回numDays天后的日期
 */
- (NSDate *)offsetDays:(int)numDays;
+ (NSDate *)offsetDays:(int)numDays fromDate:(NSDate *)fromDate;

/**
 * 返回numHours小时后的日期
 */
- (NSDate *)offsetHours:(int)hours;
+ (NSDate *)offsetHours:(int)numHours fromDate:(NSDate *)fromDate;

/**
 * 距离该日期前几天
 */
- (NSUInteger)daysAgo;
+ (NSUInteger)daysAgo:(NSDate *)date;

/**
 *  获取星期几
 */
- (NSInteger)weekday;
+ (NSInteger)weekday:(NSDate *)date;

/**
 *  获取星期几(名称)
 */
- (NSString *)dayFromWeekday;
+ (NSString *)dayFromWeekday:(NSDate *)date;

/**
 *  日期是否相等
 */
- (BOOL)isSameDay:(NSDate *)anotherDate;

/**
 *  是否是今天
 */
- (BOOL)isToday;
/**
 * 根据日期返回字符串
 */
+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format;
- (NSString *)stringWithFormat:(NSString *)format;
+ (NSDate *)dateWithString:(NSString *)string format:(NSString *)format;

/**
 * 获取指定月份的天数
 */
- (NSUInteger)daysInMonth:(NSUInteger)month;
+ (NSUInteger)daysInMonth:(NSDate *)date month:(NSUInteger)month;

/**
 * 获取当前月份的天数
 */
- (NSUInteger)daysInMonth;
+ (NSUInteger)daysInMonth:(NSDate *)date;

/**
 * 返回x分钟前/x小时前/昨天/x天前/x个月前/x年前
 */
- (NSString *)timeInfo;
+ (NSString *)timeInfoWithDate:(NSDate *)date;
+ (NSString *)timeInfoWithDateString:(NSString *)dateString;

/**
 * 分别获取yyyy-MM-dd/HH:mm:ss/yyyy-MM-dd HH:mm:ss格式的字符串
 */
- (NSString *)ymdFormat;
- (NSString *)hmsFormat;
- (NSString *)ymdHmsFormat;
+ (NSString *)ymdFormat;
+ (NSString *)hmsFormat;
+ (NSString *)ymdHmsFormat;

/**当前日期加几年*/
- (NSDate *)dateByAddingYears:(NSInteger)years;
/**当前日期减几年*/
- (NSDate *)dateByMinusYears:(NSInteger)years;
/**当前日期加几月*/
- (NSDate *)dateByAddingMonths:(NSInteger)months;
/**当前日期减几月*/
- (NSDate *)dateByMinusMonths:(NSInteger)months;
/**当前日期加几周*/
- (NSDate *)dateByAddingWeeks:(NSInteger)weeks;
/**当前日期减几周*/
- (NSDate *)dateByMinusWeeks:(NSInteger)weeks;
/**当前日期加几天*/
- (NSDate *)dateByAddingDays:(NSInteger)days;
/**当前日期减几天*/
- (NSDate *)dateByMinusDays:(NSInteger)days;
/**当前日期加几小时*/
- (NSDate *)dateByAddingHours:(NSInteger)hours;
/**当前日期减几小时*/
- (NSDate *)dateByMinusHours:(NSInteger)hours;
/**当前日期加几分钟*/
- (NSDate *)dateByAddingMinutes:(NSInteger)minutes;
/**当前日期减几分钟*/
- (NSDate *)dateByMinusMinutes:(NSInteger)minutes;
/**当前日期加几秒*/
- (NSDate *)dateByAddingSeconds:(NSInteger)seconds;
/***当前日期减几秒*/
- (NSDate *)dateByMinusSeconds:(NSInteger)seconds;

/**
 *  两个日期之间相差的年数
 *  fromDateTime 开始日期
 *  toDateTime   结束日期
 *  天数
 */
+ (NSInteger)yearsBetweenDate:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime;

/**
 *  两个日期之间相差的月数
 *  fromDateTime 开始日期
 *  toDateTime   结束日期
 *   天数
 */
+ (NSInteger)monthsBetweenDate:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime;

/**
 *  两个日期之间相差的天数
 *  fromDateTime 开始日期
 *  toDateTime   结束日期
 *  天数
 */
+ (NSInteger)daysBetweenDate:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime;

/**
 *  两个日期之间相差的分钟
 *  fromDateTime 开始日期
 *  toDateTime   结束日期
 *  分钟
 */
+ (NSInteger)minutesBetweenDate:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime;

/**
 *  两个日期之间相差的秒数
 *  fromDateTime 开始日期
 *  toDateTime   结束日期
 *  秒数
 */
+ (NSInteger)secondsBetweenDate:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime;
//日历需要的
- (NSInteger)dayNumOfCurrentMonth;

- (NSDate *)dateWithMonthBegainDate;

- (NSDate *)dateWithWeekBegainDate;

- (BOOL)isSameDayToDate:(NSDate *)date;

/// 获取年
+ (NSInteger)year_str:(NSString *)dateStr;
//计算一个月的总天数
+ (NSInteger)daysInthisMonth:(NSDate *)date;
/// 获取月
+ (NSInteger)month_str:(NSString *)dateStr;
/// 获取星期
+ (NSInteger)week:(NSString *)dateStr;
/// 获取星期 中文 日
+ (NSString *)getWeekFromDate:(NSDate *)date;
/// 获取星期 中文 周日
+ (NSString *)getChineseWeekFrom:(NSString *)dateStr;
/// 获取日
+ (NSInteger)day_str:(NSString *)dateStr;
/// 获取月共有多少天
+ (NSInteger)daysInMonth_str:(NSString *)dateStr;

/// 获取当前日期 2018-01-01
+ (NSString *)currentDay;
/// 获取当前小时 00:00
+ (NSString *)currentHour;
/// 获取下月最后一天
+ (NSString *)nextMonthLastDay;

/// 判断是否是今天
+ (BOOL)isToday:(NSString *)dateStr;
/// 判断是否是明天
+ (BOOL)isTomorrow:(NSString *)dateStr;
/// 判断是否是后天
+ (BOOL)isAfterTomorrow:(NSString *)dateStr;
/// 判断是否是过去的时间
+ (BOOL)isHistoryTime:(NSString *)dateStr;

/// 从时间戳获取具体时间 格式:6:00
+ (NSString *)hourStringWithInterval:(NSTimeInterval)timeInterval;
/// 从时间戳获取具体小时 格式:6
+ (NSString *)hourTagWithInterval:(NSTimeInterval)timeInterval;
/// 从毫秒级时间戳获取具体小时 格式:600
+ (NSString *)hourNumberWithInterval:(NSTimeInterval)timeInterval;
/// 从时间戳获取具体日期 格式:2018-03-05
+ (NSString *)timeStringWithInterval:(NSTimeInterval)timeInterval;
/// 从具体日期获取时间戳 毫秒
+ (NSTimeInterval)timeIntervalFromDateString:(NSString *)dateStr;

/// 获取当前天的后几天的星期
+ (NSString *)getWeekAfterDay:(NSInteger)day;
/// 获取当前天的后几天的日
+ (NSString *)getDayAfterDay:(NSInteger)day;
/// 获取当前月的后几月
+ (NSString *)getMonthAfterMonth:(NSInteger)Month;
@end

NS_ASSUME_NONNULL_END
