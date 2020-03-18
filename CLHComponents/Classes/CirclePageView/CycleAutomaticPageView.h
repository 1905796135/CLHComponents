//
//  CycleAutomaticPageView.h
//  OneStore
//
//  Created by huang jiming on 13-1-4.
//  Copyright (c) 2013年 OneStore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CirclePageView.h"

typedef enum _CycleAutomaticPageViewModeType {
    KCycleAutomaticPageViewLandscape = 0,      // Portrait
    KCycleAutomaticPageViewPortrait        // Landscape
}
CycleAutomaticPageViewModeType;

@protocol CycleAutomaticPageViewDelegate;

@interface CycleAutomaticPageView : UIView<UIScrollViewDelegate>

@property(nonatomic, weak) id<CycleAutomaticPageViewDelegate> delegate;

@property(nonatomic, assign) NSInteger currentScrollPage;

@property(nonatomic, assign) CycleAutomaticPageViewModeType mode;

@property(nonatomic, assign)BOOL  continuous; //是否连续滚动,首尾想接

@property(nonatomic, strong, readonly) NSMutableArray *contentViewArray;

@property(nonatomic, strong, readonly) UIScrollView *scrollView;

/**
 *  获取PageControl
 */
- (BasePageControl *)getPageControl;

/**
 *	功能:初始化
 *
 *	@param frame CGRect
 *	@param aDelegate id
 *
 */
- (id)initWithFrame:(CGRect)frame
           delegate:(id<CycleAutomaticPageViewDelegate>)aDelegate;

/**
 *  功能:初始化方法
 *  返回值:当前对象
 */
- (id)initWithFrame:(CGRect)frame
           delegate:(id<CycleAutomaticPageViewDelegate>)aDelegate
          sleepTime:(NSInteger)aSleepTime;
/**
 *	功能:设置滑动的PageControl
 */
- (void)setPageControlWithActiveColor:(UIColor *)activeColor
                    withInactiveColor:(UIColor *)inactiveColor;

/**
 *  功能:刷新，会回到第一页
 */
- (void)reloadPageView;
/**
 *	功能:滑动到index页
 *
 *	@param	index :滑动到的目标页，超过或者小于0就不进行任何操作
 */
- (void)scroolToPageIndex:(NSInteger)index;

/**
 *	功能:停止定时滚动
 */
- (void)fireTimer;
/**
 *	功能:开始定时滚动
 */
- (void)startTimer;

@end

@protocol CycleAutomaticPageViewDelegate <NSObject>

@optional

- (void)pageView:(CycleAutomaticPageView *)pageView didTouchOnPage:(NSIndexPath *)indexPath;

- (void)pageView:(CycleAutomaticPageView *)pageView didChangeToIndex:(NSInteger)aIndex;

- (void)pageViewWillBeginDecelerating:(CycleAutomaticPageView *)pageView;

/**
 *	功能:pageView滑动结束,即滑动到超过最后一张
 */
- (void)scrollEndOfPageView:(CycleAutomaticPageView *)pageView;

@required
- (UIView *)pageView:(CycleAutomaticPageView *)pageView pageAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)numberOfPagesInPageView:(CycleAutomaticPageView *)pageView;

@end
