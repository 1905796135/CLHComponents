//
//  TextFieldSearchView.m
//
//  Created by 曹连华 on 2019/12/2.
//  Copyright © 2019 曹连华. All rights reserved.
//

#import "TextFieldSearchView.h"

@interface TextFieldSearchView ()<UITextFieldDelegate> {
    NSString *_searchTitle;
    TextFieldSearchType _searchType;
    CGFloat _aWidth;
    CGFloat _aheight;
}
@property (nonatomic, strong) UITextField *searchField;

@end

@implementation TextFieldSearchView

- (UITextField *)searchField {
    if (!_searchField) {
        _searchField = [[UITextField alloc]init];
        _searchField.backgroundColor = [UIColor clearColor];
        _searchField.textColor =[UIColor blackColor];
        _searchField.font = [UIFont fontWithName:@"Pingfang SC" size:14];
        _searchField.borderStyle = UITextBorderStyleNone;
        _searchField.delegate = self;
        _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchField.returnKeyType = UIReturnKeySearch;
    }
    return _searchField;
}

- (instancetype)initWithFrame:(CGRect)frame
                  placeholder:(NSString *)placeholder
                     delegate:(id<TextFieldSearchViewDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _aWidth = CGRectGetWidth(frame);
        _aheight = CGRectGetHeight(frame);
        self.searchField.placeholder = placeholder;
        self.delegate = delegate;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _aWidth = CGRectGetWidth(self.bounds);
    _aheight = CGRectGetHeight(self.bounds);
    [self initUI];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _aWidth = CGRectGetWidth(self.bounds);
    _aheight = CGRectGetHeight(self.bounds);
    self.searchField.frame = CGRectMake(5, 0, _aWidth - 10, _aheight);
}

- (void)initUI {
    [self addSubview:self.searchField];
    self.searchField.frame = CGRectMake(5, 0, _aWidth - 10, _aheight);
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (_searchType != TextFieldSearchClear) {
        _searchType = TextFieldSearchShouldBegin;
        _searchTitle = @"";
        [self beginSearch];
    }
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   {
    NSMutableString *tme = [NSMutableString stringWithFormat:@"%@",textField.text];
    [tme replaceCharactersInRange:range withString:string];
    NSArray * arr = [tme componentsSeparatedByString:@" "].copy;
    _searchTitle = [arr componentsJoinedByString:@""];
    _searchType = TextFieldSearchIng;
    [self prepareSearch];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    _searchTitle = @"";
    _searchType = TextFieldSearchClear;
    [self.searchField resignFirstResponder];
    [self beginSearch];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    _searchTitle = textField.text;
    _searchType = TextFieldSearchReturn;
    [self.searchField resignFirstResponder];
    [self beginSearch];
    return YES;
}

- (void)prepareSearch {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(beginSearch) object:nil];
    [self performSelector:@selector(beginSearch) withObject:nil afterDelay:0.85];
    
}

- (void)beginSearch {
    if ([self.delegate respondsToSelector:@selector(searchTitle:searchType:)]) {
        [self.delegate searchTitle:_searchTitle searchType:_searchType];
    }
}

- (void)resignFirstResponder {
    self.searchField.text = @"";
    [self.searchField resignFirstResponder];
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    self.searchField.attributedPlaceholder = attributedPlaceholder;
}

@end
