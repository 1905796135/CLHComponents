//
//  CalendarNotification.m
//  OneStoreBase
//
//  Created by HUI on 16/6/30.
//  Copyright © 2016年 OneStoreBase. All rights reserved.
//

#import "CoreCalendarNotificationCenter.h"
#import <EventKit/EventKit.h>
@implementation CalendarNotificationEventVO

- (instancetype)initWithTitle:(NSString *)title
                         desc:(NSString *)desc
                     location:(NSString *)location
                    routerUrl:(NSString *)routerUrl
                remindMinutes:(NSNumber *)remindMinutes
                        start:(NSDate *)start
                          end:(NSDate *)end
                     hasAlarm:(BOOL)hasAlarm {
    self = [super init];
    if (self) {
        self.title = title;
        self.desc = desc;
        self.location = location;
        self.routerUrl = routerUrl;
        self.remindMinutes = remindMinutes;
        self.start = start;
        self.end = end;
        self.hasAlarm = hasAlarm;
    }
    return self;
}

@end

@implementation CoreCalendarNotificationCenter

static EKEventStore *eventStore = nil;

+ (void)creatCalendarNotificationWithEventVO:(CalendarNotificationEventVO *)eventVO
                             completionBlock:(CalendarNotifCompletionBlock)aCompletionBlock {
    EKAuthorizationStatus curEKStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    if (curEKStatus == EKAuthorizationStatusNotDetermined) {
        if (!eventStore) eventStore = [[EKEventStore alloc]init];
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error || !granted) {
                    if (aCompletionBlock) {
                        aCompletionBlock(granted, error);
                    }
                } else {
                    [self creatCalendarNotificationIsAuthWithEventVO:eventVO eventStore:eventStore completionBlock:aCompletionBlock];
                }
            });
        }];
    } else if (curEKStatus == EKAuthorizationStatusAuthorized) {
        if (!eventStore) eventStore = [[EKEventStore alloc]init];
        [self creatCalendarNotificationIsAuthWithEventVO:eventVO eventStore:eventStore completionBlock:aCompletionBlock];
    } else {
        if (aCompletionBlock) {
            aCompletionBlock(NO, nil);
        }
    }
}

+ (void)creatCalendarNotificationIsAuthWithEventVO:(CalendarNotificationEventVO *)eventVO
                                        eventStore:(EKEventStore *)eventStore
                                        completionBlock:(CalendarNotifCompletionBlock)aCompletionBlock {
    if (eventVO.start) {
        if ([eventStore defaultCalendarForNewEvents] == nil) {
            eventStore = [[EKEventStore alloc] init];
        }
        EKEvent *event = [EKEvent eventWithEventStore:eventStore];
        event.timeZone = [NSTimeZone systemTimeZone];
        event.startDate = eventVO.start;
        event.endDate = eventVO.end;
        event.title = eventVO.title;
        event.notes = eventVO.desc;
        event.location = eventVO.location;
        [event addAlarm:[EKAlarm alarmWithAbsoluteDate:eventVO.start]];
        if (eventVO.routerUrl.length) {
            event.URL = [NSURL URLWithString:eventVO.routerUrl];
        }
        event.calendar = [eventStore defaultCalendarForNewEvents];
        
        if (eventVO.remindMinutes) {
            EKRecurrenceEnd *end = [EKRecurrenceEnd recurrenceEndWithOccurrenceCount:3];
            EKRecurrenceRule *rule = [[EKRecurrenceRule alloc]initRecurrenceWithFrequency:EKRecurrenceFrequencyDaily interval:eventVO.remindMinutes.integerValue end:end];
            [event addRecurrenceRule:rule];
        }
        
        NSError *error;
        BOOL succees = [eventStore saveEvent:event span:EKSpanThisEvent error:&error];
        if (aCompletionBlock) {
            aCompletionBlock(succees, error);
        }
    } else {
        if (aCompletionBlock) {
            aCompletionBlock(NO, nil);
        }
    }
}

+ (void)cancelCalendarNotificationWithEventVO:(CalendarNotificationEventVO *)eventVO
                              completionBlock:(CalendarNotifCompletionBlock)aCompletionBlock {
    if ([eventVO isKindOfClass:[CalendarNotificationEventVO class]]) {
        [self cancelCalendarNotificationWithRemindStartDate:eventVO.start remindContent:eventVO.title completionBlock:aCompletionBlock];
    }
}

+ (void)cancelCalendarNotificationWithRemindStartDate:(NSDate *)startDate
                                  remindContent:(NSString *)remindContent
                                completionBlock:(CalendarNotifCompletionBlock)aCompletionBlock {
    if (!eventStore) eventStore = [[EKEventStore alloc]init];
    NSArray *eventsArray = [self allCalendarEventsArrayWithEventStore:eventStore];
    BOOL isContainEvent = NO;
    BOOL deleteSuccess = NO;
    NSError *deleteError;
    if (eventsArray.count) {
        for (EKEvent *item in eventsArray) {
            if ([item.title isEqualToString:remindContent] && [item.startDate compare:startDate] == NSOrderedSame) {
                isContainEvent = YES;
                deleteSuccess = [eventStore removeEvent:item span:EKSpanThisEvent commit:YES error:&deleteError];
                break;
            }
        }
        if (!isContainEvent) {
            if (aCompletionBlock) {
                aCompletionBlock(NO, nil);
            }
        } else {
            if (aCompletionBlock) {
                aCompletionBlock(deleteSuccess, deleteError);
            }
        }
    } else {
        if (aCompletionBlock) {
            aCompletionBlock(NO, nil);
        }
    }
}

+ (NSArray *)allCalendarEventsArrayWithEventStore:(EKEventStore *)eventStore {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSDate *startDate = [formatter dateFromString:@"20171221000000"];
    NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * 365 * 2];
    NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:nil];
    return [eventStore eventsMatchingPredicate:predicate];
}

@end
