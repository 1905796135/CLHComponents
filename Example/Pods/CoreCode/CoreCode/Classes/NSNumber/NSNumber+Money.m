//
//  NSNumber+Format.m
//  OneStoreFramework
//
//  Created by airspuer on 14-9-22.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

//@import Core;
#import "Foundation+Safe.h"
#import "NSString+plus.h"
#import "NSNumber+Money.h"

@implementation NSNumber (Money)

- (NSString *)moneyFormatString {
    NSString *priceString = [NSString stringWithFormat:@"¥%.2f", self.doubleValue];
    NSString *endChar = [priceString safeSubstringWithRange:NSMakeRange(priceString.length - 1, 1)];
    if ([endChar isEqualToString:@"0"]) {
        priceString = [priceString safeSubstringWithRange:NSMakeRange(0, priceString.length - 1)];
    }
    return priceString;
}

- (NSString *)moneyFormatStringWithoutZero {
    NSString *priceString = [NSString stringWithFormat:@"¥%.2f", self.doubleValue];
    NSString *endChar = [priceString safeSubstringWithRange:NSMakeRange(priceString.length - 1, 1)];
    if ([endChar isEqualToString:@"0"]) {
        priceString = [priceString safeSubstringWithRange:NSMakeRange(0, priceString.length - 1)];
        endChar = [priceString safeSubstringWithRange:NSMakeRange(priceString.length - 1, 1)];
        if ([endChar isEqualToString:@"0"]) {
            priceString = [priceString safeSubstringWithRange:NSMakeRange(0, priceString.length - 2)];
        }
    }
    return priceString;
}

+ (NSString *)moneyFormat:(double)aValue {
    NSString *priceString = [NSString stringWithFormat:@"¥%.2f", aValue];
    NSString *endChar = [priceString safeSubstringWithRange:NSMakeRange(priceString.length - 1, 1)];
    if ([endChar isEqualToString:@"0"]) {
        priceString = [priceString safeSubstringWithRange:NSMakeRange(0, priceString.length - 1)];
    }
    return priceString;
}

+ (NSString *)valueFormat:(double)aValue {
    NSString *priceString = [NSString stringWithFormat:@"%.2f", aValue];
    NSString *endChar = [priceString safeSubstringWithRange:NSMakeRange(priceString.length - 1, 1)];
    if ([endChar isEqualToString:@"0"]) {
        priceString = [priceString safeSubstringWithRange:NSMakeRange(0, priceString.length - 1)];
        NSString *endChar = [priceString safeSubstringWithRange:NSMakeRange(priceString.length - 1, 1)];
        if ([endChar isEqualToString:@"0"]) {
            priceString = [priceString safeSubstringWithRange:NSMakeRange(0, priceString.length - 1)];
            NSString *endChar = [priceString safeSubstringWithRange:NSMakeRange(priceString.length - 1, 1)];
            if ([endChar isEqualToString:@"."]) {
                priceString = [priceString safeSubstringWithRange:NSMakeRange(0, priceString.length - 1)];
            }
        }
    }
    return priceString;
}

+ (NSString *)valueFormatWithZero:(double)aValue{
    NSString *priceString = [NSString stringWithFormat:@"%.2f", aValue];
    NSString *endChar = [priceString safeSubstringWithRange:NSMakeRange(priceString.length - 1, 1)];
    if ([endChar isEqualToString:@"0"]) {
        priceString = [priceString safeSubstringWithRange:NSMakeRange(0, priceString.length - 1)];
    }
    return priceString;
}


+ (NSString *)weightFormat:(double)aValue {
    NSString *priceString = [NSString stringWithFormat:@"%.3f", aValue];
    NSString *endChar = [priceString safeSubstringWithRange:NSMakeRange(priceString.length - 1, 1)];
    if ([endChar isEqualToString:@"0"]) {
        priceString = [priceString safeSubstringWithRange:NSMakeRange(0, priceString.length - 1)];
        NSString *endChar = [priceString safeSubstringWithRange:NSMakeRange(priceString.length - 1, 1)];
        if ([endChar isEqualToString:@"0"]) {
            priceString = [priceString safeSubstringWithRange:NSMakeRange(0, priceString.length - 1)];
            NSString *endChar = [priceString safeSubstringWithRange:NSMakeRange(priceString.length - 1, 1)];
            if ([endChar isEqualToString:@"0"]) {
                priceString = [priceString safeSubstringWithRange:NSMakeRange(0, priceString.length - 1)];
                NSString *endChar = [priceString safeSubstringWithRange:NSMakeRange(priceString.length - 1, 1)];
                if ([endChar isEqualToString:@"."]) {
                    priceString = [priceString safeSubstringWithRange:NSMakeRange(0, priceString.length - 1)];
                }
            }
        }
    }
    return priceString;
}

@end
