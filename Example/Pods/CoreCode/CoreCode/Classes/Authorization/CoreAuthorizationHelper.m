//
//  CoreAuthorizationHelper.m
//  Base
//
//  Created by zhaoguang on 2018/2/5.
//  Copyright © 2018年 com.yhd. All rights reserved.
//

#import "CoreAuthorizationHelper.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import <EventKit/EventKit.h>
#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>
@implementation CoreAuthorizationHelper

#pragma mark - public -
- (void)requestAuthorization:(PBAuthorizationType)authorizationType authorized:(AuthorizedBlock)authorized {
    if (!authorized) {
        return;
    }
    PBAuthorizationStatus status = [self getAuthorizationStatus:authorizationType];
    if (status == PBAuthorizationNotDetermined) {
        // 请求授权后再返回
        [self requestAuthorizationDirect:authorizationType authorized:authorized];
    } else {
        authorized (status == PBAuthorizationAuthorized);
    }
}

- (PBAuthorizationStatus)getAuthorizationStatus:(PBAuthorizationType)authorizationType {
    PBAuthorizationStatus status;
    switch (authorizationType) {
        case PBAuthorizationTypeAlbum:
            status = [self getAlbumAuthorizationStatus];
            break;
        case PBAuthorizationTypeCamera:
            status = [self getCameraAuthorizationStatus];
            break;
        case PBAuthorizationTypeAudio:
            status = [self getAudioAuthorizationStatus];
            break;
        case PBAuthorizationTypeAddressBook:
            status = [self getAddressBookAuthorizationStatus];
            break;
        case PBAuthorizationTypeNotification:
            status = [self getNotificationAuthorizationStatus];
            break;
        case PBAuthorizationTypeCalendar:
            status = [self getCalendarAuthorizationStatus];
            break;
    }
    return status;
}

- (void)requestAuthorizationDirect:(PBAuthorizationType)authorizationType authorized:(AuthorizedBlock)authorized {
    switch (authorizationType) {
        case PBAuthorizationTypeAlbum:
            [self requestAlbumAuthorization:authorized];
            break;
        case PBAuthorizationTypeCamera:
            [self requestCameraAuthorization:authorized];
            break;
        case PBAuthorizationTypeAudio:
            [self requestAudioAuthorization:authorized];
            break;
        case PBAuthorizationTypeAddressBook:
            [self requestAddressBookAuthorization:authorized];
            break;
        case PBAuthorizationTypeNotification:
            [self requestNotificationAuthorization:authorized];
            break;
        case PBAuthorizationTypeCalendar:
            [self requestCalendarAuthorization:authorized];
            break;
        default:
            break;
    }
}

#pragma mark - request authorization -
- (void)requestNotificationAuthorization:(AuthorizedBlock)authorized {
    if(@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
             authorized(granted);
         }];
    } else {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}

- (void)requestAlbumAuthorization:(AuthorizedBlock)authorized {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        authorized(status == PHAuthorizationStatusAuthorized);
    }];
}

- (void)requestCameraAuthorization:(AuthorizedBlock)authorized {
    [self requestAudioVideoAuthorization:AVMediaTypeVideo authorized:authorized];
}

- (void)requestAudioAuthorization:(AuthorizedBlock)authorized {
    [self requestAudioVideoAuthorization:AVMediaTypeAudio authorized:authorized];
}

- (void)requestAudioVideoAuthorization:(AVMediaType)type authorized:(AuthorizedBlock)authorized {
    [AVCaptureDevice requestAccessForMediaType:type completionHandler:^(BOOL granted) {//相机权限
        authorized(granted);
    }];
}

- (void)requestAddressBookAuthorization:(AuthorizedBlock)authorized {
    if(@available(iOS 9.0, *)) {
        CNContactStore *contactStore = [[CNContactStore alloc] init];
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            authorized(granted);
        }];
    } else {
        ABAddressBookRef addressBookRef =  ABAddressBookCreate();
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            authorized(granted);
        });
    }
}

- (void)requestCalendarAuthorization:(AuthorizedBlock)authorized {
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        authorized(granted);
    }];
}

#pragma mark - query status -
- (PBAuthorizationStatus)getCalendarAuthorizationStatus {
    PBAuthorizationStatus authorizatioStatus = PBAuthorizationAuthorized;
    EKAuthorizationStatus EKstatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    switch (EKstatus) {
        case EKAuthorizationStatusAuthorized:
            authorizatioStatus = PBAuthorizationAuthorized;
            break;
        case EKAuthorizationStatusDenied:
            authorizatioStatus = PBAuthorizationDenied;
            break;
        case EKAuthorizationStatusNotDetermined:
            authorizatioStatus = PBAuthorizationNotDetermined;
            break;
        case EKAuthorizationStatusRestricted:
            authorizatioStatus = PBAuthorizationRistricted;
            break;
        default: break;
    }
    return authorizatioStatus;
}

