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
//    [UIView animateWithDuration:0.23 animations:^{
//        self.titleBtn.titleLabel.font = self.titleBtn.selected ? selectedFont : normalFont;
//    }];
    self.titleBtn.titleLabel.font = self.titleBtn.selected ? selectedFont : normalFont;
    self.titleBtn.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}
- (void)setNormalBackgroundColor:(UIColor *_Nullable)normalBackgroundColor
         selectedBackgroundColor:(UIColor *_Nullable)selectedBackgroundColor
              normalCornerRadius:(CGFloat)normalCornerRadius
            selectedCornerRadius:(CGFloat)selectedCornerRadius {
    if (self.titleBtn.selected) {
        self.titleBtn.backgroundColor = selectedBackgroundColor;
        self.titleBtn.layer.cornerRadius = selectedCornerRadius;
    } else {
        self.titleBtn.backgroundColor = normalBackgroundColor;
         self.titleBtn.layer.cornerRadius = normalCornerRadius;
    }
    self.titleBtn.layer.masksToBounds = YES;
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
    UIColor *_normalBackgroundColor;
    CGFloat _normalCornerRadius;
    UIFont *_selectedFont;
    UIColor *_selectedColor;
    UIColor *_selectedBackgroundColor;
    CGFloat _selectedCornerRadius;
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
    self.collectionView.frame = CGRectMake(_contentEdgeInsets.left, 0, CGRectGetWidth(self.frame) - 2*_contentEdgeInsets.left, CGRectGetHeight(self.frame));
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
- (void)setNormalBackgroundColor:(UIColor *_Nullable)normalBackgroundColor
         selectedBackgroundColor:(UIColor *_Nullable)selectedBackgroundColor
              normalCornerRadius:(CGFloat)normalCornerRadius
            selectedCornerRadius:(CGFloat)selectedCornerRadius {
    _normalBackgroundColor = normalBackgroundColor;
    _selectedBackgroundColor = selectedBackgroundColor;
    _normalCornerRadius = normalCornerRadius;
    _selectedCornerRadius = selectedCornerRadius;
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
    [cell setNormalBackgroundColor:_normalBackgroundColor selectedBackgroundColor:_selectedBackgroundColor normalCornerRadius:_normalCornerRadius selectedCornerRadius:_selectedCornerRadius];
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
    return CGSizeMake(itemSize.width + 10, collectionView.bounds.size.height - (_contentEdgeInsets.top + _contentEdgeInsets.bottom));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return _minimumInteritemSpacing;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(_contentEdgeInsets.top, 0, _contentEdgeInsets.bottom, 0);
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
    
    CGFloat scrollViewContentDistance =_scrollDirection == ScrollDirectionVertical?scrollView.bounds.size.height:scrollView.bounds.size.width;
    CGFloat currentOffset = _scrollDirection == ScrollDirectionVertical?scrollView.contentOffset.y:scrollView.contentOffset.x;
    
    CGFloat scrollDistance = fabs(currentOffset - _startContentOffset);
    CGFloat fontDistance = _selectedFont.pointSize - _normalFont.pointSize;
    
    CGFloat scrollScale = scrollDistance/scrollViewContentDistance;
    
    CGFloat needFontSize = scrollScale*fontDistance;
    
    
    OptionsCell *currentSelectedCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cell_Identifier forIndexPath:_currentSelectedIndexPath];
    currentSelectedCell.titleBtn.titleLabel.font = [UIFont fontWithName:_selectedFont.familyName size:_selectedFont.pointSize - needFontSize];
    
    if(currentOffset - _startContentOffset > 0) {
        NSIndexPath *nextIndexPath = [self getNextInexPathWithCurrendIndexPath:_currentSelectedIndexPath];
        
        OptionsCell *nextCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cell_Identifier forIndexPath:nextIndexPath];
        nextCell.titleBtn.titleLabel.font = [UIFont fontWithName:_selectedFont.familyName size:_selectedFont.pointSize + needFontSize];
        
        if(![nextIndexPath isEqual:_currentSelectedIndexPath]) {
            CGPoint nextLinePoint = [self getLineFrameWithIndexPath:nextIndexPath];
            CGFloat toNextDifference = nextLinePoint.x - self.highlightLine.center.x;
            CGFloat toNextoAddMaxWidth = toNextDifference + _lineSize.width / 2;
            
            self.highlightLine.frame = CGRectMake(self.highlightLine.frame.origin.x, self.highlightLine.frame.origin.y, _lineSize.width + (scrollScale*toNextoAddMaxWidth), _lineSize.height);
        }
    } else {
        NSIndexPath *previousIndexPath = [self getPreviousInexPathWithCurrendIndexPath:_currentSelectedIndexPath];
        
        OptionsCell *previousCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cell_Identifier forIndexPath:previousIndexPath];
        previousCell.titleBtn.titleLabel.font = [UIFont fontWithName:_selectedFont.familyName size:_selectedFont.pointSize + needFontSize];
        
        if (![previousIndexPath isEqual:_currentSelectedIndexPath]) {
            CGFloat previousLineX= [self getLineFrameWithIndexPath:previousIndexPath].x - _lineSize.width/2;
            CGFloat currentLineX = [self getLineFrameWithIndexPath:_currentSelectedIndexPath].x - _lineSize.width/2;
            CGFloat toPreviousDifference = currentLineX - previousLineX;
            
            self.highlightLine.frame = CGRectMake(currentLineX - (scrollScale*toPreviousDifference), self.highlightLine.frame.origin.y, _lineSize.width + (scrollScale*toPreviousDifference), _lineSize.height);
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
    self.collectionView.frame = CGRectMake(_contentEdgeInsets.left, 0, CGRectGetWidth(self.frame) - 2*_contentEdgeInsets.left, CGRectGetHeight(self.frame));
    [self addSubview:self.collectionView];
}

@end
