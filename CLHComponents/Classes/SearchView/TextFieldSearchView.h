//
//  TextFieldSearchView.h
//
//  Created by 曹连华 on 2019/12/2.
//  Copyright © 2019 曹连华. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TextFieldSearchType) {
    TextFieldSearchIng = 0,
    TextFieldSearchCancel,
    TextFieldSearchReturn,
    TextFieldSearchClear,
    TextFieldSearchShouldBegin,
};

@protocol TextFieldSearchViewDelegate <NSObject>

- (void)searchTitle:(NSString *_Nonnull)title searchType:(TextFieldSearchType)searchType;

@end


@interface TextFieldSearchView : UIView

@property (nonatomic, strong, readonly) UITextField *searchField;

- (instancetype)initWithFrame:(CGRect)frame
                  placeholder:(NSString *)placeholder
                     delegate:(id<TextFieldSearchViewDelegate>)delegate;

@property (nonatomic, weak) id <TextFieldSearchViewDelegate>delegate;

- (void)resignFirstResponder;

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder;

@end

NS_ASSUME_NONNULL_END
