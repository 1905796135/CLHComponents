//
//  CoreKeychain.m
//  OneStoreFramework
//
//  Created by Aimy on 14-6-29.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "CoreKeychain.h"
#import "KeychainItemWrapper.h"

//Key Chain
#define PB_KEYCHAIN_IDENTITY @"OneTheStore"
#define PB_KEYCHAIN_DICT_ENCODE_KEY_VALUE @"PB_KEYCHAIN_DICT_ENCODE_KEY_VALUE"

@interface CoreKeychain ()

@property (nonatomic, strong) KeychainItemWrapper *coreItem;
@property (nonatomic, strong) NSArray *commonClasses;

@end

@implementation CoreKeychain

static dispatch_semaphore_t _semaphore;

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static CoreKeychain * __singleton__;
    dispatch_once(&once, ^{
        __singleton__ = [[CoreKeychain alloc] init];
    });
    return __singleton__;
}
- (id)init {
    if (self = [super init]) {
        
        _semaphore = dispatch_semaphore_create(1);
        self.commonClasses = @[[NSNumber class],
                               [NSString class],
                               [NSMutableString class],
                               [NSData class],
                               [NSMutableData class],
                               [NSDate class],
                               [NSValue class]];
        
        [self setup];
    }
    return self;
}

- (void)setup {
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:PB_KEYCHAIN_IDENTITY accessGroup:nil];
	self.coreItem = wrapper;
}

+ (void)setKeychainValue:(id<NSCopying, NSObject>)value forType:(NSString *)type {
    CoreKeychain *keychain = [CoreKeychain sharedInstance];
    
    __block BOOL find = NO;
    [keychain.commonClasses enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Class class = obj;
        if ([value isKindOfClass:class]) {
            find = YES;
            *stop = YES;
        }
        
    }];
    
    if (!find && value) {
        NSLog(@"error set keychain type [%@], value [%@]",type ,value);
        return ;
    }
    
    if (!type || !keychain.coreItem) {
        return ;
    }
    
    
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    
    id data = [keychain.coreItem objectForKey:(__bridge id)kSecValueData];
    NSMutableDictionary *dict = nil;
    if (data && [data isKindOfClass:[NSMutableData class]]) {
        dict = [keychain decodeDictWithData:data];
    }
    
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }
    
    dict[type] = value;
    data = [keychain encodeDict:dict];
    
    if (data && [data isKindOfClass:[NSMutableData class]]) {
        [keychain.coreItem setObject:PB_KEYCHAIN_IDENTITY forKey:(__bridge id)(kSecAttrAccount)];
        [keychain.coreItem setObject:data forKey:(__bridge id)kSecValueData];
    }
    
    dispatch_semaphore_signal(_semaphore);
}

+ (id)getKeychainValueForType:(NSString *)type {
    CoreKeychain *keychain = [CoreKeychain sharedInstance];
    if (!type || !keychain.coreItem) {
        return nil;
    }
    
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    
    id data = [keychain.coreItem objectForKey:(__bridge id)kSecValueData];
    NSMutableDictionary *dict = nil;
    if (data && [data isKindOfClass:[NSMutableData class]]) {
        dict = [keychain decodeDictWithData:data];
    }
    
    id result = dict[type];
    
    dispatch_semaphore_signal(_semaphore);
    
    return result;
}

+ (void)reset {
    CoreKeychain *keychain = [CoreKeychain sharedInstance];
    if (!keychain.coreItem) {
        return ;
    }
    
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    
    id data = [keychain encodeDict:[NSMutableDictionary dictionary]];
    
    if (data && [data isKindOfClass:[NSMutableData class]]) {
        [keychain.coreItem setObject:PB_KEYCHAIN_IDENTITY forKey:(__bridge id)(kSecAttrAccount)];
        [keychain.coreItem setObject:data forKey:(__bridge id)kSecValueData];
    }
    
    dispatch_semaphore_signal(_semaphore);
}

- (NSMutableData *)encodeDict:(NSMutableDictionary *)dict {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dict forKey:PB_KEYCHAIN_DICT_ENCODE_KEY_VALUE];
    [archiver finishEncoding];
    return data;
}

- (NSMutableDictionary *)decodeDictWithData:(NSMutableData *)data {
    NSMutableDictionary *dict = nil;
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    if ([unarchiver containsValueForKey:PB_KEYCHAIN_DICT_ENCODE_KEY_VALUE]) {
        @try {
            dict = [unarchiver decodeObjectForKey:PB_KEYCHAIN_DICT_ENCODE_KEY_VALUE];
        }
        @catch (NSException *exception) {
            NSLog(@"keychain 解析错误");
            [CoreKeychain reset];
        }
    }
    [unarchiver finishDecoding];
    
    return dict;
}

@end
