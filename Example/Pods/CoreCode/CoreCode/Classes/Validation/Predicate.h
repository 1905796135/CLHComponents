//
//  Predicate.h
//  OneStore
//
//  Created by Yim Daniel on 13-1-16.
//  Copyright (c) 2013年 OneStore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Predicate : NSObject

// 检查电话号码
+ (BOOL)checkPhoneNumber:(NSString *)aCandidate;

//// 检查座机号
+ (BOOL)checkZuoJiHaoNumber:(NSString *)aCandidate;

// 检查字符
+ (BOOL)checkCharacter:(NSString *)aCandidate;

// 检查邮箱
+ (BOOL)checkEmail:(NSString *)aCandidate;

//是否包含表情
+ (BOOL)isContainsEmoji:(NSString *)string;

// 地址里检查含汉字字符
+ (BOOL)checkChineseChar:(NSString *)aCandidate;

// 检查手机号码
+ (BOOL)validateMobile:(NSString *)mobileNum;

// 加强版 检查座机号
+ (BOOL)checkLandlineNumber:(NSString *)aCandidate;

@end
