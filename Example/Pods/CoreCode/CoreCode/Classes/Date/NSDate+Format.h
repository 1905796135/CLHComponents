//
//  NSDate+Format.h
//  MessageCenter
//
//  Created by xiaxiongzhi on 14-9-16.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (Format)

/**
 * 日期 -> 时间戳
 */
- (NSNumber *)dateToTimestamp;

/**
 * 时间戳 -> 日期
 */
+ (NSDate *)dateWithTimestamp:(NSNumber *)timestamp;

/**
 * dateString yyyy/MM/dd  yyyy-MM-dd  yyyy-MM-dd HH:mm  yyyy-MM-dd HH:mm:ss  yyyy-MM-dd HH:mm:ss SSS
 * MM-dd HH:mm MM.dd HH:mm 等等。。
 */
- (NSString *)dateToString_formatStr:(NSString *)formatStr;

/**
 * 日期字符串 -> 日期
 *
 */
+ (NSDate *)dateWithFormateStr:(NSString *)formateStr dateStr:(NSString *)dateStr;

//获取年
- (NSUInteger)getYear;

//获取月
- (NSUInteger)getMonth;

//获取周
- (NSString *)getWeak;

//获取日
- (NSUInteger)getDay;

//获取时
- (NSString *)getHour;

//获取分
- (NSString *)getMinute;

//获取秒
- (NSUInteger)getSecond;

/**
 *    功能:获取距离现在的天数，小于一天为0
 *
 *    @return Days
 */
- (NSUInteger)distanceNowDays;

/**
 *  功能:日期距离当前时间的描述，改描述为:_天_时_分_秒
 *
 *  @return map
 */
- (NSDictionary *)distanceNowDicWith:(NSDate *)nowDate;

/**
 *  是否是今天的日期
 *
 *  @return 返回YES OR NO
 */
- (BOOL)isTodayDate;

/**
 *  是否昨天
 */
- (BOOL)isYesterday;

/**
 *  是否是今年的日期
 *
 *  @return 返回YES OR NO
 */
- (BOOL)isCurrentYearDate;

/**
 *  判断与当前时间差值
 */
- (NSDateComponents *)deltaWithNow;

/**
 *  把日期转化为距现在的倒计时 (d天)HH:mm:ss
 *
 *  @return 转化后的字符串
 */
- (NSString *)distanceNowFormatterString;
@end
