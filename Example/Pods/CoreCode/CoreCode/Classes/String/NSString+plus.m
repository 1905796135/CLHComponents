//
//  NSString+plus.m
//  OneStoreFramework
//
//  Created by Aimy on 8/27/14.
//  Copyright (c) 2014 OneStore. All rights reserved.
//

#import "NSString+plus.h"

@implementation NSString (plus)

- (NSNumber *)toNumber {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *number = [formatter numberFromString:self];
    return number;
}

- (NSString *)urlEncoding {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSString *)urlEncodingAllCharacter {
    NSString *outputStr = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef) self, NULL, (CFStringRef) @"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    return outputStr;
}

/**
 *  base64 编码
 *
 *  @return NSString
 */
- (NSString *)base64Encode {
    //先将string转换成data
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *base64Data = [data base64EncodedDataWithOptions:0];
    
    NSString *baseString = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
    
    return baseString;
}

/**
 *  base64 解码
 *
 *  @return NSString
 */
- (NSString *)base64Dencode {
    
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    return string;
}

/**
 *  功能:拼装2个组合字串(知道首字串长度)
 */
- (NSAttributedString *)attributedStringWithHeadAttributes:(NSDictionary *)aAttributes
                                            tailAttributes:(NSDictionary *)bAttributes
                                                headLength:(NSUInteger)aLength {
    NSRange headRange = NSMakeRange(0, aLength);
    NSRange tailRange = NSMakeRange(aLength, self.length - aLength);

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    [attributedString setAttributes:aAttributes range:headRange];
    [attributedString setAttributes:bAttributes range:tailRange];

    return attributedString;
}

/**
 *  功能:拼装2个组合字串(知道尾字串长度)
 */
- (NSAttributedString *)attributedStringWithHeadAttributes:(NSDictionary *)aAttributes
                                            tailAttributes:(NSDictionary *)bAttributes
                                                tailLength:(NSUInteger)aLength {
    NSRange headRange = NSMakeRange(0, self.length - aLength);
    NSRange tailRange = NSMakeRange(self.length - aLength, aLength);

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    [attributedString setAttributes:aAttributes range:headRange];
    [attributedString setAttributes:bAttributes range:tailRange];

    return attributedString;
}

//计算一段字符串的长度，两个英文字符占一个长度。
+ (int)countTheStrLength:(NSString *)strtemp {
    int strlength = 0;
    char *p = (char *) [strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i < [strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            p++;
            strlength++;
        } else {
            p++;
        }
    }
    return (strlength + 1) / 2;
}

//是否是纯int
- (BOOL)isPureInt {
    NSScanner *scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)isENS {
    NSString *string = self;
    if (!string.length) {
        return false;
    }
    NSString *regex = @"[a-zA-Z0-9\u3001!@#$&%^*()_+=:;?/.,{}\\-\\[\\]]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:string];
}

- (BOOL)isEN {
    NSString *string = self;
    if (!string.length) {
        return false;
    }
    NSString *regex = @"[a-zA-Z0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:string];
}

- (BOOL)isCEN {
    NSString *string = self;
    if (!string.length) {
        return false;
    }
    NSString *regex = @"[a-zA-Z0-9\\u4E00-\\u9FEA]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:string];
}

- (NSString *)stringClipByCharLength:(NSUInteger)charlength {
    NSString *str = self;
    
    if ([NSString countTheStrCharLength:str] > charlength && self.length > 0) {
        NSUInteger length = 0;
        NSMutableString *mStr = @"".mutableCopy;
        while (length < self.length) {
            NSString *charStr = [self substringWithRange:NSMakeRange(length, 1)];
            NSInteger charStrCharCount = [NSString countTheStrCharLength:charStr];
            NSInteger mStrCharCount = [NSString countTheStrCharLength:mStr];
            length++;
            if (mStrCharCount + charStrCharCount > charlength) {
                str = mStr.copy;
                break;
            } else {
                [mStr appendString:charStr];
            }
        }
    }
    
    return str;
}

//计算一段字符串的字符长度 一个中文占两个字符长度
+ (int)countTheStrCharLength:(NSString *)strtemp {
    int strlength = 0;
    char *p = (char *) [strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i < [strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            p++;
            strlength++;
        } else {
            p++;
        }
    }
    return strlength;
}

/**
 *  功能:价格字符串小数点前后字体和颜色
 */
- (NSMutableAttributedString *)stringWithColor:(UIColor *)aColor symbolFont:(UIFont *)aSymbolFont integerFont:(UIFont *)aIntrgerFont decimalFont:(UIFont *)aDecimalFont {
    if (self.length <= 0) {
        return nil;
    }
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self];
    [string addAttribute:NSForegroundColorAttributeName value:aColor range:NSMakeRange(0, string.length)];
    [string addAttribute:NSFontAttributeName value:aSymbolFont range:NSMakeRange(0, 1)];
    NSRange range = [self rangeOfString:@"."];
    if (range.location != NSNotFound) {
        [string addAttribute:NSFontAttributeName value:aIntrgerFont range:NSMakeRange(1, range.location)];
        [string addAttribute:NSFontAttributeName value:aDecimalFont range:NSMakeRange(range.location, string.length - range.location)];
    } else {
        [string addAttribute:NSFontAttributeName value:aIntrgerFont range:NSMakeRange(1, string.length - 1)];
    }

    return string;
}

/**
 *  功能:是否浮点型
 */
- (BOOL)isPureFloat {
    NSScanner *scan = [NSScanner scannerWithString:self];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

/**
 *  功能:手机号码脱敏
 */
- (NSString *)phoneRidOfSensitivity:(NSString *)phone
{
    NSString *phoneString = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    
    return phoneString;
}

@end
