//
//  ComponentScrollViewVC.m
//  Home
//
//  Created by 曹连华 on 2020/3/16.
//  Copyright © 2020 曹连华. All rights reserved.
//

#import "ComponentScrollViewVC.h"
#import <CoreCode/CoreCode.h>
#import <CLHComponents/ScrollOptionsMenuView.h>
@interface ComponentScrollViewVC ()<ScrollOptionsMenuDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) ScrollOptionsMenuView *optionsView;
@property (nonatomic, strong) UIScrollView *mainScrollView;

@end

@implementation ComponentScrollViewVC
- (ScrollOptionsMenuView *)optionsView {
    if (!_optionsView) {
        _optionsView = [[ScrollOptionsMenuView alloc]initWithFrame:CGRectMake(50, 135, UIScreen.width - 100, 35) scrollDirection:ScrollDirectionVertical];
        _optionsView.highlightLine.hidden = YES;
        [_optionsView updateDataArray:[self tits]];
        [_optionsView setLineSize:CGSizeMake(15, 3)];
        [_optionsView setMinimumInteritemSpacing:20];
        [_optionsView setContentEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 10)];
        
        [_optionsView setNormalTitleColor:[UIColor whiteColor] normalFont:[UIFont systemFontOfSize:14] selectedColor:[UIColor whiteColor]  selectedFont:[UIFont systemFontOfSize:14]];
        
        [_optionsView setNormalBackgroundColor:[UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:1.0] selectedBackgroundColor:[UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:1.0] normalCornerRadius:5 selectedCornerRadius:5];
       
        _optionsView.delegate = self;
        _optionsView.backgroundColor = [UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:1.0];
    }
    return _optionsView;
}
- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, UIScreen.width, UIScreen.height - 200)];
        [_mainScrollView setContentSize:CGSizeMake(UIScreen.width, [self tits].count*(UIScreen.height - 200))]; //ScrollDirectionVertical
//        [_mainScrollView setContentSize:CGSizeMake([self tits].count*UIScreen.width, UIScreen.height - 200)]; //ScrollDirectionHorizontal
        _mainScrollView.delegate = self;
        _mainScrollView.pagingEnabled = YES;
    }
    return _mainScrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor grayColor];
    self.navigationItem.titleView = self.optionsView;
    [self.view addSubview:self.mainScrollView];
    
    for (int i = 0; i < [self tits].count; i++) {
        UIView *vie = [[UIView alloc]initWithFrame:CGRectMake(0, i*(UIScreen.height - 200), UIScreen.width, UIScreen.height - 200)];//ScrollDirectionVertical
//        UIView *vie = [[UIView alloc]initWithFrame:CGRectMake(i*UIScreen.width, 0, UIScreen.width, UIScreen.height - 200)];//ScrollDirectionHorizontal
        vie.backgroundColor = i%2==0 ? [UIColor greenColor]:[UIColor blueColor];
        [self.mainScrollView addSubview:vie];
    }
}

#pragma mark - ScrollOptionsMenuDelegate
- (void)didSelectedItemWithIndex:(NSInteger)index {
//    NSLog(@"点击了 %ld",(long)index);
    [self.mainScrollView setContentOffset:CGPointMake(index*UIScreen.width, 0) animated:YES];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    NSLog(@"WillBeginDragging - %f  - %f",scrollView.contentOffset.x,scrollView.contentSize.width);
    [self.optionsView willBeginDragging:scrollView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"DidScroll - %f  - %f",scrollView.contentOffset.x,scrollView.contentSize.width);
    [self.optionsView didScroll:scrollView];
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    NSLog(@"WillEndDragging - %f  - %f",scrollView.contentOffset.x,scrollView.contentSize.width);
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.optionsView didEndDecelerating:scrollView];
    
}
- (NSArray<NSString *>*)tits {
    return @[@"推asasasa荐",@"ddd",@"社sss会",@"科技",@"电影",@"国际新闻",@"体育新闻",@"国际体育新闻",@"aaa体育新闻"];
}
@end
