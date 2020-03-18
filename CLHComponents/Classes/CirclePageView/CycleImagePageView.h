//
//  CycleImagePageView.h
//  OneStorePublicFramework
//
//  Created by Aimy on 15/2/16.
//  Copyright (c) 2015年 yhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePageControl.h"

@class CycleImagePageView, BasePageControl;

@protocol CycleImagePageViewDataSource <NSObject>

@required
/**
 *  轮播图数量
 *
 *  @param aPageView CycleImagePageView
 *
 *  @return NSUInteger
 */
- (NSUInteger)numberOfPagesInPageView:(CycleImagePageView *)aPageView;

/**
 *  轮播图view
 *
 *  @param aPageView self
 *  @param aIndex    次序
 *
 *  @return NSString 图片URL
 */
- (NSString *)pageView:(CycleImagePageView *)aPageView imageUrlStringAtIndex:(NSUInteger)aIndex;

@optional

/**
 *  轮播图图片加载中的提示信息
 *
 *  @param aPageView self
 *  @param aIndex    次序
 *
 *  @return NSString
 */
- (NSString *)pageView:(CycleImagePageView *)aPageView getLoadingTextAtIndex:(NSUInteger)aIndex;

@end

@protocol CycleImagePageViewDelegate <NSObject>

@optional
/**
 *  点击事件
 *
 *  @param aPageView CycleImagePageView
 *  @param aIndex NSUInteger
 */
- (void)pageView:(CycleImagePageView *)aPageView didSelectedPageAtIndex:(NSUInteger)aIndex;

/**
 *	功能:从当前页 切换另一页时,此方法会被调用
 *
 *	@param pageView :CycleImagePageView
 *	@param aIndex   :另一页面的索引
 */
- (void)pageView:(CycleImagePageView *)pageView didChangeToIndex:(NSUInteger)aIndex;

/**
 *  功能:非循环页面，滑动到最后一页继续往后滑动
 */
- (void)pageViewScrollEndOfPage:(CycleImagePageView *)aPageView;

@end

@interface CycleImagePageView : UIView

@property(nonatomic, weak) id <CycleImagePageViewDataSource> dataSource;
@property(nonatomic, weak) id <CycleImagePageViewDelegate> delegate;

@property(nonatomic, strong) NSTimer *timer;

/**
 *  reload之后显示第几个图片
 */
@property(nonatomic) NSInteger startPageIndex;

/**
 *  轮播循环间隔
 */
@property(nonatomic) NSTimeInterval interval;
/**
 *  分页控件
 */
@property(nonatomic, strong) BasePageControl *pageControl;

@property(nonatomic) BOOL disableAutoRunPage;//是否禁止自动轮播

@property(nonatomic) BOOL disableCycle;//是否禁止循环

@property(nonatomic) BOOL disableClickEffect;//是否禁止点击特效

@property(nonatomic) BOOL emptyGridForMonkeyTest;//检测是否有空窗

@property(nonatomic, assign, getter=isHomepage) BOOL homepage;

@property(nonatomic, assign) BOOL useCustomaryUrl;//使用原生url 不拼接宽高

@property(nonatomic) CGFloat cutOffRatio;//图片截取比例（从上往下截取）

- (void)showPageAtIndex:(NSUInteger)aIndex animated:(BOOL)animated;

/**
 *  刷新数据
 */
- (void)reloadData;

@end
