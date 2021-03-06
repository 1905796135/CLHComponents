//
//  CLHViewController.m
//  CLHComponents
//
//  Created by clh2046@163.com on 03/16/2020.
//  Copyright (c) 2020 clh2046@163.com. All rights reserved.
//

#import "CLHViewController.h"
#import <CLHComponents/CLHComponents.h>
#import "ComponentScrollViewVC.h"

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
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.mainScrollView];
    
    WaterMarkView *waterMarkView = [[WaterMarkView alloc]initWithFrame:CGRectMake(50, 50, [UIScreen mainScreen].bounds.size.width - 100, 100) withText:@"水印" textFont:[UIFont systemFontOfSize:12] textColor:[UIColor redColor] h_space:30 v_space:30];
    waterMarkView.backgroundColor = [UIColor yellowColor];
    [self.mainScrollView addSubview:waterMarkView];
    
    ContentSearchView *search = [[ContentSearchView alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(waterMarkView.frame) + 20, [UIScreen mainScreen].bounds.size.width - 100, 45) showType:ContentShowTypeIconRightBtn placeholder:@"搜一搜" delegate:self];
    search.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:search];
    
    DataRoundLoopView *loopView = [[DataRoundLoopView alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(search.frame) + 20, 167, 167) lineWidth:20];
    [loopView setIsSpace:YES];
    [loopView updateWithModels:@[[[DataRoundLoopModel alloc]initWithDictionary:@{@"name":@"name1",@"value":@(2),@"total":@(10),@"color":[UIColor yellowColor]}],[[DataRoundLoopModel alloc]initWithDictionary:@{@"name":@"name2",@"value":@(3),@"total":@(10),@"color":[UIColor redColor]}],[[DataRoundLoopModel alloc]initWithDictionary:@{@"name":@"name3",@"value":@(2),@"total":@(10),@"color":[UIColor blueColor]}],[[DataRoundLoopModel alloc]initWithDictionary:@{@"name":@"name3",@"value":@(3),@"total":@(10),@"color":[UIColor greenColor]}]]];
    [self.mainScrollView addSubview:loopView];
    
    LinkCustomTextView *linkCustomTextView = [[LinkCustomTextView alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(loopView.frame) + 20, [UIScreen mainScreen].bounds.size.width - 100, 20)];
    linkCustomTextView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    linkCustomTextView.selectedString = @"可以点";
    linkCustomTextView.selectedAttributeDic = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor blueColor]};
    linkCustomTextView.clickURLString = @"https://www.baidu.com";
    linkCustomTextView.delegate = self;
    linkCustomTextView.attributedString = [[NSMutableAttributedString alloc]initWithString:@"这个是可以点击的富文本" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor grayColor]}];
    [self.mainScrollView addSubview:linkCustomTextView];
    
    FormComponentView *formComponentView = [[FormComponentView alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(linkCustomTextView.frame)+20, 200, 150)];
    formComponentView.delegate = self;
    [formComponentView updateFormViewWithDataArray:[self formData]];
    [self.mainScrollView addSubview:formComponentView];
    
    ShadowView *shadowView = [[ShadowView alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(formComponentView.frame), 200, 200)];
    //[_shadowView yc_shaodw];
    [shadowView yc_cornerRadius:10];
    //[_shadowView yc_verticalShaodwRadius:10 shadowColor:[UIColor blueColor] shadowOffset:CGSizeMake(10, 10)];
    //[_shadowView yc_horizontalShaodwRadius:10 shadowColor:[UIColor blueColor] shadowOffset:CGSizeMake(10, 10)];
    [shadowView yc_shaodwRadius:10 shadowColor:[UIColor blueColor] shadowOffset:CGSizeMake(10, 10) byShadowSide:YCShadowSideBottom|YCShadowSideRight];
    [self.mainScrollView addSubview:shadowView];
    
    LineationLabel *label = [[LineationLabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(shadowView.frame)+20, [UIScreen mainScreen].bounds.size.width, 40)];
    label.backgroundColor = [UIColor groupTableViewBackgroundColor];
    label.text = @"1234567891011121314";
    label.textColor = [UIColor redColor];
    label.lineColor = [UIColor blueColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.lineType = LineationLabelLineTypeMiddle;
    [self.mainScrollView addSubview:label];
    
    ShadeRoundLoopView *roundLoopView = [[ShadeRoundLoopView alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(label.frame) + 20, 78, 78)];
    roundLoopView.reduceAngle = 0;
    roundLoopView.tag = 111099;
    roundLoopView.progressLoopWidth = 10;
    roundLoopView.backLoopWidth = 10;
    roundLoopView.backLoopColor = [UIColor colorWithRed:239.0/255.0 green:242.0/255.0 blue:255.0/255.0 alpha:1];
    roundLoopView.startAngle = -90;
    roundLoopView.reduceAngle = 30;
    roundLoopView.progress = 0.1;
    roundLoopView.duration = 0.5;
    roundLoopView.autoAnimation = NO;
    roundLoopView.increaseFromLast = YES;
    roundLoopView.progressColors = @[[UIColor redColor],[UIColor yellowColor],[UIColor blueColor]];
    [self.mainScrollView addSubview:roundLoopView];
    
    [self.mainScrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, CGRectGetMaxY(roundLoopView.frame) + 100)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"右" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction:)];
}

