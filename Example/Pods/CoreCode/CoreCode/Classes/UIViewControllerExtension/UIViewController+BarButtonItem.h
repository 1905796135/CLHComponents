//
//  UIViewController+custom.h
//  OneStoreFramework
//
//  Created by Aimy on 14-7-30.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BarButtonItemPosition) {
    BarButtonItemPositionRight,
    BarButtonItemPositionLeft
};

@interface UIViewController (BarButtonItem)

/*
 * 设置单个 图片导航按钮
 * imageName 图片名称
 * position 按钮方向
 */
- (void)setNaviButtonWithImageName:(NSString *)imageName position:(BarButtonItemPosition)position;
/*
* 设置单个 图片导航按钮
* imageName 图片名称
* position 按钮位置
* isBgImage 是否设置为按钮背景图
*/
- (void)setNaviButtonWithImageName:(NSString *)imageName position:(BarButtonItemPosition)position isBgImage:(BOOL)isBgImage;
/*
* 设置多个 图片导航按钮
* imageNameArray 图片名称数组
* 点击调用 leftBtnClicked:
*/
- (void)setNaviBackButtonWithImageNameArray:(NSArray<NSString*>*)imageNameArray;

/*
* 设置单个 文字导航按钮
* text 文字
* tintColor 文字颜色
* position 按钮位置
*/
- (void)setNaviButtonText:(NSString *)text textColor:(UIColor *)textColor position:(BarButtonItemPosition)position;

//上下布局的按钮，上面图片，下面文字
- (void)setUpdownLayoutNaviButtonWithImageName:(NSString *)imageName
                                          text:(NSString *)aText
                                          href:(NSString *)aHref
                                         items:(NSArray *)aItems
                                      position:(BarButtonItemPosition)position;

//自定义返回按钮，点击调用 leftBtnClicked:
- (void)setNaviBackButtonWithImageName:(NSString*)imageName;



//左按钮点击行为，可在子类重写此方法
- (void)leftBtnClicked:(id)sender;

//右按钮点击行为，可在子类重写此方法
- (void)rightBtnClicked:(id)sender;

// 设置导航title
- (void)setNaivTitle:(NSString *)title;
- (void)setNaivTitle:(NSString *)title font:(UIFont *)font;
- (void)setNaivTitle:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor;

@end

@interface DataNaviBtn : UIButton

@property(nonatomic, copy) NSString *href;
@property(nonatomic, strong) NSArray *items;

@end

@interface UpdownLayoutNaviBtn : DataNaviBtn

@end
