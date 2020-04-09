//
//  UIImage+Bundle.h
//  CoreCode
//
//  Created by 曹连华 on 2020/4/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Bundle)

/**
 * 获取 bundle 中的图片 eg 在 test.bundle 中存现 home@2x.png 图片
 * [UIImage imageWithFileName:@"home" bundleName:@"test" ];
 */
+ (UIImage*)imageWithFileName:(NSString *)name
                   bundleName:(NSString *)bundleName
                       aClass:(Class)aClass;

/**
 * 获取 bundle 中的图片 eg 在 test.bundle 中存现 home@2x.png 和user@2x.jpg 图片
 * [UIImage imageWithFileName:@"home" bundleName:@"test" extension :@"png"];
 * [UIImage imageWithFileName:@"user" bundleName:@"test" extension :@"jpg"];
*/
+ (UIImage*)imageWithFileName:(NSString *)name
                   bundleName:(NSString *)bundleName
                    extension:(NSString *)extension
                       aClass:(Class)aClass;

@end

NS_ASSUME_NONNULL_END
