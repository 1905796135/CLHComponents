//
//  CLHViewController.m
//  CLHComponents
//
//  Created by clh2046@163.com on 03/16/2020.
//  Copyright (c) 2020 clh2046@163.com. All rights reserved.
//

#import "CLHViewController.h"
#import <CoreCode/CoreCode.h>
#import <CLHComponents/CLHComponents.h>

@interface CLHViewController ()<ContentSearchViewDelegate,CustomTextViewDelegate,FormComponentViewDelegate>

@property (nonatomic, strong) UIScrollView *mainScrollView;

@end

@implementation CLHViewController

- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView =[[UIScrollView alloc]initWithFrame:self.view.bounds];
        _mainScrollView.backgroundColor = [UIColor grayColor];
    }
    return _mainScrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mainScrollView];
    
    WaterMarkView *waterMarkView = [[WaterMarkView alloc]initWithFrame:CGRectMake(50, 50, UIScreen.width - 100, 100) withText:@"水印" textFont:[UIFont systemFontOfSize:12] textColor:[UIColor redColor] h_space:30 v_space:30];
    waterMarkView.backgroundColor = [UIColor yellowColor];
    [self.mainScrollView addSubview:waterMarkView];
    
    ContentSearchView *search = [[ContentSearchView alloc]initWithFrame:CGRectMake(50, 170, UIScreen.width - 100, 45) showType:ContentShowTypeIconRightBtn placeholder:@"搜一搜" delegate:self];
    search.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:search];
    
    DataRoundLoopView *loopView = [[DataRoundLoopView alloc]initWithFrame:CGRectMake(50, 235, 167, 167) lineWidth:20];
    [loopView setIsSpace:YES];
    [loopView updateWithModels:@[[[DataRoundLoopModel alloc]initWithDictionary:@{@"name":@"name1",@"value":@(2),@"total":@(10),@"color":[UIColor yellowColor]}],[[DataRoundLoopModel alloc]initWithDictionary:@{@"name":@"name2",@"value":@(3),@"total":@(10),@"color":[UIColor redColor]}],[[DataRoundLoopModel alloc]initWithDictionary:@{@"name":@"name3",@"value":@(2),@"total":@(10),@"color":[UIColor blueColor]}],[[DataRoundLoopModel alloc]initWithDictionary:@{@"name":@"name3",@"value":@(3),@"total":@(10),@"color":[UIColor greenColor]}]]];
    [self.mainScrollView addSubview:loopView];
    
    LinkCustomTextView *linkCustomTextView = [[LinkCustomTextView alloc]initWithFrame:CGRectMake(50, 422, UIScreen.width - 100, 20)];
    linkCustomTextView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    linkCustomTextView.selectedString = @"可以点";
    linkCustomTextView.selectedAttributeDic = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor blueColor]};
    linkCustomTextView.clickURLString = @"https://www.baidu.com";
    linkCustomTextView.delegate = self;
    linkCustomTextView.attributedString = [[NSMutableAttributedString alloc]initWithString:@"这个是可以点击的富文本" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor grayColor]}];
    [self.mainScrollView addSubview:linkCustomTextView];
    
    FormComponentView *formComponentView = [[FormComponentView alloc]initWithFrame:CGRectMake(50, 462, 200, 500)];
    formComponentView.delegate = self;
    [formComponentView updateFormViewWithDataArray:[self formData]];
    [self.mainScrollView addSubview:formComponentView];
}

#pragma mark - ContentSearchViewDelegate
- (void)searchTitle:(NSString *_Nonnull)title searchType:(TextFieldSearchType)searchType {
    
}
#pragma mark - CustomTextViewDelegate
- (void)titleDidClicked:(LinkCustomTextView *)textView {
    [self showLoadingWithMessage:textView.customTextView.text hideAfter:2.5];
}
#pragma mark - FormComponentViewDelegate
- (void)didTapFormItemWithModel:(LMRModel *)model
                          label:(LMRLabel *)label
                     reportView:(LMReportView *)reportView {
    [self showLoadingWithMessage:model.text hideAfter:2.0];
}

- (void)didLongPressFormItemWithModel:(LMRModel *)model
                                label:(LMRLabel *)label
                           reportView:(LMReportView *)reportView {
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (NSMutableArray<NSMutableArray<LMRModel*>*> *)formData {
    
    NSMutableArray *arr = [NSMutableArray<NSMutableArray<LMRModel*>*> array];
    NSMutableArray *row0 = [NSMutableArray<LMRModel*> array];
    [arr safeAddObject:row0];
   
    LMRModel *model00 = [LMRModel modelTitle:@"0_0" size:CGSizeMake(60, 40)];
    LMRModel *model01 = [LMRModel modelTitle:@"0_1" size:CGSizeMake(60, 40)];
    LMRModel *model02 = [LMRModel modelTitle:@"0_2" size:CGSizeMake(60, 40)];
   
    [row0 safeAddObject:model00];
    [row0 safeAddObject:model01];
    [row0 safeAddObject:model02];
    
    NSMutableArray *row1 = [NSMutableArray<LMRModel*> array];
    [arr safeAddObject:row1];
    
    LMRModel *model10 = [LMRModel modelTitle:@"1_0" size:CGSizeMake(60, 40)];
    LMRModel *model11 = [LMRModel modelTitle:@"1_1" size:CGSizeMake(60, 40)];
    LMRModel *model12 = [LMRModel modelTitle:@"1_2" size:CGSizeMake(60, 40)];
    
    [row1 safeAddObject:model10];
    [row1 safeAddObject:model11];
    [row1 safeAddObject:model12];
    
    NSMutableArray *row2 = [NSMutableArray<LMRModel*> array];
    [arr safeAddObject:row2];
    
    LMRModel *model20 = [LMRModel modelTitle:@"2_0" size:CGSizeMake(60, 40)];
    LMRModel *model21 = [LMRModel modelTitle:@"2_1" size:CGSizeMake(60, 40)];
    LMRModel *model22 = [LMRModel modelTitle:@"2_2" size:CGSizeMake(60, 40)];
    
    [row2 safeAddObject:model20];
    [row2 safeAddObject:model21];
    [row2 safeAddObject:model22];
    
    return arr;
}

@end
