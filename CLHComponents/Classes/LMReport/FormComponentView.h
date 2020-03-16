//
//  FormComponentView.h
//  HWReportForm
//
//  Created by 曹连华 on 2019/10/8.
//  Copyright © 2019 曹连华. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN
@class LMReportView;
@class LMRGrid;
@class LMRLabel;
@class LMRModel;

@protocol FormComponentViewDelegate <NSObject>

@optional

- (void)didTapFormItemWithModel:(LMRModel *)model
                          label:(LMRLabel *)label
                     reportView:(LMReportView *)reportView;

- (void)didLongPressFormItemWithModel:(LMRModel *)model
                                label:(LMRLabel *)label
                           reportView:(LMReportView *)reportView;

/** order
 * LMROrderedAscending -1,
 * LMROrderedNature 0,
 * LMROrderedDescending 1,
 */
- (NSOrderedSet *)order:(NSInteger )order
     indexesSortedByCol:(NSInteger)col
             reportView:(LMReportView *)reportView;

@end

@interface FormComponentView : UIView

@property (nonatomic, strong, readonly) LMReportView *reportView;

- (void)updateFormViewWithDataArray:(NSMutableArray<NSMutableArray<LMRModel*>*> *)dataArray;

/* 详情见 LMRStyle.m  类 defaultStyle 方法
 *
 */
- (void)updateFormStyleSettings:(NSDictionary *)settings;

@property (nonatomic, weak) id<FormComponentViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
