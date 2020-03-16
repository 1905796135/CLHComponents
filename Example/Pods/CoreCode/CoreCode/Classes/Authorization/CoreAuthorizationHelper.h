//
//  CoreAuthorizationHelper.h
//  PBBase
//
//  Created by zhaoguang on 2018/2/5.
//  Copyright © 2018年 com.yhd. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^AuthorizedBlock) (BOOL result);

typedef NS_ENUM(NSInteger,PBAuthorizationStatus) {
    PBAuthorizationNotDetermined,// 用户尚未作出选择
    PBAuthorizationAuthorized,// 允许
    PBAuthorizationRistricted,// 受限
    PBAuthorizationDenied,// 不允许
};

typedef NS_ENUM(NSInteger,PBAuthorizationType) {
    PBAuthorizationTypeCamera,// 相机权限
    PBAuthorizationTypeAlbum,// 相册权限
    PBAuthorizationTypeAudio,// 麦克风权限
    PBAuthorizationTypeAddressBook,// 通讯录权限
    PBAuthorizationTypeNotification,// 推送权限
    PBAuthorizationTypeCalendar,// 日历权限
//    PBAuthorizationTypeLocation,// 位置权限
};

@interface CoreAuthorizationHelper : NSObject

/**
 查询当前授权状态

 @param authorizationType : PBAuthorizationType 权限类型
 @return 授权状态 : BOOL
 */
- (PBAuthorizationStatus)getAuthorizationStatus:(PBAuthorizationType)authorizationType;

/**
 请求权限

 @param authorizationType : PBAuthorizationType 权限类型
 @param authorized : AuthorizedBlock 请求权限结果
 */
- (void)requestAuthorizationDirect:(PBAuthorizationType)authorizationType authorized:(AuthorizedBlock)authorized;

/**
 查询当前是否已经授权,如果用户还没有做选择，则先去请求权限，再将请求结果返回
 
 @param authorizationType : PBAuthorizationType 权限类型
 @param authorized : AuthorizedBlock 请求权限结果回调
 */
- (void)requestAuthorization:(PBAuthorizationType)authorizationType authorized:(AuthorizedBlock)authorized;

/**
 jump to app setting
 */
- (void)goToAppSystemSetting;

/**
 单例

 @return 单例
 */
+ (instancetype)sharedInstance;

@end
