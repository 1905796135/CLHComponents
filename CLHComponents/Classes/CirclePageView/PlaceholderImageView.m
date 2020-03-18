//
//  PlaceholderImageView.m
//  OneStoreMain
//
//  Created by Aimy on 14/12/23.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "PlaceholderImageView.h"
#import <CoreCode/UIView+create.h>

@interface PlaceholderImageView ()

@property(nonatomic, strong) UIImageView *placeholder;

@end

@implementation PlaceholderImageView

- (void)awakeFromNib {
    [super awakeFromNib];

    [self setupView];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        [self setupView];
    }

    return self;
}

- (void)setupView {
    self.placeholder = [UIImageView autolayoutView];
    [self addSubview:self.placeholder];

    self.placeholder.image = [UIImage imageNamed:@"loadingimg"];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholder attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholder attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.f constant:0.f]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholder attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholder attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.f constant:0.f]];
}

- (void)setImage:(UIImage *)image {
    [super setImage:image];
    self.placeholder.hidden = image || self.animatedImage;
}

- (void)setAnimatedImage:(FLAnimatedImage *)animatedImage {
    [super setAnimatedImage:animatedImage];
    self.placeholder.hidden = animatedImage || self.image;
}

@end
