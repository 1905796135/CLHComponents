//
//  Predicate.m
//  OneStore
//
//  Created by Yim Daniel on 13-1-16.
//  Copyright (c) 2013年 OneStore. All rights reserved.
//

#import "Predicate.h"

#define PRED_CONDITION_MOBILE       @"^1[0-9]{10}$"
#define PRED_CONDITION_ZUOJIHAO     @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$"//座机号码判断
#define PRED_CONDITION_CHARACTER    @"[A-Z0-9a-z]+"
#define PRED_CONDITION_EMAIL        @"^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$"
#define PRED_CONDITION_CHINESE     @"[\u4e00-\u9fa5]"
static NSString *const kPRED_CONDITION_ZUOJIHAO = @"0[0-9]{2,3}-[0-9]{7,8}";//座机号码判断(新添加)

@implementation Predicate

+ (BOOL)checkPhoneNumber:(NSString *)aCandidate {
    if (aCandidate.length != 11) {
        return NO;
    }
    return [self __checkCandidate:aCandidate condition:PRED_CONDITION_MOBILE];
}

+ (BOOL)checkZuoJiHaoNumber:(NSString *)aCandidate {
    return [self __checkCandidate:aCandidate condition:kPRED_CONDITION_ZUOJIHAO];
}

+ (BOOL)checkCharacter:(NSString *)aCandidate {
    return [self __checkCandidate:aCandidate condition:PRED_CONDITION_CHARACTER];
}

+ (BOOL)checkChineseChar:(NSString *)aCandidate {
    NSRange urgentRange = [aCandidate rangeOfString:PRED_CONDITION_CHINESE options:NSRegularExpressionSearch];
    if (urgentRange.location == NSNotFound) {
        return NO;
    }
    return YES;
}

+ (BOOL)checkEmail:(NSString *)aCandidate {
    return [self __checkCandidate:aCandidate condition:PRED_CONDITION_EMAIL];
}


+ (BOOL)__checkCandidate:(NSString *)aCandidate condition:(NSString *)aCondition {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", aCondition];
    return [predicate evaluateWithObject:aCandidate];
}

+ (BOOL)isContainsEmoji:(NSString *)string {
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
            ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                const unichar hs = [substring characterAtIndex:0];
                if (0xd800 <= hs && hs <= 0xdbff) {
                    if (substring.length > 1) {
                        const unichar ls = [substring characterAtIndex:1];
                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                            isEomji = YES;
                        }
                    }
                } else if (substring.length > 1) {
                    const unichar ls = [substring characterAtIndex:1];
                    if (ls == 0x20e3) {
                        isEomji = YES;
                    }
                } else {
                    if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                        isEomji = YES;
                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                        isEomji = YES;
                    } else if (0x2934 <= hs && hs <= 0x2935) {
                        isEomji = YES;
                    } else if (0x3297 <= hs && hs <= 0x3299) {
                        isEomji = YES;
                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50 || hs == 0x231a) {
                        isEomji = YES;
                    }
                }
            }];
    return isEomji;
}

#pragma mark - 验证手机号码的方法

+ (BOOL)validateMobile:(NSString *)mobileNum {

    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PRED_CONDITION_MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
}

+ (BOOL)checkLandlineNumber:(NSString *)aCandidate {
    if ([self __checkCandidate:aCandidate condition:kPRED_CONDITION_ZUOJIHAO]) {
        return [self __checkCandidate:aCandidate condition:kPRED_CONDITION_ZUOJIHAO];
    }
    return [self __checkCandidate:aCandidate condition:PRED_CONDITION_ZUOJIHAO];
}

+ (BOOL)multipleScene {
    NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
    if ([infoDict objectForKey:@"UIApplicationSceneManifest"]) {
        return YES;
    } else {
        return NO;
    }
}
@end
