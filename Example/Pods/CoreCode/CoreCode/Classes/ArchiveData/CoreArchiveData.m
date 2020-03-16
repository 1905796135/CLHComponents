    //
//  CoreArchiveData.m
//  OneStoreFramework
//
//  Created by Aimy on 14-6-29.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "CoreArchiveData.h"
#import "NSFileManager+Utility.h"

@implementation CoreArchiveData

/**
 *  功能:存档（缓存用户数据）
 */
+ (void)archiveDataInDoc:(id<NSCoding>)aData withFileName:(NSString *)aFileName
{
    NSString *documentPath = NSFileManager.appDocPath;
    NSString *filePath = [documentPath stringByAppendingPathComponent:aFileName];
    
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:aData];
    [archiveData writeToFile:filePath atomically:NO];
}

/**
 *  功能:取档 
 */
+ (id<NSCoding>)unarchiveDataInDocWithFileName:(NSString *)aFileName
{
    NSString *documentPath = NSFileManager.appDocPath;
    NSString *filePath = [documentPath stringByAppendingPathComponent:aFileName];
    id o = nil;
    @try {
        o = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    return o;
}

+ (void)removeArchivedDataInDocWithFileName:(NSString*)fileName {
    NSString *documentPath = NSFileManager.appDocPath;
    NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
}

/**
 *  功能:存档到cache
 */
+ (void)archiveDataInCache:(id<NSCoding>)aData withFileName:(NSString *)aFileName
{
    NSString *documentPath = NSFileManager.appCachePath;
    NSString *filePath = [documentPath stringByAppendingPathComponent:aFileName];
    
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:aData];
    [archiveData writeToFile:filePath atomically:NO];
}

/**
 *  功能:取档，从cache中取文件
 */
+ (id<NSCoding>)unarchiveDataInCacheWithFileName:(NSString *)aFileName
{
    NSString *documentPath = NSFileManager.appCachePath;
    NSString *filePath = [documentPath stringByAppendingPathComponent:aFileName];
    id o = nil;
    @try {
        o = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    return o;
}

@end