- (PBAuthorizationStatus)getNotificationAuthorizationStatus {
    __block PBAuthorizationStatus authorizatioStatus = PBAuthorizationDenied;
    if(@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            switch (settings.authorizationStatus) {
                case UNAuthorizationStatusNotDetermined:
                    authorizatioStatus = PBAuthorizationNotDetermined;
                    break;
                case UNAuthorizationStatusAuthorized:
                    authorizatioStatus = PBAuthorizationAuthorized;
                    break;
                case UNAuthorizationStatusDenied:
                    authorizatioStatus = PBAuthorizationDenied;
                    break;
                default:
                    break;
            }
            dispatch_semaphore_signal(sema);
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    } else {
        UIUserNotificationSettings *type = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (type.types != UIUserNotificationTypeNone) {
            authorizatioStatus = PBAuthorizationAuthorized;
        }
    }
    return authorizatioStatus;
}

- (PBAuthorizationStatus)getAddressBookAuthorizationStatus {
    PBAuthorizationStatus authorizatioStatus = PBAuthorizationDenied;
    if(@available(iOS 9.0, *)) {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        switch (status) {
            case CNAuthorizationStatusAuthorized:
                authorizatioStatus = PBAuthorizationAuthorized;
                break;
            case CNAuthorizationStatusDenied:
                authorizatioStatus = PBAuthorizationDenied;
                break;
            case CNAuthorizationStatusNotDetermined:
                authorizatioStatus = PBAuthorizationNotDetermined;
                break;
            case CNAuthorizationStatusRestricted:
                authorizatioStatus = PBAuthorizationRistricted;
                break;
            default: break;
        }
    } else {
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        switch (status) {
            case kABAuthorizationStatusAuthorized:
                authorizatioStatus = PBAuthorizationAuthorized;
                break;
            case kABAuthorizationStatusDenied:
                authorizatioStatus = PBAuthorizationDenied;
                break;
            case kABAuthorizationStatusNotDetermined:
                authorizatioStatus = PBAuthorizationNotDetermined;
                break;
            case kABAuthorizationStatusRestricted:
                authorizatioStatus = PBAuthorizationRistricted;
                break;
            default: break;
        }
    }
    return authorizatioStatus;
}

- (PBAuthorizationStatus)getAudioAuthorizationStatus {
    PBAuthorizationStatus authorizatioStatus = [self getAudioCameraAuthorizationStatus:AVMediaTypeAudio];
    return authorizatioStatus;
}

- (PBAuthorizationStatus)getCameraAuthorizationStatus {
    PBAuthorizationStatus authorizatioStatus = [self getAudioCameraAuthorizationStatus:AVMediaTypeVideo];
    return authorizatioStatus;
}

- (PBAuthorizationStatus)getAudioCameraAuthorizationStatus:(AVMediaType)type {
    PBAuthorizationStatus authorizatioStatus;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:type];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:
            authorizatioStatus = PBAuthorizationNotDetermined;
            break;
        case AVAuthorizationStatusAuthorized:
            authorizatioStatus = PBAuthorizationAuthorized;
            break;
        case AVAuthorizationStatusRestricted:
            authorizatioStatus = PBAuthorizationRistricted;
            break;
        case AVAuthorizationStatusDenied:
            authorizatioStatus = PBAuthorizationDenied;
            break;
    }
    return authorizatioStatus;
}

- (PBAuthorizationStatus)getAlbumAuthorizationStatus {
    PBAuthorizationStatus authorizatioStatus;
    if(@available(iOS 8.0, *)) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        switch (status) {
            case PHAuthorizationStatusNotDetermined:
                authorizatioStatus = PBAuthorizationNotDetermined;
                break;
            case PHAuthorizationStatusAuthorized:
                authorizatioStatus = PBAuthorizationAuthorized;
                break;
            case PHAuthorizationStatusRestricted:
                authorizatioStatus = PBAuthorizationRistricted;
                break;
            case PHAuthorizationStatusDenied:
                authorizatioStatus = PBAuthorizationDenied;
                break;
        }
    } else {
        ALAuthorizationStatus author =[ALAssetsLibrary authorizationStatus];
        switch (author) {
            case ALAuthorizationStatusRestricted:
                authorizatioStatus = PBAuthorizationRistricted;
                break;
            case ALAuthorizationStatusDenied:
                authorizatioStatus = PBAuthorizationDenied;
                break;
            case ALAuthorizationStatusAuthorized:
                authorizatioStatus = PBAuthorizationAuthorized;
                break;
            case ALAuthorizationStatusNotDetermined:
                authorizatioStatus = PBAuthorizationNotDetermined;
                break;
        }
    }
    return authorizatioStatus;
}

-(void)goToAppSystemSetting{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - init -
+ (instancetype)sharedInstance {
    static CoreAuthorizationHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[CoreAuthorizationHelper alloc] init];
    });
    return helper;
}


@end
