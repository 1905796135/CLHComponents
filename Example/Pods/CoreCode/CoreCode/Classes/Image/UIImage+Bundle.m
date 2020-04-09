//
//  UIImage+Bundle.m
//  CoreCode
//
//  Created by 曹连华 on 2020/4/8.
//

#import "UIImage+Bundle.h"

@implementation UIImage (Bundle)

+ (UIImage*)imageWithFileName:(NSString *)name bundleName:(NSString *)bundleName aClass:(Class)aClass {
    return [UIImage imageWithFileName:name bundleName:bundleName extension:@"png" aClass:aClass];
}

+ (UIImage*)imageWithFileName:(NSString *)name
                   bundleName:(NSString *)bundleName
                    extension:(NSString *)extension
                       aClass:(Class)aClass{
    NSArray * components = [name componentsSeparatedByString:@"."];
    if ([components count] >= 2) {
        NSUInteger lastIndex = components.count - 1;
        extension = [components objectAtIndex:lastIndex];
        name = [name substringToIndex:(name.length - (extension.length + 1))];
    }
    NSString * path = @"";
    // 如果为Retina屏幕且存在对应图片，则返回Retina图片，否则查找普通图片
    if ([UIScreen mainScreen].scale == 2.0
        || [UIScreen mainScreen].scale == 3.0) {
        name = [name stringByAppendingString:[NSString stringWithFormat:@"@%dx",(int)[UIScreen mainScreen].scale]];
        NSURL * url = [[NSBundle bundleForClass:aClass] URLForResource:[NSString stringWithFormat:@"%@.bundle",bundleName] withExtension:nil];
        NSBundle * bundle = [NSBundle bundleWithURL:url];
         path = [bundle pathForResource:name ofType:extension];
    }
    
    if (path != nil) {
        return [UIImage imageWithContentsOfFile:path];
    }
    return nil;
    
}

@end
