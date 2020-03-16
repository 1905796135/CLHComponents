//
//  UIViewController+custom.m
//  OneStoreFramework
//
//  Created by Aimy on 14-7-30.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "UIViewController+BarButtonItem.h"

static const CGFloat UpdownLayoutNaviBtnImgWidth = 24.0;
static const CGFloat UpdownLayoutNaviBtnTitleHeight = 14.0;

@implementation DataNaviBtn

@end

@implementation UpdownLayoutNaviBtn
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.size.width/2-UpdownLayoutNaviBtnImgWidth/2, contentRect.size.height/2-(UpdownLayoutNaviBtnImgWidth+UpdownLayoutNaviBtnTitleHeight)/2, UpdownLayoutNaviBtnImgWidth, UpdownLayoutNaviBtnImgWidth);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, contentRect.size.height/2-(UpdownLayoutNaviBtnImgWidth+UpdownLayoutNaviBtnTitleHeight)/2+UpdownLayoutNaviBtnImgWidth, contentRect.size.width, UpdownLayoutNaviBtnTitleHeight);
}

@end

@implementation UIViewController (BarButtonItem)



#pragma mark - navi button
- (void)setNaviButtonType:(BarButtonItem)aType
                  isBgImg:(BOOL)aIsBgImg
                    frame:(CGRect)aFrame
                     text:(NSString *)aText
                    color:(UIColor *)aColor
                     font:(UIFont *)aFont
             shadowOffset:(CGSize)aShadowOffset
                alignment:(UIControlContentHorizontalAlignment)aAlignment
               edgeInsets:(UIEdgeInsets)aEdgeInsets
                   isLeft:(BOOL)aLeft {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (CGRectEqualToRect(CGRectZero, aFrame)) {
        btn.frame = CGRectMake(0, 0, 24, 24);
    }
    else {
        btn.frame = aFrame;
    }
    
    SEL selector = nil;
    if (aLeft) {
        selector = @selector(leftBtnClicked:);
    }
    else {
        selector = @selector(rightBtnClicked:);
    }
    
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    //根据样式不同更改按钮图片
    UIImage *normalImage = [UIImage imageNamed:[self imageNameWithType:aType]];
    UIImage *highlightImage = [UIImage imageNamed:[self imageNameWithType:aType]];
    
    if (aIsBgImg) {
        [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
        [btn setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    } else {
        [btn setImage:normalImage forState:UIControlStateNormal];
        [btn setImage:highlightImage forState:UIControlStateHighlighted];
    }
    
    //按钮文字
    if (aText != nil) {
        [btn setTitle:aText forState:UIControlStateNormal];
    }
    
    if (aColor) {
        [btn setTitleColor:aColor forState:UIControlStateNormal];
    }
    
    if (aFont) {
        btn.titleLabel.font = aFont;
    }
    
    if (!CGSizeEqualToSize(CGSizeZero, aShadowOffset)) {
        btn.titleLabel.shadowOffset = aShadowOffset;
    }
    
    btn.contentHorizontalAlignment = aAlignment;
    
    if (!UIEdgeInsetsEqualToEdgeInsets(aEdgeInsets, UIEdgeInsetsZero)) {
        btn.contentEdgeInsets = aEdgeInsets;
    }
    
    
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    if (aLeft) {
        self.navigationItem.leftBarButtonItem = btnItem;
    }
    else {
        self.navigationItem.rightBarButtonItem = btnItem;
    }
}

- (void)setNaviButtonType:(BarButtonItem)aType
                    frame:(CGRect)aFrame
                     text:(NSString *)aText
                    color:(UIColor *)aColor
                     font:(UIFont *)aFont
             shadowOffset:(CGSize)aShadowOffset
                alignment:(UIControlContentHorizontalAlignment)aAlignment
               edgeInsets:(UIEdgeInsets)aEdgeInsets
                   isLeft:(BOOL)aLeft {
    [self setNaviButtonType:aType isBgImg:NO frame:aFrame text:aText color:aColor font:aFont shadowOffset:aShadowOffset alignment:aAlignment edgeInsets:aEdgeInsets isLeft:aLeft];
}

- (void)setNaviButtonType:(BarButtonItem)aType position:(BarButtonItemPosition)position {
    [self setNaviButtonType:aType frame:CGRectZero text:nil color:nil font:nil shadowOffset:CGSizeZero alignment:UIControlContentHorizontalAlignmentLeft edgeInsets:UIEdgeInsetsZero isLeft:(position == BarButtonItemPositionLeft)];
}

- (void)setNaviButtonText:(NSString *)aText tintColor:(UIColor *)tintColor position:(BarButtonItemPosition)position {
    BOOL isLeft = position == BarButtonItemPositionLeft;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:aText style:UIBarButtonItemStylePlain target:self action:isLeft ? @selector(leftBtnClicked:) : @selector(rightBtnClicked:)];
    item.tintColor = tintColor?tintColor:[UIColor whiteColor];
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = item;
    } else {
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)setUpdownLayoutNaviButtonType:(BarButtonItem)aType text:(NSString *)aText href:(NSString *)aHref items:(NSArray *)aItems position:(BarButtonItemPosition)position {
    BOOL isLeft = position == BarButtonItemPositionLeft;
    DataNaviBtn *btn = nil;
    if (aType!=BarButtonItemNone && aText.length>0) {
        btn = [UpdownLayoutNaviBtn buttonWithType:UIButtonTypeCustom];
    } else {
        btn = [DataNaviBtn buttonWithType:UIButtonTypeCustom];
    }
    btn.frame = CGRectMake(0, 0, 44, 44);
    btn.href = aHref;
    btn.items = aItems;
    
    SEL selector = nil;
    if (isLeft) {
        selector = @selector(leftBtnClicked:);
    }
    else {
        selector = @selector(rightBtnClicked:);
    }
    
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    //根据样式不同更改按钮图片
    UIImage *normalImage = [UIImage imageNamed:[self imageNameWithType:aType]];
    UIImage *highlightImage = [UIImage imageNamed:[self imageNameWithType:aType]];
    [btn setImage:normalImage forState:UIControlStateNormal];
    [btn setImage:highlightImage forState:UIControlStateHighlighted];
    
    //按钮文字
    if (aText != nil) {
        [btn setTitle:aText forState:UIControlStateNormal];
    }
    
    //文字颜色
    [btn setTitleColor:[UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1] forState:UIControlStateNormal];
    
    //文字字体
    if (aType!=BarButtonItemNone && aText.length>0) {
        btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    } else {
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    }
    
    //文字居中
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = btnItem;
    } else {
        self.navigationItem.rightBarButtonItem = btnItem;
    }
}

