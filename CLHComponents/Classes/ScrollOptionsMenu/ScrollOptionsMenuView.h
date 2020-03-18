//
//  ScrollOptionsMenuView.h
//  HWHouseEdit
//
//  Created by 曹连华 on 2019/4/30.
//  Copyright © 2019 曹连华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionsModel : NSObject

@property (nonatomic, strong) NSString * _Nonnull title;
@property (nonatomic, assign) BOOL isSelected;

@end

@interface OptionsCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIButton * _Nonnull titleBtn;

- (void)updateWithModel:(OptionsModel *_Nullable)model;

- (void)updateTitleColor:(UIColor *_Nullable)normalColor
              normalFont:(UIFont *_Nullable)normalFont
           selectedColor:(UIColor *_Nullable)selectedColor
            selectedFont:(UIFont *_Nullable)selectedFont;

@end

NS_ASSUME_NONNULL_BEGIN
@protocol ScrollOptionsMenuDelegate <NSObject>

- (void)didSelectedItemWithIndex:(NSInteger)index;

@end

@interface ScrollOptionsMenuView : UIView

@property (nonatomic, weak) id <ScrollOptionsMenuDelegate>delegate;
@property (nonatomic, strong, readonly) UIImageView *highlightLine;


- (void)updateSelectedIndex:(NSInteger)selectedIndex;

- (void)updateDataArray:(NSArray<NSString *>*)dataArray;

/**设置 item titleColor 和 titleFont
 * normalColor 未选中时 的 color
 * selectedColor 选中时的 color
 * titleFont item 文描 字体
 */
- (void)updateTitleColor:(UIColor *_Nullable)normalColor
              normalFont:(UIFont *_Nullable)normalFont
           selectedColor:(UIColor *_Nullable)selectedColor
            selectedFont:(UIFont *_Nullable)selectedFont;

/**
 * 设置选中线 的size
 */
- (void)setLineSize:(CGSize)lineSize;

/**
 * item  的间距
 */
- (void)setMinimumInteritemSpacing:(CGFloat)minimumInteritemSpacing;

/**
 * 设置 选中线 位移 动画时间
 */
- (void)setAnimateDuration:(CGFloat)duration;

- (void)setContentEdgeInsets:(UIEdgeInsets)edgeInsets;

- (void)willBeginDragging:(UIScrollView *)scrollView;
- (void)didScroll:(UIScrollView *)scrollView;
- (void)didEndDecelerating:(UIScrollView *)scrollView;
@end

NS_ASSUME_NONNULL_END
