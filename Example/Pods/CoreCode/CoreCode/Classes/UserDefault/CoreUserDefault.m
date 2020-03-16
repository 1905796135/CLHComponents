//
//  CoreUserDefault.m
//  OneStoreFramework
//
//  Created by Aimy on 14-6-29.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "CoreUserDefault.h"

@implementation CoreUserDefault

+ (void)setValue:(id)anObject forKey:(NSString *)aKey
{
    if (aKey && [aKey isKindOfClass:[NSString class]]) {
        [[NSUserDefaults standardUserDefaults] setObject:anObject forKey:aKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (id)getValueForKey:(NSString *)aKey
{
    if ( ! aKey || ! [aKey isKindOfClass:[NSString class]]) {
        return nil;
    } else {
        return [[NSUserDefaults standardUserDefaults] objectForKey:aKey];
    }
}

+ (void)setBool:(BOOL)value forKey:(NSString *)aKey
{
    if (aKey && [aKey isKindOfClass:[NSString class]]) {
        [[NSUserDefaults standardUserDefaults] setBool:value forKey:aKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (BOOL)getBoolValueForKey:(NSString *)aKey
{
    if ( !aKey || ![aKey isKindOfClass:[NSString class]]) {
        return NO;
    } else {
        return [[NSUserDefaults standardUserDefaults] boolForKey:aKey];
    }
}

@end
