//
//  UIScreen+ScreenType.m
//  Core
//
//  Created by 韩佚 on 2018/10/24.
//  Copyright © 2018 com.core. All rights reserved.
//

#import "UIScreen+ScreenType.h"

@implementation UIScreen (ScreenType)

static NSInteger __CURRENT_SCREEN_TYPE = -1;
+ (PBScreenType)screenType {
    if (__CURRENT_SCREEN_TYPE < 0) {
        if (CGSizeEqualToSize(CGSizeMake(UIScreen.width, UIScreen.height), screenSize(iphoneX))
            ||CGSizeEqualToSize(CGSizeMake(UIScreen.width, UIScreen.height), screenSize(iphoneXR))) {
            __CURRENT_SCREEN_TYPE = PBScreenTypeFullScreen;
        } else {
            __CURRENT_SCREEN_TYPE = PBScreenTypeNormal;
        }
    }
    return __CURRENT_SCREEN_TYPE;
}

+ (CGFloat)width {
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)height {
    return [UIScreen mainScreen].bounds.size.height;
}

/**
 * 获取屏幕等比例 宽
 */
CGFloat rateWidth(NSUInteger number) {
    return UIScreen.width / screenSize(iphoneX).width * number;
}

/**
 * 获取屏幕等比例 高
 */
CGFloat rateHeight(NSUInteger number) {
    return UIScreen.height / screenSize(iphoneX).height * number;
}

/**
 * 获取屏幕等比例 宽 已 iPhoneType 机型为准
 */
CGFloat rateWidthBy(NSUInteger number ,IPhoneType iPhoneType) {
    return UIScreen.width / screenSize(iPhoneType).width * number;
}

/**
 * 获取屏幕等比例 高 已 iPhoneType 机型为准
 */
CGFloat rateHeightBy(NSUInteger number, IPhoneType iPhoneType) {
    return UIScreen.height / screenSize(iPhoneType).height * number;
}

/**
 * 获取 对应机型的 屏幕宽高
 */
CGSize screenSize(IPhoneType iPhoneType) {
    switch (iPhoneType) {
        case iPhone4:
        case iPhone4S:
            return CGSizeMake(320, 480);
            break;
        case iPhone5:
        case iPhone5S:
        case iPhone5C:
        case iPhoneSE:
            return CGSizeMake(320, 568);
            break;
        case iPhone6:
        case iPhone6S:
        case iPhone7:
        case iPhone8:
            return CGSizeMake(375, 667);
            break;
        case iPhone6P:
        case iPhone6SP:
        case iPhone7P:
        case iPhone8P:
            return CGSizeMake(414, 736);
            break;
        case iphoneX:
        case iphoneXS:
        case iphone11Pro:
            return CGSizeMake(375, 812);
            break;
            
        case iphoneXR:
        case iphone11:
        case iphoneXS_Max:
        case iphone11Pro_Max:
            return CGSizeMake(414, 896);
            break;
        default:
            return [UIScreen mainScreen].bounds.size;
            break;
    }
}
@end
