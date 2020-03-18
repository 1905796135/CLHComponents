//
//  NavigationTitleView.h
//  Home
//
//  Created by 曹连华 on 2019/6/6.
//  Copyright © 2019 曹连华. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NavigationTitleView : UIView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)scrollViewOffsetY:(CGFloat)offsetY headerViewHeight:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
