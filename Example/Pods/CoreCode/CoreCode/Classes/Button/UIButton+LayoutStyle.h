//
//  UIButton+LayoutStyle.h
//  Core
//
//  Created by Jerry on 2017/8/24.
//  Copyright © 2017年 com.core. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ButtonLayout) {
    ButtonLayoutDefault,     //image left and text right
    ButtonLayoutImageRight,  //text left and image right
    ButtonLayoutImageTop,    //image top and text bottom
    ButtonLayoutImageBottom, //image bottom and text top
};

@interface UIButton (LayoutStyle)

//default is ButtonLayoutDefault. It will change titleEdgeInsets and imageEdgeInsets
@property(nonatomic, assign) IBInspectable ButtonLayout layoutStyle;

//spacing bewteen text and image. default is 0. Must be greater than 0. It will change titleEdgeInsets and imageEdgeInsets
@property(nonatomic, assign) IBInspectable CGFloat layoutSpacing;

//default is 0. It will change contentEdgeInsets.
@property(nonatomic, assign) IBInspectable CGFloat layoutPadding;

//force the button to recalculate its titleEdgeInsets, imageEdgeInsets and contentEdgeInsets
- (void)updateButtonInsets;

- (void)setLayout:(ButtonLayout)layout spacing:(CGFloat)spacing;

@end

NS_ASSUME_NONNULL_END
