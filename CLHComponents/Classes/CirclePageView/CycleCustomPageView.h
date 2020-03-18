//
//  CycleCustomPageView.h
//  OneStoreFramework
//
//  Created by Aimy on 8/25/14.
//  Copyright (c) 2014 OneStore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CirclePageView.h"

typedef NS_ENUM(NSInteger, CycleCustomPageViewScrollDirection) {
    CycleCustomPageViewScrollDirectionHorizontal,
    CycleCustomPageViewScrollDirectionVertical
};

@class CycleCustomPageView,BasePageControl;

@protocol CycleCustomPageViewDataSource <NSObject>

@required
/**
 *  轮播图数量
 */
- (NSUInteger)numberOfPagesInPageView:(CycleCustomPageView *)aPageView;
/**
 *  轮播图view
 *
 *  @param aPageView self
 *  @param aIndex    次序
 *
 */
- (UIView *)pageView:(CycleCustomPageView *)aPageView pageAtIndex:(NSUInteger)aIndex;

@end

@protocol CycleCustomPageViewDelegate <NSObject>

@optional
/**
 *  点击事件
 *
 *  @param aPageView page
 *  @param aIndex index
 *
 */
- (void)pageView:(CycleCustomPageView *)aPageView didSelectedPageAtIndex:(NSUInteger)aIndex;

/**
 *	功能:从当前页 切换另一页时,此方法会被调用
 *
 *	@param pageView :
 *	@param aIndex   :另一页面的索引
 */
- (void)pageView:(CycleCustomPageView *)pageView didChangeToIndex:(NSUInteger)aIndex;

/**
 *  功能:非循环页面，滑动到最后一页继续往后滑动
 */
- (void)pageViewScrollEndOfPage:(CycleCustomPageView *)aPageView;

@end

@interface CycleCustomPageView : UIView

@property (nonatomic, weak) id <CycleCustomPageViewDataSource> dataSource;
@property (nonatomic, weak) id <CycleCustomPageViewDelegate> delegate;

/**
 *  reload之后显示第几个图片
 */
@property (nonatomic) NSInteger startPageIndex;

/**
 *  是否自动轮播
 */
@property (nonatomic) BOOL autoRunPage;
/**
 *  轮播循环间隔
 */
@property (nonatomic) NSTimeInterval interval;
/**
 *  分页控件
 */
@property (nonatomic, weak) BasePageControl *pageControl;

@property (nonatomic, assign) BOOL disableCycle;//是否禁止循环

@property (nonatomic, assign) BOOL disableClickEffect;//是否禁止点击特效

@property (nonatomic, assign) CycleCustomPageViewScrollDirection scrollDirection;

@property (nonatomic) NSInteger currentPage;


/**
 *  显示第n个
 *
 *  @param aIndex index
 *
 */
- (void)showPageAtIndex:(NSUInteger)aIndex;
/**
 *  刷新数据
 */
- (void)reloadData;

- (void)runCycleCustomPageView;
@end
