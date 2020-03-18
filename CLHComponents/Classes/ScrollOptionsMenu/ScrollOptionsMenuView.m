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

- (void)setNormalTitleColor:(UIColor *_Nullable)normalColor
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
    NSIndexPath *_currentSelectedIndexPath;
    CGFloat _startContentOffset;
    BOOL _isTapSelected;
    ScrollDirection _scrollDirection;
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
        _highlightLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - _lineSize.height - 2, _lineSize.width, _lineSize.height)];
        _highlightLine.backgroundColor = [UIColor colorWithRed:255.f/255.f green:83.f/255.f blue:0.f/255.f alpha:1];
    }
    return _highlightLine;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [self initWithFrame:frame scrollDirection:ScrollDirectionHorizontal];
    if (self){
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame scrollDirection:(ScrollDirection)scrollDirection {
    self = [super initWithFrame:frame];
    if (self) {
        _scrollDirection = scrollDirection;
        [self setDefoutWithFrame:frame];
    }
    return self;
}
- (void)setDefoutWithFrame:(CGRect)frame {
    _animateDuration = 0.23;
    _isTapSelected = NO;
    _normalFont = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    _selectedFont = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    [self setLineSize:CGSizeMake(30, 2)];
    _normalColor = [UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1];
    _selectedColor = [UIColor colorWithRed:255.f/255.f green:83.f/255.f blue:0.f/255.f alpha:1];
    _contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    _minimumInteritemSpacing = 10;
    _currentSelectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.collectionView.frame = CGRectMake(_contentEdgeInsets.left, _contentEdgeInsets.top, CGRectGetWidth(self.frame) - 2*_contentEdgeInsets.left, CGRectGetHeight(self.frame) - (_contentEdgeInsets.top + _contentEdgeInsets.bottom));
    [self addSubview:self.collectionView];
    [self.collectionView addSubview:self.highlightLine];
}
- (void)updateSelectedIndex:(NSInteger)selectedIndex {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    _currentSelectedIndexPath = indexPath;
    [self scrollToSelectedCellWithSelectedIndexPath:_currentSelectedIndexPath];
    
    for (OptionsModel *model in self.dataArray) {
        model.isSelected = NO;
    }
    
    OptionsModel *selectedMOdel = [self.dataArray objectAtIndex:_currentSelectedIndexPath.row];
    selectedMOdel.isSelected = YES;
    [self.collectionView reloadData];
    [self.collectionView setNeedsLayout];
    [UIView animateWithDuration:_animateDuration animations:^{
        [self setLineSize:self->_lineSize];
        self.highlightLine.center = [self getLineFrameWithIndexPath:self->_currentSelectedIndexPath];
    }];
}
- (void)updateDataArray:(NSArray<NSString *>*)dataArray {
    self.dataArray = [self getModels:dataArray];
    [self.collectionView reloadData];
    [self setLineSize:_lineSize];
    self.highlightLine.center = [self getLineFrameWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}
- (void)setNormalTitleColor:(UIColor *_Nullable)normalColor
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
    _isTapSelected = YES;
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
    [cell setNormalTitleColor:_normalColor normalFont:_normalFont selectedColor:_selectedColor selectedFont:_selectedFont];
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

- (void)scrollToSelectedCellWithSelectedIndexPath:(NSIndexPath *)selectedIndexPath {
    
    NSArray *visibleIndexArray = [[self.collectionView indexPathsForVisibleItems] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    if ([selectedIndexPath isEqual:[visibleIndexArray lastObject]]) {
        [self.collectionView scrollToItemAtIndexPath:[self getNextInexPathWithCurrendIndexPath:selectedIndexPath]  atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    } else if ([selectedIndexPath isEqual:[visibleIndexArray firstObject]]) {
        [self.collectionView scrollToItemAtIndexPath:[self getPreviousInexPathWithCurrendIndexPath:selectedIndexPath]  atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
    if (![visibleIndexArray containsObject:selectedIndexPath]) {
        [self.collectionView selectItemAtIndexPath:selectedIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
}
- (void)willBeginDragging:(UIScrollView *)scrollView {
    _isTapSelected = NO;
    switch (_scrollDirection) {
        case ScrollDirectionVertical:
            _startContentOffset = scrollView.contentOffset.y;
            break;
        default:
            _startContentOffset = scrollView.contentOffset.x;
            break;
    }
}

- (void)didScroll:(UIScrollView *)scrollView {
    if (_isTapSelected) { return; }
    if (_scrollDirection == ScrollDirectionVertical) {
        CGFloat scrollHeight = fabs(scrollView.contentOffset.y - _startContentOffset);
        if(scrollView.contentOffset.y - _startContentOffset > 0) {
            NSIndexPath *nextIndexPath = [self getNextInexPathWithCurrendIndexPath:_currentSelectedIndexPath];
            if(![nextIndexPath isEqual:_currentSelectedIndexPath]) {
                CGPoint nextLinePoint = [self getLineFrameWithIndexPath:nextIndexPath];
                CGFloat toNextDifference = nextLinePoint.x - self.highlightLine.center.x;
                CGFloat toNextaAddMaxWidth = toNextDifference + _lineSize.width / 2;
                self.highlightLine.frame = CGRectMake(self.highlightLine.frame.origin.x, self.highlightLine.frame.origin.y, _lineSize.width + (scrollHeight/scrollView.bounds.size.height*toNextaAddMaxWidth), _lineSize.height);
            }
        } else {
            NSIndexPath *previousIndexPath = [self getPreviousInexPathWithCurrendIndexPath:_currentSelectedIndexPath];
            if (![previousIndexPath isEqual:_currentSelectedIndexPath]) {
                CGFloat previousLineX= [self getLineFrameWithIndexPath:previousIndexPath].x - _lineSize.width/2;
                CGFloat currentLineX = [self getLineFrameWithIndexPath:_currentSelectedIndexPath].x - _lineSize.width/2;
                CGFloat toPreviousDifference = currentLineX - previousLineX;
                
                self.highlightLine.frame = CGRectMake(currentLineX - (scrollHeight/scrollView.bounds.size.height*toPreviousDifference), self.highlightLine.frame.origin.y, _lineSize.width + (scrollHeight/scrollView.bounds.size.height*toPreviousDifference), _lineSize.height);
            }
        }
        
    } else {
        
        CGFloat scrollWidth = fabs(scrollView.contentOffset.x - _startContentOffset);
        if(scrollView.contentOffset.x - _startContentOffset > 0) {
            NSIndexPath *nextIndexPath = [self getNextInexPathWithCurrendIndexPath:_currentSelectedIndexPath];
            if(![nextIndexPath isEqual:_currentSelectedIndexPath]) {
                CGPoint nextLinePoint = [self getLineFrameWithIndexPath:nextIndexPath];
                CGFloat toNextDifference = nextLinePoint.x - self.highlightLine.center.x;
                CGFloat toNextaAddMaxWidth = toNextDifference + _lineSize.width / 2;
                self.highlightLine.frame = CGRectMake(self.highlightLine.frame.origin.x, self.highlightLine.frame.origin.y, _lineSize.width + (scrollWidth/scrollView.bounds.size.width*toNextaAddMaxWidth), _lineSize.height);
            }
        } else {
            NSIndexPath *previousIndexPath = [self getPreviousInexPathWithCurrendIndexPath:_currentSelectedIndexPath];
            if (![previousIndexPath isEqual:_currentSelectedIndexPath]) {
                CGFloat previousLineX= [self getLineFrameWithIndexPath:previousIndexPath].x - _lineSize.width/2;
                CGFloat currentLineX = [self getLineFrameWithIndexPath:_currentSelectedIndexPath].x - _lineSize.width/2;
                CGFloat toPreviousDifference = currentLineX - previousLineX;
                
                self.highlightLine.frame = CGRectMake(currentLineX - (scrollWidth/scrollView.bounds.size.width*toPreviousDifference), self.highlightLine.frame.origin.y, _lineSize.width + (scrollWidth/scrollView.bounds.size.width*toPreviousDifference), _lineSize.height);
            }
        }
    }
    
}

- (void)didEndDecelerating:(UIScrollView *)scrollView {
    if (_scrollDirection == ScrollDirectionVertical) {
        [self updateSelectedIndex:scrollView.contentOffset.y/scrollView.bounds.size.height];
    } else {
       [self updateSelectedIndex:scrollView.contentOffset.x/scrollView.bounds.size.width];
    }
    
}

- (NSIndexPath *)getPreviousInexPathWithCurrendIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row - 1 >= 0) {
        return [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0];
    } else {//点击的事数据源第一个数据对应的cell
        return [NSIndexPath indexPathForRow:0 inSection:0];
    }
}

- (NSIndexPath *)getNextInexPathWithCurrendIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.row + 1 <= self.dataArray.count - 1) {
        return [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
    } else {//点击的事数据源第一个数据对应的cell
        return [NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0];
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
- (CGPoint)getLineFrameWithIndexPath:(NSIndexPath *)indexPath {
    OptionsCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cell_Identifier forIndexPath:indexPath];
    CGPoint point = CGPointMake(cell.center.x, self.highlightLine.center.y);
    return point;
}

- (void)setLineSize:(CGSize)lineSize {
    _lineSize = lineSize;
    self.highlightLine.frame = CGRectMake(self.highlightLine.frame.origin.x, self.highlightLine.frame.origin.y, _lineSize.width, _lineSize.height);
    self.highlightLine.center = [self getLineFrameWithIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
}

- (void)setAnimateDuration:(CGFloat)duration {
    _animateDuration = duration;
}

- (void)setMinimumInteritemSpacing:(CGFloat)minimumInteritemSpacing {
    _minimumInteritemSpacing = minimumInteritemSpacing > 0 ?minimumInteritemSpacing:10;
    [self.collectionView reloadData];
}

- (void)setContentEdgeInsets:(UIEdgeInsets)edgeInsets {
    _contentEdgeInsets = edgeInsets;
    self.collectionView.frame = CGRectMake(_contentEdgeInsets.left, _contentEdgeInsets.top, CGRectGetWidth(self.frame) - 2*_contentEdgeInsets.left, CGRectGetHeight(self.frame) - (_contentEdgeInsets.top + _contentEdgeInsets.bottom));
    [self addSubview:self.collectionView];
}

@end
