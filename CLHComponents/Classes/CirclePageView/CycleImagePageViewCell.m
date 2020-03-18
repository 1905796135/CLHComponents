//
//  CycleImagePageViewCell.m
//  OneStorePublicFramework
//
//  Created by Aimy on 15/2/16.
//  Copyright (c) 2015年 yhd. All rights reserved.
//

#import "CycleImagePageViewCell.h"
#import <CoreCode/ConvertImageString.h>
#import <CoreCode/CoreConstraintHelper.h>
#import <CoreCode/UIView+create.h>
#import "PlaceholderImageView.h"
#import "UIImageView+WebCache.h"
#import <CoreCode/CoreMacros.h>

@interface CycleImagePageViewCell ()

@property (nonatomic, strong) LoadingImageView *imageView;
@property (nonatomic, strong) PlaceholderImageView *normalImgView;

@end

@implementation CycleImagePageViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [LoadingImageView autolayoutView];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.contentView addSubview:self.imageView];
        [CoreConstraintHelper setView:self.imageView fullAsSuperview:self.contentView];
     
        self.normalImgView = [PlaceholderImageView autolayoutView];
        [self.normalImgView setContentMode:UIViewContentModeScaleAspectFill];
        [self.contentView addSubview:self.normalImgView];
        [CoreConstraintHelper setView:self.normalImgView fullAsSuperview:self.contentView];
        self.normalImgView.hidden = YES;
        
    }
    return self;
}

- (void)updateWithImageUrlString:(NSString *)aUrlString homepage:(BOOL)homepage customaryUrl:(BOOL)customaryUrl loadingText:(NSString *)text andClickBlock:(BlockImageViewClickBlock)aBlock {
    if (homepage) {
        self.imageView.hidden = NO;
        self.normalImgView.hidden = YES;
        
        [self.imageView setBlock:^(LoadingImageView *sender) {
            aBlock(sender);
        }];
        
        [self.imageView updateLoadingInfoWithBackImage:@"homepage_2018_banner" desc:text type:LoadingImageViewTypeBanner];
        
        if (aUrlString) {
            if (self.contentView.bounds.size.width && self.contentView.bounds.size.height) {
                NSString *tempString = [ConvertImageString getPictureURLWithWidth:self.contentView.bounds.size.width height:self.contentView.bounds.size.height path:aUrlString];
                WEAK_SELF;
                [self.imageView sd_setImageWithURL:[NSURL URLWithString:tempString] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    STRONG_SELF;
                    if (error) {
                        [self.imageView sd_setImageWithURL:[NSURL URLWithString:aUrlString]];
                    }
                }];
            } else {
                self.imageView.image = nil;
            }
        }
    } else {
        self.imageView.hidden = YES;
        self.normalImgView.hidden = NO;
        if (self.cutOffRatio&&self.cutOffRatio>0) {
            self.normalImgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            self.normalImgView.clipsToBounds = YES;
            self.normalImgView.layer.contentsRect = CGRectMake(0, 0, 1,self.cutOffRatio);
        }else{
            self.normalImgView.autoresizingMask = UIViewAutoresizingNone;
            self.normalImgView.clipsToBounds = NO;
            self.normalImgView.layer.contentsRect = CGRectMake(0, 0,1,1);
        }
        [self.normalImgView setBlock:^(BlockImageView *sender) {
            aBlock(sender);
        }];
        
        if (aUrlString) {
            if (self.contentView.bounds.size.width && self.contentView.bounds.size.height) {
                NSString *tempString;
                if (customaryUrl) {
                    //直接使用接口url 不拼接宽高
                    tempString = aUrlString;
                }else{
                    //tempString = [ConvertImageString getPictureURLWithWidth:self.contentView.bounds.size.width height:self.contentView.bounds.size.height path:aUrlString];
                }
                WEAK_SELF;
                [self.normalImgView sd_setImageWithURL:[NSURL URLWithString:tempString] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    STRONG_SELF;
                    if (error) {
                        [self.normalImgView sd_setImageWithURL:[NSURL URLWithString:aUrlString]];
                    }
                }];
            } else {
                self.normalImgView.image = nil;
            }
        }
        
    }
}

@end
