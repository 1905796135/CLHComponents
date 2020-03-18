//
//  HomeHeaderView.m
//  Home
//
//  Created by 曹连华 on 2019/6/6.
//  Copyright © 2019 曹连华. All rights reserved.
//

#import "CycleImageContentView.h"
#import <CoreCode/CoreCode.h>
#import <Masonry/Masonry.h>

@interface CycleImageContentView()<CycleImagePageViewDelegate,CycleImagePageViewDataSource>

@property (nonatomic, strong) CycleImagePageView *imagePageView;
@property (nonatomic, strong) NSMutableArray<NSString *> *dataArray;

@end

@implementation CycleImageContentView
- (NSMutableArray<NSString *> *)dataArray {
    if(!_dataArray) {
        _dataArray = [NSMutableArray<NSString *> arrayWithArray:[self imageUrlArray]];
    }
    return _dataArray;
}

- (CycleImagePageView *)imagePageView {
    if (!_imagePageView) {
        _imagePageView = [[CycleImagePageView alloc]initWithFrame:CGRectMake(0, 0, UIScreen.width, self.bounds.size.height)];
        _imagePageView.delegate = self;
        _imagePageView.dataSource = self;
        _imagePageView.useCustomaryUrl = YES;
        _imagePageView.disableAutoRunPage = YES;
    }
    return _imagePageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self addSubview:self.imagePageView];
    self.backgroundColor = [UIColor greenColor];
    [self.imagePageView reloadData];
}

- (void)updateDataWithImageUrls:(NSArray<NSString *> *)imageUrls {
    if (imageUrls.count > 0) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:imageUrls];
        [self.imagePageView reloadData];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

#pragma mark - CycleImagePageViewDelegate
/**
 *  点击事件
 *
 *  @param aPageView CycleImagePageView
 *  @param aIndex NSUInteger
 */
- (void)pageView:(CycleImagePageView *)aPageView didSelectedPageAtIndex:(NSUInteger)aIndex {
    if ([self.delegate respondsToSelector:@selector(pageView:didSelectedPageAtIndex:)]) {
        [self.delegate pageView:aPageView didSelectedPageAtIndex:aIndex];
    }
}

/**
 *    功能:从当前页 切换另一页时,此方法会被调用
 *
 *    @param pageView :CycleImagePageView
 *    @param aIndex   :另一页面的索引
 */
- (void)pageView:(CycleImagePageView *)pageView didChangeToIndex:(NSUInteger)aIndex {
    if ([self.delegate respondsToSelector:@selector(pageView:didChangeToIndex:)]) {
        [self.delegate pageView:pageView didChangeToIndex:aIndex];
    }
}

/**
 *  功能:非循环页面，滑动到最后一页继续往后滑动
 */
- (void)pageViewScrollEndOfPage:(CycleImagePageView *)aPageView {
    if ([self.delegate respondsToSelector:@selector(pageViewScrollEndOfPage:)]) {
        [self.delegate pageViewScrollEndOfPage:aPageView];
    }
}

#pragma mark - CycleImagePageViewDataSource
- (NSUInteger)numberOfPagesInPageView:(CycleImagePageView *)aPageView {
    return self.dataArray.count;
}

- (NSString *)pageView:(CycleImagePageView *)aPageView imageUrlStringAtIndex:(NSUInteger)aIndex {
    return [self.dataArray safeObjectAtIndex:aIndex defaultValue:@""];
}

- (NSArray <NSString *>*)imageUrlArray {
    return @[
             @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1559735350095&di=3ddbfcf48f81591b6e31b1f0247a8042&imgtype=0&src=http%3A%2F%2Fac-r.static.booking.cn%2Fimages%2Fhotel%2Fmax1024x768%2F987%2F98767654.jpg",
             @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1559734730876&di=8138a1fd7c173923853efe524211fb50&imgtype=0&src=http%3A%2F%2Fpic31.nipic.com%2F20130728%2F3822951_140613063000_2.jpg",
             @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1343015815,2335192405&fm=26&gp=0.jpg",
             @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1559735350094&di=6da7b32b91cc1079fddfc98315719b6f&imgtype=0&src=http%3A%2F%2Fimg34.ddimg.cn%2Fimgother1%2F98%2F4%2F60038054_2.jpg",
             @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1559735350094&di=558ca6692699a399417916b33980307c&imgtype=0&src=http%3A%2F%2Fhbimg.b0.upaiyun.com%2F458af12108c4da0f1cf4fe8e2713a458898e332b28196-jdjJ3j_fw658"];
}
@end
