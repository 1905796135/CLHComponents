//
//  UIViewController+custom.h
//  OneStoreFramework
//
//  Created by Aimy on 14-7-30.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BarButtonItem) {
    BarButtonItemNone = 0,        //空的，无图片
    BarButtonItemSearch,          //搜索
    BarButtonItemReturnHome,      //返回首页
    BarButtonItemSetting,         //设置
    BarButtonItemFavorite,        //收藏
    BarButtonItemShare,           //分享
    BarButtonItemRockNow,         //摇一摇
    BarButtonItemScan,            //扫描
    BarButtonItemCategory,        //分类
    BarButtonItemLogo,            //logo
    BarButtonItemReturn,          //返回上一页
    BarButtonItemAddWhite,        //白色添加按钮
};

typedef NS_ENUM(NSUInteger, BarButtonItemPosition) {
    BarButtonItemPositionRight,
    BarButtonItemPositionLeft
};

@interface UIViewController (BarButtonItem)

//设置按钮类型（图片）
- (void)setNaviButtonType:(BarButtonItem)aType position:(BarButtonItemPosition)position;

//设置按钮文字
- (void)setNaviButtonText:(NSString *)aText tintColor:(UIColor *)tintColor position:(BarButtonItemPosition)position;

//上下布局的按钮，上面图片，下面文字
- (void)setUpdownLayoutNaviButtonType:(BarButtonItem)aType
                                 text:(NSString *)aText
                                 href:(NSString *)aHref
                                items:(NSArray *)aItems
                             position:(BarButtonItemPosition)position;

//自定义返回按钮，点击调用 leftBtnClicked:
- (void)setNaviBackButtonWithImageName:(NSString*)imageName;

//自定义多个左侧按钮（e.g. back & home）, 点击调用 leftBtnClicked:
- (void)setNaviBackButtonWithImageNameArray:(NSArray<NSString*>*)imageNameArray;

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
