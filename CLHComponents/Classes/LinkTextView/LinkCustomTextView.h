//
//  LinkCustomTextView.h
//  OneStore
//
//  Created by 李 风磊 on 15/6/10.
//  Copyright (c) 2015年 OneStore. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LinkCustomTextView;

@protocol CustomTextViewDelegate <NSObject>

@optional
- (void)titleDidClicked:(LinkCustomTextView *)textView;

@end

@interface LinkCustomTextView : UIView

@property(nonatomic, strong) UITextView *customTextView;

/*****************外部使用可点链接，只需要传下面三个参数即可*******************/
/** 富文本 */
@property(nonatomic, strong) NSAttributedString *attributedString;
/** 选中的文字 */
@property(nonatomic, copy) NSString *selectedString;
/** 选中的文字属性*/
@property(nonatomic, strong) NSDictionary *selectedAttributeDic;
/** 跳转链接 */
@property(nonatomic, copy) NSString *clickURLString;
/** 文字的属性 */
@property(nonatomic, strong) NSDictionary *attributeDic;

@property(nonatomic, weak) id <CustomTextViewDelegate> delegate;

@end
