//
//  UIDevice+PixelTransformer.m
//  Core
//
//  Created by Jerry on 2017/9/11.
//  Copyright © 2017年 com.core. All rights reserved.
//

#import "UIDevice+PixelTransformer.h"

@implementation UIDevice (PixelTransformer)

static NSInteger __CURRENT_DEVICE_REFRENCE = -1;

+ (CGFloat)pixelWithValue:(CGFloat)origPixel
                 refrence:(PBDeviceRefrence)deviceRefrence {
    CGFloat currentRatio = [[UIDevice multiplicative][@(UIDevice.currentDeviceRefrence)] floatValue];
    CGFloat refrenceRatio = [[UIDevice multiplicative][@(deviceRefrence)] floatValue];
    return ceil(origPixel * currentRatio / MAX(refrenceRatio, 1));
}

+ (PBDeviceRefrence)currentDeviceRefrence {
    if (__CURRENT_DEVICE_REFRENCE < 0) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        if (CGSizeEqualToSize(size, CGSizeMake(320, 480))) {
            __CURRENT_DEVICE_REFRENCE = PBDeviceRefrenceInch3_5;
        } else if (CGSizeEqualToSize(size, CGSizeMake(320, 568))) {
            __CURRENT_DEVICE_REFRENCE = PBDeviceRefrenceInch4_0;
        } else if (CGSizeEqualToSize(size, CGSizeMake(375, 667))) {
            __CURRENT_DEVICE_REFRENCE = PBDeviceRefrenceInch4_7;
        } else if (CGSizeEqualToSize(size, CGSizeMake(375, 812))) {
            __CURRENT_DEVICE_REFRENCE = PBDeviceRefrenceInch5_8;
        } else if (CGSizeEqualToSize(size, CGSizeMake(414, 736))) {
            __CURRENT_DEVICE_REFRENCE = PBDeviceRefrenceInch5_5;
        } else if (CGSizeEqualToSize(size, CGSizeMake(414, 896))) {
            __CURRENT_DEVICE_REFRENCE = PBDeviceRefrenceInch6_1or6_5;
        } else if (CGSizeEqualToSize(size, CGSizeMake(768, 1024))) {
            __CURRENT_DEVICE_REFRENCE = PBDeviceRefrenceInch9_7;
        } else if (CGSizeEqualToSize(size, CGSizeMake(1024, 768))) {
            __CURRENT_DEVICE_REFRENCE = PBDeviceRefrenceInch9_7Land;
        } else if (CGSizeEqualToSize(size, CGSizeMake(834, 1112))) {
            __CURRENT_DEVICE_REFRENCE = PBDeviceRefrenceInch10_5;
        } else if (CGSizeEqualToSize(size, CGSizeMake(1112, 834))) {
            __CURRENT_DEVICE_REFRENCE = PBDeviceRefrenceInch10_5land;
        } else if (CGSizeEqualToSize(size, CGSizeMake(1024, 1366))) {
            __CURRENT_DEVICE_REFRENCE = PBDeviceRefrenceInch12_9;
        } else if (CGSizeEqualToSize(size, CGSizeMake(1366, 1024))) {
            __CURRENT_DEVICE_REFRENCE = PBDeviceRefrenceInch12_9land;
        } else {
            __CURRENT_DEVICE_REFRENCE = PBDeviceRefrenceUnknown;
        }
    }
    return __CURRENT_DEVICE_REFRENCE;
}

+ (NSDictionary<NSNumber *, NSNumber *> *)multiplicative {
    return @{@(PBDeviceRefrenceUnknown): @1,
            @(PBDeviceRefrenceInch3_5): @320,
            @(PBDeviceRefrenceInch4_0): @320,
            @(PBDeviceRefrenceInch4_7): @375,
            @(PBDeviceRefrenceInch5_5): @414,
            @(PBDeviceRefrenceInch5_8): @375,
            @(PBDeviceRefrenceInch6_1or6_5): @414,
            @(PBDeviceRefrenceInch9_7): @768,
            @(PBDeviceRefrenceInch9_7Land): @1024,
            @(PBDeviceRefrenceInch10_5): @834,
             @(PBDeviceRefrenceInch10_5land): @1112,
            @(PBDeviceRefrenceInch12_9): @1024,
            @(PBDeviceRefrenceInch12_9land): @1366};
}

@end
