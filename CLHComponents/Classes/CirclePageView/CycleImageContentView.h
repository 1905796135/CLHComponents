//
//  HomeHeaderView.h
//  Home
//
//  Created by 曹连华 on 2019/6/6.
//  Copyright © 2019 曹连华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CycleImagePageView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CycleImageContentViewDelegate <NSObject>

@optional

- (void)pageView:(CycleImagePageView *)aPageView didSelectedPageAtIndex:(NSUInteger )index;
- (void)pageView:(CycleImagePageView *)pageView didChangeToIndex:(NSUInteger )index;
- (void)pageViewScrollEndOfPage:(CycleImagePageView *)aPageView;

@end

@interface CycleImageContentView : UIView

@property (nonatomic, weak) id<CycleImageContentViewDelegate >delegate;

- (void)updateDataWithImageUrls:(NSArray *)imageUrls;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
