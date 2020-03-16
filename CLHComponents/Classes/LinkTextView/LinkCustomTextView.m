//
//  LinkCustomTextView.m
//  OneStore
//
//  Created by 李 风磊 on 15/6/10.
//  Copyright (c) 2015年 OneStore. All rights reserved.
//

#import "LinkCustomTextView.h"
#import <CoreText/CoreText.h>

#pragma mark - 只有这个地方用到就不新建文件来创建这个模型了

@interface LinkVO : NSObject

/** 链接的文字 */
@property(nonatomic, copy) NSString *text;
/** 链接的范围 */
@property(nonatomic, assign) NSRange range;
/** 链接数组,因为链接可能是换行的 */
@property(nonatomic, strong) NSArray *rectsArray;

@end

@implementation LinkVO

@end

@interface LinkCustomTextView ()

@property(nonatomic, strong) NSMutableArray *linksArray;

/** 选中的范围 */
@property(nonatomic, assign) NSRange selectedRange;

@end

@implementation LinkCustomTextView

- (UITextView *)customTextView {
    if (!_customTextView) {
        _customTextView = [[UITextView alloc] init];
        [_customTextView setBackgroundColor:[UIColor clearColor]];
        [_customTextView setEditable:NO];
        [_customTextView setScrollEnabled:NO];
        [_customTextView setUserInteractionEnabled:YES];
    }
    return _customTextView;
}

- (NSMutableArray *)linksArray {
    if (!_linksArray) {
        _linksArray = [NSMutableArray array];

        // 来到这里说明找到链接
        LinkVO *linkVO = [[LinkVO alloc] init];
        linkVO.text = self.selectedString;
        linkVO.range = self.selectedRange;

        // 处理矩形框，因为有可能链接是换行存在的
        NSMutableArray *rectArray = [NSMutableArray array];
        // 设置选中的范围
        self.customTextView.selectedRange = linkVO.range;
        // 设置选中的字符范围的边框
        NSArray *rectsArray = [self.customTextView selectionRectsForRange:self.customTextView.selectedTextRange];
        for (UITextSelectionRect *rect in rectsArray) {
            if (rect.rect.size.width == 0 || rect.rect.size.height == 0) {
                continue;
            }
            if (rect) {
                [rectArray addObject:rect];
            }
            
        }
        linkVO.rectsArray = rectArray;
        if (linkVO) {
            [_linksArray addObject:linkVO];
        }
        
    }
    return _linksArray;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.customTextView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewDidTouched:)];
        [self.customTextView addGestureRecognizer:tap];
        [self.customTextView setTextContainerInset:UIEdgeInsetsMake(0, -5, 0, -5)]; // 取消间距
    }
    return self;
}

- (void)textViewDidTouched:(UIGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:recognizer.view];
    LinkVO *touchingLink = [self touchingLinkWithPoint:point];
    if (touchingLink && [touchingLink isKindOfClass:[LinkVO class]]) {
        if (self.clickURLString) {
            if ([self.delegate respondsToSelector:@selector(titleDidClicked:)]) {
                [self.delegate titleDidClicked:self];
            } else {

            }
        }
    }
}

- (void)setAttributedString:(NSAttributedString *)attributedString {
    
    NSMutableAttributedString *tmpAttriString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    UIFont *selectedFont = [UIFont systemFontOfSize:12];
    //有传递的自定义属性优先使用
    if (self.attributeDic) {
        [tmpAttriString setAttributes:self.attributeDic range:NSMakeRange(0, tmpAttriString.length)];
        if([self.attributeDic objectForKey:NSFontAttributeName]) {
            selectedFont = [self.attributeDic objectForKey:NSFontAttributeName];
        }
    }
    
    if (self.selectedString) {
        if (![tmpAttriString.string containsString:self.selectedString]) {
            [tmpAttriString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:self.selectedString]];
        }
        if (self.selectedString.length > 0) {
            self.selectedRange = [tmpAttriString.string rangeOfString:self.selectedString];
        } else {
            self.selectedRange = NSMakeRange(NSNotFound, 0);
        }
        if(self.selectedAttributeDic) {
            [tmpAttriString setAttributes:self.selectedAttributeDic range:self.selectedRange];
        }else {
            [tmpAttriString setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:104.0 / 255.0 green:164.0 / 255.0 blue:222.0 / 255.0 alpha:1.0], NSFontAttributeName: selectedFont} range:self.selectedRange];
        }
        //选中文字部分默认待下划线
        [tmpAttriString addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:@(kCTUnderlineStyleSingle | kCTUnderlinePatternSolid) range:self.selectedRange];

    }
    
    _attributedString = tmpAttriString.copy;
    self.customTextView.attributedText = _attributedString;
    self.linksArray = nil; // 清空先
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.customTextView setFrame:self.bounds];
}

#pragma mark - 链接处理

- (LinkVO *)touchingLinkWithPoint:(CGPoint)point {
    // 查看哪个链接被选中
    __block LinkVO *touchingLink = nil;

    [self.linksArray enumerateObjectsUsingBlock:^(LinkVO *linkVO, NSUInteger idx, BOOL *stop) {
        for (UITextSelectionRect *rect in linkVO.rectsArray) {
            if (CGRectContainsPoint(rect.rect, point)) { // 点击别的地方不会被选中
                touchingLink = linkVO;
                break;
            }
        }
    }];
    return touchingLink;
}

@end