#pragma mark - ContentSearchViewDelegate
- (void)searchTitle:(NSString *_Nonnull)title searchType:(TextFieldSearchType)searchType {
    
}
#pragma mark - CustomTextViewDelegate
- (void)titleDidClicked:(LinkCustomTextView *)textView {
//    [self showLoadingWithMessage:textView.customTextView.text hideAfter:2.5];
    [self.navigationController pushViewController:[ComponentScrollViewVC new] animated:YES];
}
#pragma mark - FormComponentViewDelegate
- (void)didTapFormItemWithModel:(LMRModel *)model
                          label:(LMRLabel *)label
                     reportView:(LMReportView *)reportView {
    NSLog(@"model.text");
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
    [arr addObject:row0];
   
    LMRModel *model00 = [LMRModel modelTitle:@"0_0" size:CGSizeMake(60, 40)];
    LMRModel *model01 = [LMRModel modelTitle:@"0_1" size:CGSizeMake(60, 40)];
    LMRModel *model02 = [LMRModel modelTitle:@"0_2" size:CGSizeMake(60, 40)];
   
    [row0 addObject:model00];
    [row0 addObject:model01];
    [row0 addObject:model02];
    
    NSMutableArray *row1 = [NSMutableArray<LMRModel*> array];
    [arr addObject:row1];
    
    LMRModel *model10 = [LMRModel modelTitle:@"1_0" size:CGSizeMake(60, 40)];
    LMRModel *model11 = [LMRModel modelTitle:@"1_1" size:CGSizeMake(60, 40)];
    LMRModel *model12 = [LMRModel modelTitle:@"1_2" size:CGSizeMake(60, 40)];
    
    [row1 addObject:model10];
    [row1 addObject:model11];
    [row1 addObject:model12];
    
    NSMutableArray *row2 = [NSMutableArray<LMRModel*> array];
    [arr addObject:row2];
    
    LMRModel *model20 = [LMRModel modelTitle:@"2_0" size:CGSizeMake(60, 40)];
    LMRModel *model21 = [LMRModel modelTitle:@"2_1" size:CGSizeMake(60, 40)];
    LMRModel *model22 = [LMRModel modelTitle:@"2_2" size:CGSizeMake(60, 40)];
    
    [row2 addObject:model20];
    [row2 addObject:model21];
    [row2 addObject:model22];
    
    return arr;
}
- (void)rightBarButtonItemAction:(UIBarButtonItem *)ba {
    ShadeRoundLoopView *roundLoopView = (ShadeRoundLoopView *)[self.view viewWithTag:111099];
    roundLoopView.progress = roundLoopView.progress + 0.1;
}
@end
