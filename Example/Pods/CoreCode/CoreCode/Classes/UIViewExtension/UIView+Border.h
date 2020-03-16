//
//  UIView+Border.h
//  Core
//
//  Created by Jerry on 2017/8/16.
//  Copyright © 2017年 com.core. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, BorderOption) {
    BorderOptionNone           = 0,
    BorderOptionTop            = 1 << 0,
    BorderOptionLeft           = 1 << 1,
    BorderOptionBottom         = 1 << 2,
    BorderOptionRight          = 1 << 3,
    BorderOptionAll            = BorderOptionTop | BorderOptionLeft | BorderOptionBottom | BorderOptionRight
};

@interface UIView (Border)

@property (nonatomic, assign) CGFloat borderWidth UI_APPEARANCE_SELECTOR;//default is 1.0
@property (nonatomic, assign) UIEdgeInsets borderInsets UI_APPEARANCE_SELECTOR;//default is UIEdgeInsetsZero
@property (nonatomic, assign) BorderOption borderOption UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong, null_resettable) UIColor *borderColor UI_APPEARANCE_SELECTOR;//default is #e6e6e6

@end

NS_ASSUME_NONNULL_END
