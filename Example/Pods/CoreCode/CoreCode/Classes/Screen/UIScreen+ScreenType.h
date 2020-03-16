//
//  UIScreen+ScreenType.h
//  Core
//
//  Created by 韩佚 on 2018/10/24.
//  Copyright © 2018 com.core. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum: NSUInteger {
    PBScreenTypeNormal = 0, // 普通屏
    PBScreenTypeFullScreen // 刘海全面屏
} PBScreenType;

typedef enum NSUInteger{
    iPhone4 = 0,    //  320x480
    iPhone4S,       //  320x480
    iPhone5,        //  320x568
    iPhone5S,       //  320x568
    iPhone5C,       //  320x568
    iPhoneSE,       //  320x568
    iPhone6,        //  375x667
    iPhone6P,       //  414x736
    iPhone6S,       //  375x667
    iPhone6SP,      //  414x736
    iPhone7,        //  375x667
    iPhone7P,       //  414x736
    iPhone8,        //  375x667
    iPhone8P,       //  414x736
    iphoneX,        //  375x812
    iphoneXS,       //  375x812
    iphoneXS_Max,   //  414x896
    iphoneXR,       //  414x896
    iphone11,       //  414x896
    iphone11Pro,    //  375x812
    iphone11Pro_Max,//  414x896
    
}IPhoneType;

@interface UIScreen (ScreenType)

/**
 * 屏幕类型
 */
@property (nonatomic, readonly, class) PBScreenType screenType;

/**
 * 屏幕宽
 */
@property (nonatomic, readonly, class) CGFloat width;

/**
 * 屏幕高
 */
@property (nonatomic, readonly, class) CGFloat height;

/**
 * 获取屏幕等比例 宽 以 iphoneX 机型为准
 */
FOUNDATION_EXPORT CGFloat rateWidth(NSUInteger number);

/**
 * 获取屏幕等比例 高 以 iphoneX 机型为准
 */
FOUNDATION_EXPORT CGFloat rateHeight(NSUInteger number);

/**
 * 获取屏幕等比例 宽 以 iPhoneType 机型为准
 */
FOUNDATION_EXPORT CGFloat rateWidthBy(NSUInteger number ,IPhoneType iPhoneType);

/**
 * 获取屏幕等比例 高 以 iPhoneType 机型为准
 */
FOUNDATION_EXPORT CGFloat rateHeightBy(NSUInteger number, IPhoneType iPhoneType);

/**
 * 获取 对应机型的 屏幕宽高
 */
FOUNDATION_EXPORT CGSize screenSize(IPhoneType iPhoneType);

@end

NS_ASSUME_NONNULL_END
