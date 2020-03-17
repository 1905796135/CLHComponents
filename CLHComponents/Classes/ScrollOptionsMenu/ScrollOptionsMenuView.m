//
//  ScrollOptionsMenuView.m
//  HWHouseEdit
//
//  Created by 曹连华 on 2019/4/30.
//  Copyright © 2019 曹连华. All rights reserved.
//

#import "ScrollOptionsMenuView.h"

#pragma mark - OptionsModel
@implementation OptionsModel

@end

#pragma mark - OptionsCell
@interface OptionsCell ()

@property (nonatomic, strong) UIButton *titleBtn;

@end

@implementation OptionsCell
- (UIButton *)titleBtn {
    if (!_titleBtn) {
        _titleBtn = [[UIButton alloc]init];
        _titleBtn.userInteractionEnabled = NO;
        _titleBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    }
    return _titleBtn;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.titleBtn];
        self.titleBtn.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }
    return self;
}

- (void)updateWithModel:(OptionsModel *)model {
    [self.titleBtn setTitle:model.title forState:UIControlStateNormal];
    [self.titleBtn setTitle:model.title forState:UIControlStateHighlighted];
    [self.titleBtn setTitle:model.title forState:UIControlStateSelected];
    self.titleBtn.selected = model.isSelected;
}

- (void)updateTitleColor:(UIColor *_Nullable)normalColor
              normalFont:(UIFont *_Nullable)normalFont
           selectedColor:(UIColor *_Nullable)selectedColor
            selectedFont:(UIFont *_Nullable)selectedFont {
    if (normalColor) {
        [self.titleBtn setTitleColor:normalColor forState:UIControlStateNormal];
    }
    if (selectedColor) {
        [self.titleBtn setTitleColor:selectedColor forState:UIControlStateHighlighted];
        [self.titleBtn setTitleColor:selectedColor forState:UIControlStateSelected];
    }
    [UIView animateWithDuration:0.23 animations:^{
        self.titleBtn.titleLabel.font = self.titleBtn.selected ? selectedFont : normalFont;
    }];
    
    self.titleBtn.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

@end
#define  cell_Identifier @"optionsitemcell"
@interface ScrollOptionsMenuView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray<OptionsModel *> *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImageView *highlightLine;

@end

@implementation ScrollOptionsMenuView {
    CGSize _lineSize;
    UIFont *_normalFont;
    UIColor *_normalColor;
    UIFont *_selectedFont;
    UIColor *_selectedColor;
    CGFloat _animateDuration;
    CGFloat _minimumInteritemSpacing;
    UIEdgeInsets _contentEdgeInsets;
    
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLatout = [[UICollectionViewFlowLayout alloc]init];
        flowLatout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLatout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[OptionsCell class] forCellWithReuseIdentifier:cell_Identifier];
        [_collectionView addSubview:self.highlightLine];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (UIImageView *)highlightLine {
    if (_highlightLine == nil) {
        _highlightLine = [[UIImageView alloc] initWithFrame:CGRectZero];
        _highlightLine.backgroundColor = [UIColor colorWithRed:255.f/255.f green:83.f/255.f blue:0.f/255.f alpha:1];
    }
    return _highlightLine;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefoutWithFrame:frame];
    }
    return self;
}

