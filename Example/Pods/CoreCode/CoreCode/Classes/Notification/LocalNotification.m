//
//  LocalNotification.m
//  OneStore
//
//  Created by airspuer on 13-8-20.
//  Copyright (c) 2013年 OneStore. All rights reserved.
//

#import "LocalNotification.h"
#import "Foundation+Safe.h"
#import "CoreAlertController.h"
#import <UserNotifications/UserNotifications.h>

NSString *const LocalNotificationRouterUrl = @"routerUrl";
const NSString* LocalNotificationValue = @"LocalNotificationValue";


@implementation LocalNotification

+ (void)createLocalNotificationWithName:(const NSString*)notificationName
                              withTitle:(NSString*)notificationTitle
                           withFireDate:(NSDate*)fireDate
                               userInfo:(NSDictionary*)userInfo
                              routerUrl:(NSString *)routerUrl
{
    if (notificationName.length <= 0) {
        return;
    }
    //没有过期时间则不创建
    if (!fireDate) {
        return;
    }
    //创建非重复的通知
    if ([self isExistLocalNotificationWithName:notificationName]) {
        return;
    }
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = notificationTitle;
    localNotification.fireDate = fireDate;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    //设置按钮
    localNotification.alertAction = @"关闭";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict safeSetObject:LocalNotificationValue forKey:notificationName];
    [dict safeSetObject:routerUrl forKey:LocalNotificationRouterUrl];
    if (userInfo != nil) {
        [dict addEntriesFromDictionary:userInfo];
    }
    [localNotification setUserInfo:dict];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

+ (void)createLocalNotificationWithName:(const NSString*)notificationName
                              withTitle:(NSString*)notificationTitle
                           withFireDate:(NSDate*)fireDate
                              routerUrl:(NSString *)routerUrl
                       aCompletionBlock:(LocalNotificationCompletionBlock)aCompletionBlock {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                    [self createLocalNotificationWithName:notificationName withTitle:notificationTitle withFireDate:fireDate userInfo:nil routerUrl:routerUrl];
                    if (aCompletionBlock) {
                        aCompletionBlock(YES);
                    }
                } else {
                    [self openNotificationSetting];
                }
            });
        }];
    } else {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone == setting.types) {
            [self openNotificationSetting];
        } else {
            [self createLocalNotificationWithName:notificationName withTitle:notificationTitle withFireDate:fireDate userInfo:nil routerUrl:routerUrl];
            if (aCompletionBlock) {
                aCompletionBlock(YES);
            }
        }
    }
}

+ (void)openNotificationSetting {
    [CoreAlertController alertWithTitle:nil message:@"系统推送功能未开启,无法提醒到您，去开启吧~" leftButtonTitle:@"取消" rightButtonTitle:@"去设置" andCompleteBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
        } else if (buttonIndex == 1) {
            NSString *settingURLStr = UIApplicationOpenSettingsURLString;
            NSURL *url = [NSURL URLWithString:settingURLStr];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url ];
            }
        }
    }];
}


+ (void)createLocalNotificationWithName:(const NSString*)notificationName
							  withTitle:(NSString*)notificationTitle
						   withFireDate:(NSDate*)fireDate
						   routerUrl:(NSString *)routerUrl
{
    [self createLocalNotificationWithName:notificationName withTitle:notificationTitle withFireDate:fireDate userInfo:nil routerUrl:routerUrl];
}

+ (UILocalNotification *)findLocalNotificationWithName:(const NSString*)notificationName
{
    if (notificationName.length <= 0) {
        return nil;
    }
    
    UILocalNotification* resultLocalNotification = nil;
    NSArray *localNotificationArray=[[UIApplication sharedApplication] scheduledLocalNotifications];
    for(UILocalNotification* localNotification in localNotificationArray){
        NSDictionary* notificationUserInfo = localNotification.userInfo;
        NSString* notificationValue = [notificationUserInfo objectForKey:notificationName];
        if([notificationValue isEqualToString:(NSString*)LocalNotificationValue]){
            resultLocalNotification = localNotification;
            break;
        }
    }
    return resultLocalNotification;
}

+ (BOOL)isExistLocalNotificationWithName:(const NSString*)notificationName
{
    if (notificationName.length <= 0) {
        return NO;
    }
    UILocalNotification* resultLocalNotification =  [self findLocalNotificationWithName:notificationName];
    return (resultLocalNotification != nil);
}


+ (void)cancelLocalNotificationWithName:(const NSString*)notificationName
{
    if (notificationName.length <= 0) {
        return;
    }
    UILocalNotification* resultLocalNotification =  [self findLocalNotificationWithName:notificationName];
    if(resultLocalNotification){
        [[UIApplication sharedApplication] cancelLocalNotification:resultLocalNotification];
    }
}

@end
