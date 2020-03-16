//
//  CalendarNotification.h
//  OneStoreBase
//
//  Created by HUI on 16/6/30.
//  Copyright © 2016年 OneStoreBase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarNotificationEventVO : NSObject

/**
 * React Native添加日历事件
 * method addEvent
 * brief 添加日历事件
 * param {JSON} event 日历事件
 * event 支持的字段：
 * title:日历事件的 title
 * desc:日历事件的描述
 * location:日历事件的 location 字段
 * start:事件开始时间戳
 * end:事件结束时间戳
 * hasAlarm:是否响铃
 * remindMinutes:重复提醒时间间隔
 **/

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *routerUrl;
@property (nonatomic, strong) NSNumber *remindMinutes;
@property (nonatomic, strong) NSDate *start;
@property (nonatomic, strong) NSDate *end;
@property (nonatomic, assign) BOOL hasAlarm;

- (instancetype)initWithTitle:(NSString *)title
                         desc:(NSString *)desc
                     location:(NSString *)location
                    routerUrl:(NSString *)routerUrl
                remindMinutes:(NSNumber *)remindMinutes
                        start:(NSDate *)start
                          end:(NSDate *)end
                     hasAlarm:(BOOL)hasAlarm;
@end



//当无错误返回，会显示当前日历的访问权限
typedef void(^CalendarNotifCompletionBlock)(BOOL success, NSError *anError);

@interface CoreCalendarNotificationCenter : NSObject

/*
 *创建一条日历提醒
 */
+ (void)creatCalendarNotificationWithEventVO:(CalendarNotificationEventVO *)eventVO
                                 completionBlock:(CalendarNotifCompletionBlock)aCompletionBlock;
/*
 *取消日历提醒
 */

+ (void)cancelCalendarNotificationWithEventVO:(CalendarNotificationEventVO *)eventVO
                              completionBlock:(CalendarNotifCompletionBlock)aCompletionBlock;

+ (void)cancelCalendarNotificationWithRemindStartDate:(NSDate *)startDate
                                  remindContent:(NSString *)remindContent
                                completionBlock:(CalendarNotifCompletionBlock)aCompletionBlock;

@end

