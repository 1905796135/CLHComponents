//
//  ConvertImageString.m
//  OneStoreFramework
//
//  Created by zhangbin on 14-9-28.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "ConvertImageString.h"

@implementation ConvertImageString

+ (NSString *)getPictureURLWithSize:(CGSize)aSize path:(NSString *)path {
    return [self __getPictureURLWithWidth:aSize.width height:aSize.height path:path host:nil highPrecision:NO];
}

+ (NSString *)getPictureURLWithWidth:(NSInteger)width height:(NSInteger)height path:(NSString *)path {
    return [self __getPictureURLWithWidth:width height:height path:path host:nil highPrecision:NO];
}

+ (NSString *)getPictureURLWithSize:(CGSize)aSize path:(NSString *)path host:(NSString *)host {
    return [self __getPictureURLWithWidth:aSize.width height:aSize.height path:path host:host highPrecision:NO];
}

+ (NSString *)getPictureURLWithWidth:(NSInteger)width height:(NSInteger)height path:(NSString *)path host:(NSString *)host {
    return [self __getPictureURLWithWidth:width height:height path:path host:host highPrecision:NO];
}

+ (NSString *)getPictureURLWithSize:(CGSize)aSize path:(NSString *)path host:(NSString *)host highPrecision:(BOOL)highPrecision {
    return [self __getPictureURLWithWidth:aSize.width height:aSize.height path:path host:host highPrecision:highPrecision];
}

+ (NSString *)getPictureURLWithWidth:(NSInteger)width height:(NSInteger)height path:(NSString *)path host:(NSString *)host highPrecision:(BOOL)highPrecision {
    return [self __getPictureURLWithWidth:width height:height path:path host:host highPrecision:highPrecision];
}

+ (NSString *)__getPictureURLWithWidth:(NSInteger)width height:(NSInteger)height path:(NSString *)path host:(NSString *)host highPrecision:(BOOL)highPrecision {
    // 异常情况处理
    if (!path.length) {
        return nil;
    } else if (host.length > 0) { // host 处理
        NSString *regex = @"^http";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", regex];
        BOOL valid = [predicate evaluateWithObject:path];
        path = valid ? path : [host stringByAppendingString:path];
    }
    
    if ([path containsString:@".gif"] || (!width || !height) || [path containsString:@"storage.360buyimg.com"]) {
        return path;
    }
    
    path = [self __dpgString:path];
    
    path = [self __pictureQualityString:path];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:path];
    
    if (!components.scheme || !components.host) {
        return path;
    }
    
    NSInteger imageWidth = width * (highPrecision ? 3 : [UIScreen mainScreen].scale);
    NSInteger imageHeight = height * (highPrecision ? 3 : [UIScreen mainScreen].scale);
    NSString *sizeString = [NSString stringWithFormat:@"%zdx%zd", imageWidth, imageHeight];
    
    NSRegularExpression *sizeRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"/s\\d{1,4}x\\d{1,4}" options:0 error:nil];
    NSArray<NSTextCheckingResult *> *matches = [sizeRegularExpression matchesInString:components.path options:0 range:NSMakeRange(0, components.path.length)];
    if (matches.count > 0) {
        for (NSTextCheckingResult *match in matches.reverseObjectEnumerator) {
            components.path = [components.path stringByReplacingCharactersInRange:match.range withString:[NSString stringWithFormat:@"/s%@", sizeString]];
        }
    } else {
        NSRegularExpression *appImageHostRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"^\\w+.360buyimg\\.com" options:0 error:nil];
        if ([appImageHostRegularExpression numberOfMatchesInString:components.host options:0 range:NSMakeRange(0, components.host.length)] > 0) {
            NSRegularExpression *pathRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"^/\\w+/(\\w+)/" options:0 error:nil];
            NSTextCheckingResult *match = [pathRegularExpression firstMatchInString:components.path options:0 range:NSMakeRange(0, components.path.length)];
            if (match) {
                NSRange matchRange = [match rangeAtIndex:1];
                NSString *replaceString = [components.path substringWithRange:matchRange];
                replaceString = [NSString stringWithFormat:@"s%@_%@", sizeString, replaceString];
                components.path = [components.path stringByReplacingCharactersInRange:matchRange withString:replaceString];
            }
        }
    }
    return components.string;
}

+ (NSString *)__dpgString:(NSString *)path {
    BOOL useDPG = YES;//[PBGlobalValue sharedInstance].useDPG;
    if (!useDPG) return path;
    NSString *hostRegex = @".*(img(1[0-4]|20|30)|m)\\.360buyimg\\.com.*";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", hostRegex];
    BOOL hostValid = [predicate evaluateWithObject:path];
    
    return useDPG && hostValid && [path hasSuffix:@".jpg"] ? [path stringByReplacingOccurrencesOfString:@".jpg" withString:@".jpg.dpg"] : path;
}

+ (NSString *)__pictureQualityString:(NSString *)path {
    BOOL lowPictureQuality = YES;//[PBGlobalValue sharedInstance].lowPictureQuality;
    if (!lowPictureQuality) return path;
    NSString *hostRegex = @".*\\.360buyimg\\.com.*";
    NSString *regex = @".*!q[0-9]{1,2}.*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", regex];
    BOOL pictureQualityValid = [predicate evaluateWithObject:path];
    predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", hostRegex];
    BOOL hostValid = [predicate evaluateWithObject:path];
    return hostValid && lowPictureQuality && !pictureQualityValid ? [path stringByAppendingString:@"!q70"] : path;
}

@end
