//
//  UIView+Border.h
//  PBKit
//
//  Created by Jerry on 16/8/31.
//  Copyright © 2016年 core. All rights reserved.
//

#import "UIView+Border.h"
#import "NSObject+Runtime.h"
#import "UIView+Frame.h"

static NSString *BorderViewsKey = @"core_borderViews";
static NSString *BorderColorKey = @"core_borderColor";
static NSString *BorderWidthKey = @"core_borderWidth";
static NSString *BorderOptionKey = @"core_borderOption";
static NSString *BorderInsetsKey = @"core_borderInsets";

static NSString *ButtonBorderColorKey = @"core_button_borderColor";

@interface UIView()

@property (nonatomic, strong) NSArray *borderViews;

@end

@implementation UIView (Border)

#pragma mark - Getter & Setter
- (void)setBorderViews:(NSArray *)borderViews {
    if (borderViews.count == 0) {
        [self removeAssociatedObjectForKey:BorderViewsKey];
    } else if (borderViews.count == 4) {
        [self setAssociatedObject:borderViews forKey:BorderViewsKey policy:PBAssociationPolicyRetainNonatomic];
    }
}

- (NSArray*)borderViews {
    NSArray *obj = [self getAssociatedObjectForKey:BorderViewsKey];
    return obj;
}

- (void)setBorderColor:(UIColor*)borderColor {
    if (![self.borderColor isEqual:borderColor]) {
        [self setAssociatedObject:borderColor forKey:BorderColorKey policy:PBAssociationPolicyRetainNonatomic];
        [self __applyBorderColor];
    }
}

- (UIColor*)borderColor {
    UIColor *obj = [self getAssociatedObjectForKey:BorderColorKey];
    if (!obj) {
        obj = [UIColor colorWithWhite:0.898 alpha:1.0];
    }
    return obj;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    if (self.borderWidth != borderWidth) {
        [self setAssociatedObject:@(borderWidth) forKey:BorderWidthKey policy:PBAssociationPolicyRetainNonatomic];
        [self __applyBorderFrame];
    }
}

- (CGFloat)borderWidth {
    NSNumber *obj = [self getAssociatedObjectForKey:BorderWidthKey];
    if (obj != nil) {
        return [obj floatValue];
    }
    return 1.0;
}

- (void)setBorderOption:(BorderOption)borderOption {
    if (self.borderOption != borderOption) {
        [self setAssociatedObject:@(borderOption) forKey:BorderOptionKey policy:PBAssociationPolicyRetainNonatomic];
        [self __makeBorder];
    }
}

- (BorderOption)borderOption {
    NSNumber *obj = [self getAssociatedObjectForKey:BorderOptionKey];
    if (obj != nil) {
        return [obj unsignedIntegerValue];
    }
    return BorderOptionNone;
}

- (void)setBorderInsets:(UIEdgeInsets)borderInsets {
    if (!UIEdgeInsetsEqualToEdgeInsets(self.borderInsets, borderInsets)) {
        [self setAssociatedObject:[NSValue valueWithUIEdgeInsets:borderInsets] forKey:BorderInsetsKey policy:PBAssociationPolicyRetainNonatomic];
        [self __applyBorderFrame];
    }
}

- (UIEdgeInsets)borderInsets {
    NSValue *obj = [self getAssociatedObjectForKey:BorderInsetsKey];
    if (obj) {
        return [obj UIEdgeInsetsValue];
    }
    return UIEdgeInsetsZero;
}

#pragma mark - Private
- (BorderOption)__optionForIndex: (NSInteger)index {
    switch (index) {
        case 0:
            return BorderOptionTop;
            break;
        case 1:
            return BorderOptionLeft;
            break;
        case 2:
            return BorderOptionBottom;
            break;
        case 3:
            return BorderOptionRight;
            break;
        default:
            return BorderOptionNone;
            break;
    }
}

- (void)__makeBorder {
    BorderOption option = self.borderOption;
    if ([self __useLayerBorder] || self.borderOption == BorderOptionNone) {
        for (id subView in self.borderViews) {
            if ([subView isKindOfClass:[UIView class]]) {
                [subView removeFromSuperview];
            }
        }
        self.borderViews = nil;
    } else {
        
        NSArray *mBorderViews = self.borderViews;
        if (mBorderViews.count != 4) {
            mBorderViews = @[[NSNull null], [NSNull null], [NSNull null], [NSNull null]];
        }
        
        NSMutableArray *borderViews = [NSMutableArray arrayWithArray:mBorderViews];
        
        for (int i = 0; i < 4; i++) {
            BorderOption compareOption = [self __optionForIndex:i];
            if (option & compareOption) {
                if (borderViews[i] == [NSNull null]) {
                    UIView *lineView = [[UIView alloc] init];
                    
                    if (i == 0) {
                        lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                    } else if(i == 1) {
                        lineView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                    } else if(i == 2) {
                        lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
                    } else {
                        lineView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
                    }
                    
                    [self addSubview:lineView];
                    borderViews[i] = lineView;
                }
            } else {
                if (borderViews[i] != [NSNull null]) {
                    [borderViews[i] removeFromSuperview];
                    borderViews[i] = [NSNull null];
                }
            }
        }
        
        self.borderViews = borderViews;
    }
    
    [self __applyBorderColor];
    [self __applyBorderFrame];
}

- (void)__applyBorderColor {
    if ([self __useLayerBorder]) {
        self.layer.borderColor = self.borderColor.CGColor;
    } else {
        self.layer.borderColor = nil;
    }
    
    for (id obj in self.borderViews) {
        if (obj == [NSNull null]) {
            continue;
        }
        
        UIView *borderView = obj;
        borderView.backgroundColor = self.borderColor;
    }
}

- (void)__applyBorderFrame {
    
    CGFloat lineWidth = self.borderWidth / [UIScreen mainScreen].scale;
    
    if ([self __useLayerBorder]) {
        self.layer.borderWidth = lineWidth;
        return;
    } else {
        self.layer.borderWidth = 0;
    }
    
    NSArray *mBorderViews = self.borderViews;
    if (mBorderViews.count != 4) {
        return;
    }
    
    UIEdgeInsets insets = self.borderInsets;
    
    if (!self.width) {
        self.width = 100;
    }
    
    if (!self.height) {
        self.height = 44.0;
    }
    
    for (int i = 0; i < 4; i++) {
        id obj = mBorderViews[i];
        if (obj == [NSNull null]) {
            continue;
        }
        UIView *borderView = obj;
        if (i == 0) {
            borderView.frame = CGRectMake(insets.left, insets.top, self.width - insets.left - insets.right, lineWidth);
        } else if(i == 1) {
            borderView.frame = CGRectMake(insets.left, insets.top, lineWidth, self.height - insets.top - insets.bottom);
        } else if(i == 2) {
            borderView.frame = CGRectMake(insets.left, self.height - lineWidth - insets.bottom, self.width - insets.left - insets.right, lineWidth);
        } else {
            borderView.frame = CGRectMake(self.width - lineWidth - insets.right, insets.top, lineWidth, self.height - insets.top - insets.bottom);
        }
    }
}

- (BOOL)__useLayerBorder {
    return self.borderOption == BorderOptionAll && UIEdgeInsetsEqualToEdgeInsets(self.borderInsets, UIEdgeInsetsZero);
}

@end
