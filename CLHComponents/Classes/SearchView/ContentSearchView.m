//
//
//  Created by 曹连华 on 2019/4/23.
//  Copyright © 2019 曹连华. All rights reserved.
//

#import "ContentSearchView.h"
#import <CoreCode/CoreCode.h>
@interface ContentSearchView ()<TextFieldSearchViewDelegate> {
    NSString *_placeholder;
    ContentSearchShowType _showType;
    UIEdgeInsets _searchFieldEdgeInsets;
}

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *searchIcon;
@property (nonatomic, strong) TextFieldSearchView *searchField;
@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation ContentSearchView

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}

- (UIImageView *)searchIcon {
    if (!_searchIcon) {
        _searchIcon = [[UIImageView alloc]init];
        _searchIcon.image = [UIImage imageWithFileName:@"search_icon_black" bundleName:@"SearchViewResources"aClass:[self class]];
        _searchIcon.backgroundColor = [UIColor clearColor];
    }
    return _searchIcon;
}

- (TextFieldSearchView *)searchField {
    if (!_searchField) {
        _searchField = [[TextFieldSearchView alloc]initWithFrame:CGRectZero placeholder:_placeholder delegate:self];
        _searchField.backgroundColor = [UIColor whiteColor];
    }
    return _searchField;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _rightBtn.hidden = YES;
        _rightBtn.backgroundColor = [UIColor clearColor];
        [_rightBtn setTitle:@"取消" forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
                     showType:(ContentSearchShowType)showType {
    self = [self initWithFrame:frame showType:showType placeholder:@""];
    if (self) {
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
                     showType:(ContentSearchShowType)showType
                  placeholder:(NSString *)placeholder {
    self = [self initWithFrame:frame showType:showType placeholder:placeholder delegate:nil];
    if (self) {
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
                     showType:(ContentSearchShowType)showType
                  placeholder:(NSString *)placeholder
                     delegate:(nullable id<ContentSearchViewDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        _showType = showType;
        _placeholder = placeholder;
        self.delegate = delegate;
        self.searchIcon.hidden = (_showType == ContentShowTypeNormal)||(_showType == ContentShowTypeRightBtn);       
        switch (_showType) {
            case ContentShowTypeNormal:
            case ContentShowTypeRightBtn:
                _searchFieldEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                break;
            case ContentShowTypeSearchIcon:
            case ContentShowTypeIconRightBtn:
                _searchFieldEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
                break;
            default:
                _searchFieldEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                break;
        }
        
        [self refrestSearchViewWithEdgeInsets:_searchFieldEdgeInsets];
        
        [self observeNotification:UIKeyboardWillShowNotification];
        [self observeNotification:UIKeyboardWillHideNotification];
        
    }
    return self;
}

- (void)refrestSearchViewWithEdgeInsets:(UIEdgeInsets)edgeInsets {
    self.searchField.frame = CGRectMake(edgeInsets.left, edgeInsets.top, CGRectGetWidth(self.bounds) - (edgeInsets.left + edgeInsets.right), CGRectGetHeight(self.bounds) - (edgeInsets.top + edgeInsets.bottom));
    self.rightBtn.frame = CGRectMake(CGRectGetWidth(self.bounds) - edgeInsets.right + 5, 0, edgeInsets.right - 10, CGRectGetHeight(self.bounds));
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self initUI];
}

- (void)initUI {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.searchIcon];
    [self.bgView addSubview:self.rightBtn];
    [self.bgView addSubview:self.searchField];
    
    self.bgView.frame = self.bounds;
    self.searchIcon.frame = CGRectMake(5, (CGRectGetHeight(self.bounds) - 20)/2, 20, 20);
}

#pragma mark - TextFieldSearchViewDelegate
- (void)searchTitle:(NSString *_Nonnull)title searchType:(TextFieldSearchType)searchType {
    if ([self.delegate respondsToSelector:@selector(searchTitle:searchType:)]) {
        [self.delegate searchTitle:title searchType:searchType];
    }
}

- (void)didBecomeFirstResponder {//光标响应
    switch (_showType) {
        case ContentShowTypeRightBtn:
            [self refrestSearchViewWithEdgeInsets:UIEdgeInsetsMake(0, MAX(0, _searchFieldEdgeInsets.left), 0, MAX(60, _searchFieldEdgeInsets.right))];
            break;
        case ContentShowTypeIconRightBtn:
            [self refrestSearchViewWithEdgeInsets:UIEdgeInsetsMake(0, MAX(30, _searchFieldEdgeInsets.left), 0, MAX(60, _searchFieldEdgeInsets.right))];
            break;
        default:
            [self refrestSearchViewWithEdgeInsets:UIEdgeInsetsMake(MAX(0, _searchFieldEdgeInsets.top), MAX(0, _searchFieldEdgeInsets.left), MAX(0, _searchFieldEdgeInsets.bottom), MAX(0, _searchFieldEdgeInsets.right))];
            break;
    }
    self.rightBtn.hidden = ((_showType == ContentShowTypeNormal)||(_showType ==ContentShowTypeSearchIcon));
    self.searchIcon.hidden = ((_showType == ContentShowTypeNormal)||(_showType == ContentShowTypeRightBtn));
}


- (void)setSearchFieldEdgeInsets:(UIEdgeInsets)searchFieldEdgeInsets {
    switch (_showType) {
        case ContentShowTypeNormal:
            _searchFieldEdgeInsets = UIEdgeInsetsMake(MAX(0, searchFieldEdgeInsets.top), MAX(0, searchFieldEdgeInsets.left), MAX(0, _searchFieldEdgeInsets.bottom), MAX(0, searchFieldEdgeInsets.right));
            break;
        case ContentShowTypeRightBtn:
            _searchFieldEdgeInsets = UIEdgeInsetsMake(MAX(0, searchFieldEdgeInsets.top), MAX(0, searchFieldEdgeInsets.left), MAX(0, _searchFieldEdgeInsets.bottom), MIN(_searchFieldEdgeInsets.right, searchFieldEdgeInsets.right));
            break;
        case ContentShowTypeSearchIcon:
        case ContentShowTypeIconRightBtn:
            _searchFieldEdgeInsets = UIEdgeInsetsMake(MAX(0, searchFieldEdgeInsets.top), MAX(30, searchFieldEdgeInsets.left), MAX(0, _searchFieldEdgeInsets.bottom), MAX(0, searchFieldEdgeInsets.right));
            break;
        default:
            _searchFieldEdgeInsets = searchFieldEdgeInsets;
            break;
    }
    
    [self refrestSearchViewWithEdgeInsets:_searchFieldEdgeInsets];
}

- (void)resignFirstResponder {
    [super resignFirstResponder];
    [self.searchField resignFirstResponder];
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    [self.searchField setAttributedPlaceholder:attributedPlaceholder];
}
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    self.searchField.backgroundColor = backgroundColor;
}
- (void)rightBtnAction:(UIButton *)btn {
    [self resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(rightBtnAction:)]) {
        [self.delegate rightBtnAction:btn];
    }
}
- (void)handleNotification:(NSNotification *)notification {
    if (notification.name == UIKeyboardWillShowNotification) {//显示键盘
        [self didBecomeFirstResponder];
    } else if (notification.name == UIKeyboardWillHideNotification) {//隐藏键盘
        [self refrestSearchViewWithEdgeInsets:_searchFieldEdgeInsets];
        self.rightBtn.hidden = YES;
    }
}

- (void)dealloc {
    [self unobserveNotification:UIKeyboardWillShowNotification];
    [self unobserveNotification:UIKeyboardWillHideNotification];
}
@end
