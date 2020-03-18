//
//  Foundation+safe.h
//  Core
//
//  Created by Jerry on 2017/9/5.
//  Copyright © 2017年 com.core. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<__covariant ObjectType> (safe)

- (nullable ObjectType)safeObjectAtIndex:(NSUInteger)index;

- (nullable ObjectType)safeObjectAtIndex:(NSUInteger)index defaultValue:(nullable ObjectType)defaultValue;

+ (instancetype)safeArrayWithObject:(ObjectType)object;

- (nullable NSArray<ObjectType> *)safeSubarrayWithRange:(NSRange)range;


- (NSUInteger)safeIndexOfObject:(ObjectType)anObject;

- (NSUInteger)safeIndexOfObject:(ObjectType)anObject defaultIndex:(NSUInteger)defaultIndex;

@end

@interface NSMutableArray<ObjectType> (safe)

- (nullable ObjectType)safeObjectAtIndex:(NSUInteger)index;

- (nullable ObjectType)safeObjectAtIndex:(NSUInteger)index defaultValue:(nullable ObjectType)defaultValue;

- (void)safeAddObject:(ObjectType)object;

- (void)safeInsertObject:(ObjectType)object atIndex:(NSUInteger)index;

- (void)safeInsertObjects:(NSArray<ObjectType> *)objects atIndexes:(NSIndexSet *)indexs;

- (void)safeRemoveObjectAtIndex:(NSUInteger)index;

- (void)safeRemoveObjectsInRange:(NSRange)range;

- (nullable ObjectType)safeObjectAtIndexedSubscript:(NSUInteger)index;

- (NSUInteger)safeIndexOfObject:(ObjectType)anObject;

- (NSUInteger)safeIndexOfObject:(ObjectType)anObject defaultIndex:(NSUInteger)defaultIndex;
@end

@interface NSDictionary<__covariant KeyType, __covariant ObjectType> (Safe)

+ (instancetype)safeDictionaryWithObject:(ObjectType)object forKey:(KeyType)key;

- (id)safeObjectForKey:(NSString *)key;

@end

@interface NSMutableDictionary<KeyType, ObjectType> (safe)

- (void)safeSetObject:(ObjectType)object forKey:(KeyType)key;

- (id)safeObjectForKey:(NSString *)key;

@end

@interface NSString (safe)

- (nullable NSString *)safeSubstringFromIndex:(NSUInteger)from;

- (nullable NSString *)safeSubstringToIndex:(NSUInteger)to;

- (nullable NSString *)safeSubstringWithRange:(NSRange)range;

- (NSRange)safeRangeOfString:(nullable NSString *)aString;

- (NSRange)safeRangeOfString:(nullable NSString *)aString options:(NSStringCompareOptions)mask;

- (NSString *)safeStringByAppendingString:(NSString *)aString;

- (instancetype)safeInitWithString:(NSString *)aString;

+ (instancetype)safeStringWithString:(NSString *)string;

@end

@interface NSMutableString (safe)

- (void)safeInsertString:(NSString *)aString atIndex:(NSUInteger)loc;

- (void)safeAppendString:(NSString *)aString;

@end

NS_ASSUME_NONNULL_END
