//
//
//  Created by 曹连华 on 2019/4/23.
//  Copyright © 2019 曹连华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldSearchView.h"

typedef NS_OPTIONS(NSUInteger, ContentSearchShowType) {
    ContentShowTypeNormal = 0,//只显示搜索框
    ContentShowTypeSearchIcon,//左边显示 🔍（可设置） 右边显示搜索框
    ContentShowTypeRightBtn,//搜索框 右边显示 一个 按钮（文描可设置,光标响应时才显示）
    ContentShowTypeIconRightBtn,//左边显示 🔍（可设置） 中间显示搜索框 右边显示 一个按钮(文描可设置,光标响应时才显示)
};

@protocol ContentSearchViewDelegate <NSObject>

- (void)searchTitle:(NSString *_Nonnull)title searchType:(TextFieldSearchType)searchType;

@optional

- (void)rightBtnAction:(UIButton *_Nonnull)btn;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ContentSearchView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                     showType:(ContentSearchShowType)showType;

- (instancetype)initWithFrame:(CGRect)frame
                     showType:(ContentSearchShowType)showType
                  placeholder:(NSString *)placeholder;

- (instancetype)initWithFrame:(CGRect)frame
                     showType:(ContentSearchShowType)showType
                  placeholder:(NSString *)placeholder
                     delegate:(nullable id<ContentSearchViewDelegate>)delegate;

@property (nonatomic, weak) id <ContentSearchViewDelegate>delegate;

@property (nonatomic, strong, readonly) TextFieldSearchView *searchField;
@property (nonatomic, strong, readonly) UIButton *rightBtn;

@property (nonatomic, assign) UIEdgeInsets searchFieldEdgeInsets;

- (void)resignFirstResponder;

- (void)setSearchIconImageName:(NSString *)iconImageName iconSize:(CGSize)iconSize;

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder;

@end

NS_ASSUME_NONNULL_END