- (void)setNaviBackButtonWithImageName:(NSString*)imageName {
    NSMutableArray *items = [NSMutableArray array];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClicked:)];
    backItem.tag = 0;
    backItem.imageInsets = UIEdgeInsetsMake(0, 8, 0, -8);
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
    if (@available(iOS 11.0, *)) {
        backItem.imageInsets = UIEdgeInsetsMake(0, -8, 0, 8);
    } else {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -16;
        [items addObject:negativeSeperator];
    }
#else
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -16;
    [items addObject:negativeSeperator];
#endif
    [items addObject:backItem];
    self.navigationItem.leftBarButtonItems = items;
}

- (void)setNaviBackButtonWithImageNameArray:(NSArray<NSString*>*)imageNameArray {
    NSParameterAssert(imageNameArray.count);
    
    NSMutableArray *leftItems = [NSMutableArray array];
    if (self.navigationItem.leftBarButtonItems) {
        [leftItems addObjectsFromArray:self.navigationItem.leftBarButtonItems];
    }
    
    for (int i = 0; i < imageNameArray.count; i++) {
        UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        customBtn.tag = i;
        customBtn.frame = CGRectMake(0, 0, 24, 24);
        
        UIImage *image = [UIImage imageNamed:imageNameArray[i]];
        
        [customBtn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [customBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [customBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
        UIBarButtonItem *customItem = [[UIBarButtonItem alloc] initWithCustomView:customBtn];
        customItem.tag = i;
    
        [leftItems addObject:customItem];
    }
    
    self.navigationItem.leftBarButtonItems = leftItems;
}
- (void)setNaivTitle:(NSString *)title {
    [self setNaivTitle:title font:[UIFont systemFontOfSize:18]];
}

- (void)setNaivTitle:(NSString *)title font:(UIFont *)font {
    [self setNaivTitle:title font:font titleColor:[UIColor whiteColor]];
}

- (void)setNaivTitle:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = font;
    titleLabel.textColor = titleColor;
    self.navigationItem.titleView = titleLabel;
    
}
- (NSString *)imageNameWithType:(BarButtonItem)type {
    NSString *imageName = @"";
    switch (type) {
        case BarButtonItemNone:
            imageName = @"";
            break;
        case BarButtonItemSearch:
            imageName = @"";
            break;
        case BarButtonItemReturnHome:
            imageName = @"";
            break;
        case BarButtonItemSetting:
            imageName = @"";
            break;
        case BarButtonItemFavorite:
            imageName = @"";
            break;
        case BarButtonItemShare:
            imageName = @"";
            break;
        case BarButtonItemRockNow:
            imageName = @"";
            break;
        case BarButtonItemScan:
            imageName = @"";
            break;
        case BarButtonItemCategory:
            imageName = @"";
            break;
        case BarButtonItemLogo:
            imageName = @"";
            break;
        case BarButtonItemReturn:
            imageName = @"navigationbar_btn_return";
            break;
        case BarButtonItemAddWhite:
            imageName = @"navigationbar_btn_add_white";
            break;
        default:
            break;
    }
    return imageName;
}

- (void)leftBtnClicked:(id)sender {
    UINavigationController *nc = self.navigationController;
    if ([self.tabBarController.parentViewController isKindOfClass:[UINavigationController class]]) {
        nc = (UINavigationController*)self.tabBarController.parentViewController;
    }
    [nc popViewControllerAnimated:YES];
}

- (void)rightBtnClicked:(id)sender {
    
}

@end
