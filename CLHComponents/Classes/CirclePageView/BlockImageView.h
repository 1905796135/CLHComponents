//
//  BlockImageView.h
//  OneStoreMain
//
//  Created by Aimy on 14/12/23.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <FLAnimatedImage/FLAnimatedImageView.h>

@class BlockImageView;

typedef void(^BlockImageViewClickBlock)(id sender);

@interface BlockImageView : FLAnimatedImageView

- (void)setBlock:(BlockImageViewClickBlock)block;

@end
