//
//  BlockImageView.m
//  OneStoreMain
//
//  Created by Aimy on 14/12/23.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "BlockImageView.h"
#import <SDWebImage/FLAnimatedImageView+WebCache.h>
@interface BlockImageView ()

@property(nonatomic, strong) id data;

@property(nonatomic, copy) BlockImageViewClickBlock clickBlock;

@end

@implementation BlockImageView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userInteractionEnabled = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPressedImageView:)];
    [self addGestureRecognizer:tap];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = NO;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPressedImageView:)];
        [self addGestureRecognizer:tap];
    }

    return self;
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

@end
