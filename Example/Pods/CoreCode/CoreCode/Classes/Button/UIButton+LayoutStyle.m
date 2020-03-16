//
//  UIButton+LayoutStyle.m
//  Core
//
//  Created by Jerry on 2017/8/24.
//  Copyright © 2017年 com.core. All rights reserved.
//

#import "UIButton+LayoutStyle.h"
#import "NSObject+Runtime.h"

static NSString *const layoutStyleKey = @"core_button_layout_style";
static NSString *const layoutPaddingKey = @"core_button_layout_padding";
static NSString *const layoutSpacingKey = @"core_button_layout_spacing";

@implementation UIButton (LayoutStyle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self exchangeMethod:@selector(intrinsicContentSize) withMethod:@selector(PB_UIButton_LayoutStyle_intrinsicContentSize)];
        [self exchangeMethod:@selector(sizeThatFits:) withMethod:@selector(PB_UIButton_LayoutStyle_sizeThatFits:)];
    });
}

- (CGSize)PB_UIButton_LayoutStyle_sizeThatFits:(CGSize)size {
    if (self.layoutStyle == ButtonLayoutImageTop || self.layoutStyle == ButtonLayoutImageBottom) {
        CGFloat imageWidth = self.imageView.intrinsicContentSize.width;
        CGFloat titleWidth = self.titleLabel.intrinsicContentSize.width;
        CGFloat imageHeight = self.imageView.intrinsicContentSize.height;
        CGFloat titleHeight = self.titleLabel.intrinsicContentSize.height;

        CGFloat width = MAX(imageWidth, titleWidth) + self.contentEdgeInsets.left + self.contentEdgeInsets.right;
        CGFloat height = imageHeight + titleHeight + self.layoutSpacing + self.contentEdgeInsets.top + self.contentEdgeInsets.bottom;
        return CGSizeMake(width, height);
    }
    CGSize mSize = [self PB_UIButton_LayoutStyle_sizeThatFits:size];
    if (self.layoutSpacing != 0) {
        mSize.width += self.layoutSpacing;
    }
    return mSize;
}

- (CGSize)PB_UIButton_LayoutStyle_intrinsicContentSize {
    if (self.layoutStyle == ButtonLayoutImageTop || self.layoutStyle == ButtonLayoutImageBottom) {
        CGFloat imageWidth = self.imageView.intrinsicContentSize.width;
        CGFloat titleWidth = self.titleLabel.intrinsicContentSize.width;
        CGFloat imageHeight = self.imageView.intrinsicContentSize.height;
        CGFloat titleHeight = self.titleLabel.intrinsicContentSize.height;

        CGFloat width = MAX(imageWidth, titleWidth) + self.contentEdgeInsets.left + self.contentEdgeInsets.right;
        CGFloat height = imageHeight + titleHeight + self.layoutSpacing + self.contentEdgeInsets.top + self.contentEdgeInsets.bottom;
        return CGSizeMake(width, height);
    }

    CGSize mSize = [self PB_UIButton_LayoutStyle_intrinsicContentSize];
    if (self.layoutSpacing != 0) {
        mSize.width += self.layoutSpacing;
    }
    return mSize;
}

#pragma mark - API

- (void)setLayout:(ButtonLayout)layout spacing:(CGFloat)spacing {
    [self setAssociatedObject:@(layout) forKey:layoutStyleKey policy:PBAssociationPolicyRetainNonatomic];
    [self setAssociatedObject:@(spacing) forKey:layoutSpacingKey policy:PBAssociationPolicyRetainNonatomic];
    [self updateButtonInsets];
}

- (void)updateButtonInsets {
    CGFloat padding = self.layoutPadding;
    CGFloat offset = self.layoutSpacing;
    CGFloat halfOffset = offset * 0.5;

    if (padding > 0) {
        self.contentEdgeInsets = UIEdgeInsetsMake(padding, padding, padding, padding);
    }

    CGFloat imageWidth = self.imageView.intrinsicContentSize.width;
    CGFloat titleWidth = self.titleLabel.intrinsicContentSize.width;


    switch (self.layoutStyle) {

        case ButtonLayoutDefault: {
            self.titleEdgeInsets = UIEdgeInsetsMake(0, halfOffset, 0, -halfOffset);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -halfOffset, 0, 0);
            break;
        }

        case ButtonLayoutImageRight: {
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth - halfOffset, 0, imageWidth + halfOffset);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth + halfOffset, 0, -titleWidth - halfOffset);
            break;
        }

        case ButtonLayoutImageTop: {
            CGFloat imageHeight = self.imageView.intrinsicContentSize.height;
            CGFloat titleHeight = self.titleLabel.intrinsicContentSize.height;

            self.titleEdgeInsets = UIEdgeInsetsMake(imageHeight + halfOffset, -imageWidth, 0, 0);
            self.imageEdgeInsets = UIEdgeInsetsMake(-titleHeight * 0.5 - halfOffset, 0, titleHeight * 0.5 + halfOffset, 0);

            break;
        }

        case ButtonLayoutImageBottom: {
            CGFloat imageHeight = self.imageView.intrinsicContentSize.height;
            CGFloat titleHeight = self.titleLabel.intrinsicContentSize.height;

            self.titleEdgeInsets = UIEdgeInsetsMake(-imageHeight * 0.5 - halfOffset, -imageWidth, imageHeight * 0.5 + halfOffset, 0);
            self.imageEdgeInsets = UIEdgeInsetsMake(titleHeight + halfOffset, 0, 0, 0);

            break;
        }

    }

    [self invalidateIntrinsicContentSize];
}

#pragma mark - Getter & Setter

- (ButtonLayout)layoutStyle {
    return [[self getAssociatedObjectForKey:layoutStyleKey] integerValue];
}

- (void)setLayoutStyle:(ButtonLayout)layoutStyle {
    [self setAssociatedObject:@(layoutStyle) forKey:layoutStyleKey policy:PBAssociationPolicyRetainNonatomic];
    [self updateButtonInsets];
}

- (CGFloat)layoutSpacing {
    return [[self getAssociatedObjectForKey:layoutSpacingKey] floatValue];
}

- (void)setLayoutSpacing:(CGFloat)layoutSpacing {
    [self setAssociatedObject:@(layoutSpacing) forKey:layoutSpacingKey policy:PBAssociationPolicyRetainNonatomic];
    [self updateButtonInsets];
}

- (CGFloat)layoutPadding {
    return [[self getAssociatedObjectForKey:layoutPaddingKey] floatValue];
}

- (void)setLayoutPadding:(CGFloat)layoutPadding {
    [self setAssociatedObject:@(layoutPadding) forKey:layoutPaddingKey policy:PBAssociationPolicyRetainNonatomic];
    [self updateButtonInsets];
}

@end
