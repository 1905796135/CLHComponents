//
//  UIDevice+PixelTransformer.h
//  Core
//
//  Created by Jerry on 2017/9/11.
//  Copyright © 2017年 com.core. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define PB_RATIOED_PIXEL(ORIG_PIXEL) [UIDevice pixelWithValue:(ORIG_PIXEL) refrence:PBDeviceRefrenceInch4_7]

typedef enum:NSUInteger {
    PBDeviceRefrenceUnknown = 0,
    PBDeviceRefrenceInch3_5,
    PBDeviceRefrenceInch4_0,
    PBDeviceRefrenceInch4_7,
    PBDeviceRefrenceInch5_5,
    PBDeviceRefrenceInch5_8,
    PBDeviceRefrenceInch6_1or6_5,
    PBDeviceRefrenceInch9_7,
    PBDeviceRefrenceInch9_7Land,
    PBDeviceRefrenceInch10_5,
    PBDeviceRefrenceInch10_5land,
    PBDeviceRefrenceInch12_9,
    PBDeviceRefrenceInch12_9land,
    
} PBDeviceRefrence;

@interface UIDevice (PixelTransformer)

@property(nonatomic, readonly, class) PBDeviceRefrence currentDeviceRefrence;

+ (CGFloat)pixelWithValue:(CGFloat)origPixel
                 refrence:(PBDeviceRefrence)deviceRefrence;

@end

NS_ASSUME_NONNULL_END
