//
//  LoadingImageView.h
//  PBHomePage
//
//  Created by 韩佚 on 2017/2/7.
//  Copyright © 2017年 PBHomePage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FLAnimatedImage/FLAnimatedImageView.h>
#import "BlockImageView.h"

typedef NS_ENUM(NSInteger, LoadingImageViewType) {
    LoadingImageViewTypeBanner
};

@interface LoadingImageView : FLAnimatedImageView

- (void)setBlock:(BlockImageViewClickBlock)block;

- (void)updateLoadingInfoWithBackImage:(NSString *)imageName desc:(NSString *)text;

- (void)updateLoadingInfoWithBackImage:(NSString *)imageName desc:(NSString *)text type:(LoadingImageViewType)type;

@end