- (void)setDefoutWithFrame:(CGRect)frame {
    _animateDuration = 0.23;
    _normalFont = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    _selectedFont = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
    [self setLineSize:CGSizeMake(30, 2)];
    _normalColor = [UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1];
    _selectedColor = [UIColor colorWithRed:255.f/255.f green:83.f/255.f blue:0.f/255.f alpha:1];
    _contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    _minimumInteritemSpacing = 10;
    self.collectionView.frame = CGRectMake(_contentEdgeInsets.left, _contentEdgeInsets.top, CGRectGetWidth(self.frame) - 2*_contentEdgeInsets.left, CGRectGetHeight(self.frame) - (_contentEdgeInsets.top + _contentEdgeInsets.bottom));
    [self addSubview:self.collectionView];
    [self.collectionView addSubview:self.highlightLine];
}
- (void)updateSelectedIndex:(NSInteger)selectedIndex {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    [self scrollToSelectedCellWith:indexPath];
    
    for (OptionsModel *model in self.dataArray) {
        model.isSelected = NO;
    }
    
    OptionsModel *selectedMOdel = [self.dataArray objectAtIndex:indexPath.row];
    selectedMOdel.isSelected = YES;
    [self.collectionView reloadData];
    [self.collectionView setNeedsLayout];
    [UIView animateWithDuration:_animateDuration animations:^{
        [self setLineFrameWithIndexPath:indexPath];
    }];
}
- (void)updateDataArray:(NSArray<NSString *>*)dataArray {
    self.dataArray = [self getModels:dataArray];
    [self.collectionView reloadData];
    [self setLineSize:_lineSize];
    [self setLineFrameWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}
- (void)updateTitleColor:(UIColor *_Nullable)normalColor
              normalFont:(UIFont *_Nullable)normalFont
           selectedColor:(UIColor *_Nullable)selectedColor
            selectedFont:(UIFont *_Nullable)selectedFont {
    
    _normalColor = normalColor?:_normalColor;
    _normalFont = normalFont?:_normalFont;
    _selectedColor = selectedColor?:_selectedColor;
    _selectedFont = selectedFont?:_selectedFont;
    [self.collectionView reloadData];
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self updateSelectedIndex:indexPath.row];
    
    if([self.delegate respondsToSelector:@selector(didSelectedItemWithIndex:)]) {
        [self.delegate didSelectedItemWithIndex:indexPath.row];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OptionsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cell_Identifier forIndexPath:indexPath];
    [cell updateWithModel:[self.dataArray objectAtIndex:indexPath.row]];
    [cell updateTitleColor:_normalColor normalFont:_normalFont selectedColor:_selectedColor selectedFont:_selectedFont];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    OptionsModel *model = [self.dataArray objectAtIndex:indexPath.row];
    CGSize itemSize = CGSizeZero;
    if (model.isSelected) {
        itemSize = [model.title sizeWithAttributes:@{NSFontAttributeName:_selectedFont}];
    } else {
        itemSize = [model.title sizeWithAttributes:@{NSFontAttributeName:_normalFont}];
    }
    return itemSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return _minimumInteritemSpacing;
}

- (void)scrollToSelectedCellWith:(NSIndexPath *)selectedIndexPath {
    
    NSArray *visibleIndexArray = [[self.collectionView indexPathsForVisibleItems] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    if ([selectedIndexPath isEqual:[visibleIndexArray lastObject]]) {
         NSLog(@"点击的是正在显示的cell 数组右边的cell");
        if (selectedIndexPath.row + 1 <= self.dataArray.count - 1) {
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:selectedIndexPath.row + 1 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionRight];
        } else {//点击的事数据源最后一个数据对应的cell
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionRight];
        }
    } else if ([selectedIndexPath isEqual:[visibleIndexArray firstObject]]) {
        NSLog(@"点击的是正在显示的cell 数组左边的cell");
        if (selectedIndexPath.row - 1 >= 0) {
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:selectedIndexPath.row - 1 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionLeft];
        } else {//点击的事数据源第一个数据对应的cell
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionLeft];
        }
    }
    if (![visibleIndexArray containsObject:selectedIndexPath]) {
        [self.collectionView selectItemAtIndexPath:selectedIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
}

- (NSArray<OptionsModel *>*)getModels:(NSArray<NSString*>*)titleArray {
    NSMutableArray *modelArray = [NSMutableArray array];
    for (int i = 0; i < titleArray.count; i++) {
        NSString *title = [titleArray objectAtIndex:i];
        OptionsModel *model = [[OptionsModel alloc]init];
        model.title = title;
        model.isSelected = i == 0;
        [modelArray addObject:model];
    }
    return modelArray;
}
- (CGPoint)setLineFrameWithIndexPath:(NSIndexPath *)indexPath {
    OptionsCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cell_Identifier forIndexPath:indexPath];
    self.highlightLine.frame = CGRectMake(0, self.frame.size.height - _lineSize.height - 2, _lineSize.width, _lineSize.height);
    CGPoint point = CGPointMake(cell.center.x, self.highlightLine.center.y);
    self.highlightLine.center = point;
    return point;
}

- (void)setLineSize:(CGSize)lineSize {
    _lineSize = lineSize;
    [self setLineFrameWithIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
}

- (void)setAnimateDuration:(CGFloat)duration {
    _animateDuration = duration;
}

- (void)setMinimumInteritemSpacing:(CGFloat)minimumInteritemSpacing {
    _minimumInteritemSpacing = minimumInteritemSpacing > 0 ?minimumInteritemSpacing:10;
    [self.collectionView reloadData];
}

- (void)setConetentEdgeInsets:(UIEdgeInsets)edgeInsets {
    _contentEdgeInsets = edgeInsets;
    self.collectionView.frame = CGRectMake(_contentEdgeInsets.left, _contentEdgeInsets.top, CGRectGetWidth(self.frame) - 2*_contentEdgeInsets.left, CGRectGetHeight(self.frame) - (_contentEdgeInsets.top + _contentEdgeInsets.bottom));
    [self addSubview:self.collectionView];
}

@end
