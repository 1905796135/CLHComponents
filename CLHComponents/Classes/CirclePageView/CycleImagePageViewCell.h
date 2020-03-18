//
//  CycleImagePageViewCell.h
//  OneStorePublicFramework
//
//  Created by Aimy on 15/2/16.
//  Copyright (c) 2015年 yhd. All rights reserved.
//

#import "LoadingImageView.h"

@interface CycleImagePageViewCell : UICollectionViewCell

@property (nonatomic, readonly) LoadingImageView *imageView;
@property (nonatomic) CGFloat cutOffRatio;

- (void)updateWithImageUrlString:(NSString *)aUrlString homepage:(BOOL)homepage customaryUrl:(BOOL)customaryUrl loadingText:(NSString *)text andClickBlock:(BlockImageViewClickBlock)aBlock;


@end
