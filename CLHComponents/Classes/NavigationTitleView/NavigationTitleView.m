//
//  NavigationTitleView.m
//  Home
//
//  Created by 曹连华 on 2019/6/6.
//  Copyright © 2019 曹连华. All rights reserved.
//

#import "NavigationTitleView.h"

@implementation NavigationTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:.0];
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    if (y <= 0) {
        [self updateAlphaComponent:0];
    } else {
        [self updateAlphaComponent:y/173];
    }
   
}
- (void)scrollViewOffsetY:(CGFloat)offsetY headerViewHeight:(CGFloat)height {
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat scrollSpace = height - statusBarHeight - 44;
    CGFloat alpha = offsetY/scrollSpace;
    [self updateAlphaComponent:alpha];
}

- (void)updateAlphaComponent:(CGFloat)Alpha {
    self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:Alpha];
    self.userInteractionEnabled = Alpha<=0;
}
@end
