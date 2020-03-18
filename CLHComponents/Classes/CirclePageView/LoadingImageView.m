//
//  LoadingImageView.m
//  PBHomePage
//
//  Created by 韩佚 on 2017/2/7.
//  Copyright © 2017年 PBHomePage. All rights reserved.
//


#import "FLAnimatedImage.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIView+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <CoreCode/UIImage+Size.h>
#import "LoadingImageView.h"

@interface PlaceholderView : UIView

@property(nonatomic, strong) UIImageView *backImgView;

- (void)updateBackImage:(NSString *)imageName desc:(NSString *)text;

@end

@interface LoadingImageView ()

@property(nonatomic, strong) PlaceholderView *placeholderView;

@property(nonatomic, strong) UIImageView *placeholder;

@property(nonatomic, strong) id data;

@property(nonatomic, copy) BlockImageViewClickBlock clickBlock;

@end

@implementation LoadingImageView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userInteractionEnabled = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPressedImageView:)];
    [self addGestureRecognizer:tap];
    [self initUI];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = NO;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPressedImageView:)];
        [self addGestureRecognizer:tap];
        [self initUI];
    }

    return self;
}

- (void)updateLoadingInfoWithBackImage:(NSString *)imageName desc:(NSString *)text {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.placeholderView updateBackImage:imageName desc:text];
    }
}

- (void)updateLoadingInfoWithBackImage:(NSString *)imageName desc:(NSString *)text type:(LoadingImageViewType)type {
    [self updateLoadingInfoWithBackImage:imageName desc:text];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.placeholderView layoutIfNeeded];
    }
}

- (void)initUI {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self addSubview:self.placeholderView];
        
        [self.placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.bottom.trailing.mas_equalTo(0);
        }];
    } else {
        [self addSubview:self.placeholder];

        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholder attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];

        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholder attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.f constant:0.f]];

        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholder attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];

        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholder attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.f constant:0.f]];
    }
}

- (void)onPressedImageView:(BlockImageView *)sender; {
    if (self.clickBlock) {
        self.clickBlock(self);
    }
}

- (void)setBlock:(BlockImageViewClickBlock)block {
    self.clickBlock = block;
    if (self.clickBlock) {
        self.userInteractionEnabled = YES;
    } else {
        self.userInteractionEnabled = NO;
    }
}

- (void)setImage:(UIImage *)image {
    [super setImage:image];
    [self makePlaceholderViewHidden:image || self.animatedImage];
}

- (void)setAnimatedImage:(FLAnimatedImage *)animatedImage {
    [super setAnimatedImage:animatedImage];
    [self makePlaceholderViewHidden:animatedImage || self.image];
}

- (void)makePlaceholderViewHidden:(BOOL)hidden {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.placeholderView.hidden = hidden;
    } else {
        self.placeholder.hidden = hidden;
    }
}

- (PlaceholderView *)placeholderView {
    if (!_placeholderView) {
        _placeholderView = [[PlaceholderView alloc] initWithFrame:CGRectZero];
    }
    return _placeholderView;
}

- (UIImageView *)placeholder {
    if (!_placeholder) {
        _placeholder = [[UIImageView alloc] initWithFrame:CGRectZero];
        _placeholder.translatesAutoresizingMaskIntoConstraints = NO;
        _placeholder.backgroundColor = [UIColor clearColor];
        _placeholder.image = [UIImage imageNamed:@"loadingimg"];
    }
    return _placeholder;
}

@end

@implementation PlaceholderView

static UIImage *__PBLoadingTileImage = nil;
static FLAnimatedImage *__PBLoadingGifImage = nil;

- (void)awakeFromNib {
    [super awakeFromNib];

    [self initUI];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }

    return self;
}

- (void)initUI {
    [self addSubview:self.backImgView];
    [self.backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.trailing.mas_equalTo(0);
    }];

    if (!__PBLoadingTileImage) {
        UIImage *backgroudImage = [UIImage imageNamed:@"homepage_2018_dongnixiangyao"];
        backgroudImage = [backgroudImage shrinkImageForSize:CGSizeMake(90, 90)];
        __PBLoadingTileImage = [backgroudImage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    }

    self.backImgView.image = __PBLoadingTileImage;
}

- (void)updateBackImage:(NSString *)imageName desc:(NSString *)text {
    if (imageName.length > 0) {
        self.backImgView.image = [UIImage imageNamed:imageName];
    } else {
        self.backImgView.image = __PBLoadingTileImage;
    }
}

#pragma mark - Lazy load

- (UIImageView *)backImgView {
    if (!_backImgView) {
        _backImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _backImgView.contentMode = UIViewContentModeScaleToFill;
    }
    return _backImgView;
}

@end
