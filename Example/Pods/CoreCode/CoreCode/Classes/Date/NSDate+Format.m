//
//  NSDate+Format.m
//  MessageCenter
//
//  Created by xiaxiongzhi on 14-9-16.
//
//

#import "NSDate+Format.h"
#import "Foundation+Safe.h"

@implementation NSDate (Format)

NS_INLINE NSString *__DateToString(NSDate *date, NSDateFormatter *formatter) {
    if (![date isKindOfClass:[NSDate class]]) {
        return nil;
    }
    return [formatter stringFromDate:date];
}

/**
 * 日期 -> 时间戳
 */
- (NSNumber *)dateToTimestamp {
    return @((self.timeIntervalSince1970 * 1000));
}

/**
 * 时间戳 -> 日期
 */
+ (NSDate *)dateWithTimestamp:(NSNumber *)timestamp {
    return [NSDate dateWithTimeIntervalSince1970:timestamp.doubleValue / 1000];
}

/**
 * dateString yyyy/MM/dd  yyyy-MM-dd  yyyy-MM-dd HH:mm  yyyy-MM-dd HH:mm:ss  yyyy-MM-dd HH:mm:ss SSS
 * MM-dd HH:mm MM.dd HH:mm 等等。。
 */
- (NSString *)dateToString_formatStr:(NSString *)formatStr {
    
    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    formater.timeZone = [NSTimeZone localTimeZone];
    [formater setDateFormat:formatStr];
    return __DateToString(self, formater);
}

/**
 * 日期字符串 -> 日期
 */
+ (NSDate *)dateWithFormateStr:(NSString *)formateStr dateStr:(NSString *)dateStr {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:formateStr];
    NSDate * date = [dateFormatter dateFromString:dateStr];
    if (date) {
        return date;
    }
    else
    {
        return [NSDate date];
    }
}

//获取年
- (NSUInteger)getYear {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitYear) fromDate:self];
    return [dayComponents year];
}

//获取月
- (NSUInteger)getMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitMonth) fromDate:self];
    return [dayComponents month];
}

//获取周
- (NSString *)getWeak {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitWeekday;
    NSDateComponents *dayComponents = [calendar components:unitFlags fromDate:self];
    NSArray * weaks = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    return weaks[[dayComponents weekday]-1];
    
}

//获取日
- (NSUInteger)getDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitDay) fromDate:self];
    return [dayComponents day];
}

//获取时
- (NSString *)getHour {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitHour;
    NSDateComponents *dayComponents = [calendar components:unitFlags fromDate:self];
    NSString * hourStr;
    if ([dayComponents hour] < 10) {
        hourStr = [NSString stringWithFormat:@"0%ld",[dayComponents hour]];
    }
    else
    {
        hourStr = [NSString stringWithFormat:@"%ld",[dayComponents hour]];
        
    }
    return hourStr;
}

//获取分
- (NSString *)getMinute {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitMinute;
    NSDateComponents *dayComponents = [calendar components:unitFlags fromDate:self];
    NSString * minuteStr;
    if ([dayComponents minute] < 10) {
        minuteStr = [NSString stringWithFormat:@"0%ld",[dayComponents minute]];
    }
    else
    {
        minuteStr = [NSString stringWithFormat:@"%ld",[dayComponents minute]];
        
    }
    return minuteStr;
}

//获取秒
- (NSUInteger)getSecond {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitDay) fromDate:self];
    return [dayComponents second];
}

/**
 *    功能:获取距离现在的天数，小于一天为0
 *
 *    @return Days
 */
- (NSUInteger)distanceNowDays {
    NSTimeInterval seconds = [self timeIntervalSinceNow];
    if (seconds < 0) {
        seconds = -seconds;
    }
    NSInteger daySeconds = 60 * 60 * 24;
    NSInteger days = (NSInteger) (seconds / daySeconds);
    return days;
}

/**
 *  功能:日期距离当前时间的描述，改描述为:_天_时_分_秒
 *
 *  @return map
 */
- (NSDictionary *)distanceNowDicWith:(NSDate *)nowDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:kCFCalendarUnitDay | kCFCalendarUnitHour | kCFCalendarUnitMinute | kCFCalendarUnitSecond fromDate:nowDate toDate:self options:0];
    
    NSDictionary *dic = nil;
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@(comps.day), @"day", @(comps.hour), @"hour", @(comps.minute), @"minute", @(comps.second), @"second", nil];
    
    return dic;
}
/**
 *  是否是今天的日期
 *
 *  @return 返回YES OR NO
 */
- (BOOL)isTodayDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today = [dateFormatter stringFromDate:[NSDate date]];
    NSString *day = [dateFormatter stringFromDate:self];
    
    if ([today isEqualToString:day]) {
        return YES;
    }
    
    return NO;
}

/**
 *  是否昨天
 */
- (BOOL)isYesterday {
    NSDate *nowDate = [NSDate date];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selStr = [fmt stringFromDate:self];
    NSDate *selfDate = [fmt dateFromString:selStr];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}

/**
 *  是否是今年的日期
 *
 *  @return 返回YES OR NO
 */
- (BOOL)isCurrentYearDate {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *today = [dateFormatter stringFromDate:[NSDate date]];
    NSString *day = [dateFormatter stringFromDate:self];
    
    if ([today isEqualToString:day]) {
        return YES;
    }
    
    return NO;
}
/**
 *  判断与当前时间差值
 */
- (NSDateComponents *)deltaWithNow {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}

/**
 *  把日期转化为距现在的倒计时 (d天)HH:mm:ss
 *
 *  @return 转化后的字符串
 */
- (NSString *)distanceNowFormatterString {
    NSDictionary *dateComponents = [self distanceNowDicWith:[NSDate date]];
    NSString* (^numFormater)(NSNumber *) = ^(NSNumber *num) {
        NSString *res = [NSString stringWithFormat:@"%02ld", num.integerValue];
        return res;
    };
    NSNumber *dayNum = dateComponents[@"day"];
    NSString *dayStr = dayNum.integerValue > 0 ? [NSString stringWithFormat:@"%ld天", dayNum.integerValue] : @"";
    NSString *hoursStr = numFormater(dateComponents[@"hour"]);
    NSString *minutesStr = numFormater(dateComponents[@"minute"]);
    NSString *secondsStr = numFormater(dateComponents[@"second"]);
    NSString *format = [NSString stringWithFormat:@"%@%@:%@:%@", dayStr, hoursStr, minutesStr, secondsStr];
    
    return format;
}
@end
