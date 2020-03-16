//
//  FormComponentView.m
//  HWReportForm
//
//  Created by 曹连华 on 2019/10/8.
//  Copyright © 2019 曹连华. All rights reserved.
//

#import "FormComponentView.h"
#import <Masonry/Masonry.h>
#import <CoreCode/CoreCode.h>
#import "LMReport.h"
@interface FormComponentView ()<LMReportViewDatasource, LMReportViewDelegate>

@property (nonatomic, strong) LMReportView *reportView;
@property (nonatomic, strong) NSMutableArray<NSMutableArray<LMRModel*>*> *formDataArray;

@end

@implementation FormComponentView

- (NSMutableArray<NSMutableArray<LMRModel *> *> *)formDataArray {
    if (!_formDataArray) {
        _formDataArray = [NSMutableArray<NSMutableArray<LMRModel *> *> array];
    }
    return _formDataArray;
}

- (LMReportView *)reportView {
    if (!_reportView) {
        _reportView = [[LMReportView alloc]init];
        _reportView.delegate = self;
        _reportView.datasource = self;
        _reportView.style = [[LMRStyle alloc]initWithSettings:@{LMRBorderColorSettingName:rgb(229, 229, 229)}];
    }
    return _reportView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        self.reportView.frame = frame;
    }
    return self;
}
- (void)initUI {
    [LMRStyle defaultStyle].borderColor = rgb(229, 229, 229);
    [LMRStyle defaultStyle].borderInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [self addSubview:self.reportView];
    [self.reportView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.trailing.mas_equalTo(0);
    }];
}

- (void)updateFormViewWithDataArray:(NSMutableArray<NSMutableArray<LMRModel*>*> *)dataArray {
    if (dataArray.count > 0) {
        [self.formDataArray removeAllObjects];
        [self.formDataArray addObjectsFromArray:dataArray];
        [self.reportView reloadData];
    }
}

- (void)updateFormStyleSettings:(NSDictionary *)settings {
    self.reportView.style = [[LMRStyle alloc]initWithSettings:settings];
}

#pragma mark - LMReportViewDatasource
- (NSInteger)numberOfRowsInReportView:(LMReportView *)reportView {
    return self.formDataArray.count;
}

- (NSInteger)numberOfColsInReportView:(LMReportView *)reportView {
    return [self.formDataArray.lastObject count];
}
- (LMRGrid *)reportView:(LMReportView *)reportView gridAtIndexPath:(NSIndexPath *)indexPath {
    LMRGrid *grid = self.formDataArray[indexPath.row][indexPath.col];
    return grid;
}
- (CGFloat)reportView:(LMReportView *)reportView heightOfRow:(NSInteger)row {
    LMRGrid *grid = self.formDataArray[row][0];
    return grid.rowHeight;
}

- (CGFloat)reportView:(LMReportView *)reportView widthOfCol:(NSInteger)col {
    LMRGrid *grid = self.formDataArray[0][col];
    
    return grid.colWidth;
}

#pragma mark - LMReportViewDelegate
- (void)reportView:(LMReportView *)reportView didTapLabel:(LMRLabel *)label {
    LMRModel *model = (LMRModel *)[reportView gridAtIndexPath:label.indexPath];
    if ([self.delegate respondsToSelector:@selector(didTapFormItemWithModel:label:reportView:)]) {
        [self.delegate didTapFormItemWithModel:model label:label reportView:reportView];
    }
}
- (void)reportView:(LMReportView *)reportView didLongPressLabel:(LMRLabel *)label {
    LMRModel *model = (LMRModel *)[reportView gridAtIndexPath:label.indexPath];
    if ([self.delegate respondsToSelector:@selector(didLongPressFormItemWithModel:label:reportView:)]) {
        [self.delegate didLongPressFormItemWithModel:model label:label reportView:reportView];
    }
}

- (NSOrderedSet *)reportView:(LMReportView *)reportView indexesSortedByCol:(NSInteger)col order:(LMROrder)order {
    if ([self.delegate respondsToSelector:@selector(order:indexesSortedByCol:reportView:)]) {
       return [self.delegate order:order indexesSortedByCol:col reportView:reportView];
    }
    return nil;
}

@end
