//
//  CycleImagePageView.m
//  OneStorePublicFramework
//
//  Created by Aimy on 15/2/16.
//  Copyright (c) 2015年 yhd. All rights reserved.
//

#import "CycleImagePageView.h"
#import "CycleImagePageViewCell.h"
#import <CoreCode/CoreConstraintHelper.h>
#import <CoreCode/CoreMacros.h>

@interface CycleImagePageView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property(strong, nonatomic) UICollectionView *contentView;

@property(nonatomic) NSUInteger totalPageCount;
@property(nonatomic) NSUInteger pageCount;

@property(nonatomic) NSInteger currentPage;

@end

@implementation CycleImagePageView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _BasePageView_setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self _BasePageView_setup];
}

- (void)_BasePageView_setup {
    self.homepage = NO;
    self.interval = 5.f;

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.itemSize = self.bounds.size;
    self.contentView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    [self addSubview:self.contentView];
    [self.contentView registerClass:[CycleImagePageViewCell class] forCellWithReuseIdentifier:@"CycleImagePageViewCell"];
    [CoreConstraintHelper setView:self.contentView fullAsSuperview:self];

    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.scrollsToTop = NO;
    self.contentView.pagingEnabled = YES;
    self.contentView.dataSource = self;
    self.contentView.delegate = self;
    self.contentView.bounces = NO;
    self.contentView.showsHorizontalScrollIndicator = NO;
}

- (NSUInteger)totalPageCount {
    if (self.disableCycle) {
        return self.pageCount;
    } else {
        return self.pageCount ? (self.pageCount + 2) : 0;
    }
}

- (void)reloadData {
    [self.timer invalidate];

    self.pageCount = [self.dataSource numberOfPagesInPageView:self];
    self.pageControl.numberOfPages = self.pageCount;

    if (self.pageCount <= 1) {
        self.disableCycle = YES;
        self.contentView.scrollEnabled = NO;
        self.pageControl.hidden = YES;
    } else {
        self.disableCycle = NO;
        self.contentView.scrollEnabled = YES;
        self.pageControl.hidden = NO;
    }

    [self.contentView reloadData];

    if (self.startPageIndex) {
        [self.contentView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.pageControl.currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
    [self runAutoPage];
}

- (void)runAutoPage {
    [self.timer invalidate];
    if (self.totalPageCount && !self.disableAutoRunPage) {
        WEAK_SELF;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(runCycleImagePageView) userInfo:nil repeats:YES];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)runCycleImagePageView {
    if (self.totalPageCount && !self.disableAutoRunPage) {
        NSIndexPath *indexPath = [[self.contentView indexPathsForVisibleItems] firstObject];
        NSInteger nextIndex = indexPath.item + 1;
        if (nextIndex < self.totalPageCount) {
            [self.contentView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];

            if ([self.delegate respondsToSelector:@selector(pageView:didChangeToIndex:)]) {
                [self.delegate pageView:self didChangeToIndex:nextIndex];
            }

            if ([self.delegate respondsToSelector:@selector(pageView:didChangeToIndex:)] && self.disableCycle) {
                if (nextIndex + 1 == self.pageCount) {
                    [self.delegate pageViewScrollEndOfPage:self];
                }
            }
        }
    }
}

- (void)setDisableAutoRunPage:(BOOL)disableAutoRunPage {
    _disableAutoRunPage = disableAutoRunPage;
    [self runAutoPage];
}

- (void)showPageAtIndex:(NSUInteger)aIndex animated:(BOOL)animated {
    if (aIndex < self.pageCount) {
        [self.contentView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:aIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:animated];
        self.pageControl.currentPage = aIndex;
    }
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer invalidate];
    UICollectionView *cv = (UICollectionView *) scrollView;
    NSIndexPath *indexPath = [cv indexPathForItemAtPoint:scrollView.contentOffset];
    if (indexPath.item == 0 && !self.disableCycle) {
        [self.contentView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.pageCount inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];//只是为了少写代码
    [self runAutoPage];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    UICollectionView *cv = (UICollectionView *) scrollView;
    NSIndexPath *indexPath = [cv indexPathForItemAtPoint:scrollView.contentOffset];

    self.pageControl.currentPage = indexPath.item % self.pageCount;
    if ([self.delegate respondsToSelector:@selector(pageView:didChangeToIndex:)]) {
        [self.delegate pageView:self didChangeToIndex:indexPath.item % self.pageCount];
    }

    if ([self.delegate respondsToSelector:@selector(pageView:didChangeToIndex:)] && self.disableCycle) {
        if ((indexPath.item % self.pageCount) + 1 == self.pageCount) {
            [self.delegate pageViewScrollEndOfPage:self];
        }
    }

    if (!self.disableCycle) {
        if (indexPath.item == 0) {
            [self.contentView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.pageCount inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        } else if (indexPath.item + 1 == self.totalPageCount) {
            [self.contentView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        }
    }
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    [collectionView.collectionViewLayout invalidateLayout];
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section; {
    return self.totalPageCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CycleImagePageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CycleImagePageViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithWhite:238.0 / 255.0 alpha:1.0];
    cell.cutOffRatio = self.cutOffRatio;
    WEAK_SELF;
    NSString *imageURLString = [self.dataSource pageView:self imageUrlStringAtIndex:indexPath.item % self.pageCount];
    self.emptyGridForMonkeyTest = (imageURLString.length == 0);

    NSString *loadingText = nil;
    if ([self.dataSource respondsToSelector:@selector(pageView:getLoadingTextAtIndex:)]) {
        loadingText = [self.dataSource pageView:self getLoadingTextAtIndex:indexPath.row];
    }
    [cell updateWithImageUrlString:imageURLString homepage:self.isHomepage customaryUrl:self.useCustomaryUrl loadingText:loadingText andClickBlock:^(BlockImageView *sender) {
        STRONG_SELF;
        if (!self.disableClickEffect) {
            self.layer.opacity = .5f;
            [UIView animateWithDuration:.5f animations:^{
                self.layer.opacity = 1.f;
            }];
        }
        [self.delegate pageView:self didSelectedPageAtIndex:indexPath.item % self.pageCount];
    }];

    return cell;
}

@end

