//
//  NSObject+Runtime.h
//  Core
//
//  Created by Jerry on 16/8/25.
//  Copyright © 2016年 core. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

typedef OBJC_ENUM(uintptr_t, PBAssociationPolicy) {
    PBAssociationPolicyAssign = OBJC_ASSOCIATION_ASSIGN,
    PBAssociationPolicyRetainNonatomic = OBJC_ASSOCIATION_RETAIN_NONATOMIC,
    PBAssociationPolicyCopyNonatomic = OBJC_ASSOCIATION_COPY_NONATOMIC,
    PBAssociationPolicyRetain = OBJC_ASSOCIATION_RETAIN,
    PBAssociationPolicyCopy = OBJC_ASSOCIATION_COPY,
    PBAssociationPolicyWeak = 91234
};

typedef NS_ENUM(NSUInteger, PBObjectType) {
    PBObjectTypeUnknown,
    PBObjectTypeId,
    PBObjectTypeClass,
    PBObjectTypeRawNumber,
    PBObjectTypeStruct,
};

typedef NS_ENUM(NSUInteger, PBObjectStoredType) {
    PBObjectStoredTypeRetain,
    PBObjectStoredTypeAssign,
    PBObjectStoredTypeWeak,
    PBObjectStoredTypeCopy
};

@interface PBObjectTypeWrapper : NSObject

@property(nonatomic, assign, readonly) PBObjectType rootType;

@property(nonatomic, copy, readonly, nullable) NSString *objTypeName;//e.g., int, float, bool, NSObject, UIView, CGPoint
@property(nonatomic, assign, readonly) NSInteger structElementsCount;//e.g., for CGPoint, structElementsCount == 2. for CGRect, 4

@property(nonatomic, copy, readonly, nullable) NSString *propertyName;//name of the property
@property(nonatomic, assign, readonly) PBObjectStoredType storedType;
@property(nonatomic, assign, readonly) BOOL isReadOnly;

- (instancetype)initWithObjectCProperty:(objc_property_t)property;

@end

@interface NSObject (Runtime)

@property(nonatomic, strong, readonly) NSSet *associatedObjectNames;
@property(nonatomic, strong, readonly) NSArray<NSString *> *properties;
@property(nonatomic, strong, readonly) NSArray<NSString *> *readWriteNonWeakProperties;
@property(nonatomic, strong, readonly) NSDictionary<NSString *, PBObjectTypeWrapper *> *propertyInfos;//KEY:propertyName, Value:propertyType

- (nullable id)getAssociatedObjectForKey:(NSString *)key;

- (void)setAssociatedObject:(nullable id)object forKey:(NSString *)key policy:(PBAssociationPolicy)policy;

- (void)removeAssociatedObjectForKey:(NSString *)key;

- (void)removeAllAssociatedObjects;

+ (BOOL)overrideMethod:(SEL)origSel withMethod:(SEL)altSel;

+ (BOOL)overrideClassMethod:(SEL)origSel withClassMethod:(SEL)altSel;

+ (BOOL)exchangeMethod:(SEL)origSel withMethod:(SEL)altSel;

+ (BOOL)exchangeClassMethod:(SEL)origSel withClassMethod:(SEL)altSel;

@end

NS_ASSUME_NONNULL_END
