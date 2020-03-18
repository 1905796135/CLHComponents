//
//  ConvertImageString.h
//  OneStoreFramework
//
//  Created by zhangbin on 14-9-28.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConvertImageString : NSObject

/**
 * 获取指定宽高的图片地址,例：//img13.360buyimg.com/n1/s377x377_jfs/t6058/194/9754653273/274965/39a6aaac/5996a34cNca2b084d.jpg!cc_377x377
 *
 * @param aSize    图片尺寸
 * @param path     jfs中图片的相对路径，形如：jfs/t4825/335/2417169723/58212/e5f00cc3/58ff11f7Ncc9fe1ef.jpg
 */
+ (NSString *)getPictureURLWithSize:(CGSize)aSize path:(NSString *)path;
+ (NSString *)getPictureURLWithWidth:(NSInteger)width height:(NSInteger)height path:(NSString *)path;

/**
 * 获取指定宽高的图片
 * URL 组成一般是 scheme://host/业务/s30x30_path
 
 * @param aSize 图片尺寸
 * @param path 业务后面的path jfs/t4825/335/2417169723/58212/e5f00cc3/58ff11f7Ncc9fe1ef.jpg
 * @param host host，如  https://m.360buyimg.com/mobilecms/s30x30_  或者 https://m.360buyimg.com/mobilecms/
 */
+ (NSString *)getPictureURLWithSize:(CGSize)aSize path:(NSString *)path host:(NSString *)host;
+ (NSString *)getPictureURLWithWidth:(NSInteger)width height:(NSInteger)height path:(NSString *)path host:(NSString *)host;

/**
 * 获取指定宽高的图片地址,例：//img13.360buyimg.com/n1/s377x377_jfs/t6058/194/9754653273/274965/39a6aaac/5996a34cNca2b084d.jpg!cc_377x377
 *
 * @param aSize 图片尺寸
 * @param path  jfs中图片的相对路径，形如：jfs/t4825/335/2417169723/58212/e5f00cc3/58ff11f7Ncc9fe1ef.jpg
 * @param host host，如  https://m.360buyimg.com/mobilecms/s30x30_  或者 https://m.360buyimg.com/mobilecms/
 * @param highPrecision 是否强制开启高清晰度模式
 */
+ (NSString *)getPictureURLWithSize:(CGSize)aSize path:(NSString *)path host:(NSString *)host highPrecision:(BOOL)highPrecision;
+ (NSString *)getPictureURLWithWidth:(NSInteger)width height:(NSInteger)height path:(NSString *)path host:(NSString *)host highPrecision:(BOOL)highPrecision;

@end
