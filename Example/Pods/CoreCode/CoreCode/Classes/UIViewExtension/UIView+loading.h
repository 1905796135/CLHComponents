//
//  UIView+loading.h
//  OneStoreFramework
//
//  Created by Aimy on 14/10/30.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (loading)

/**
 *  功能:显示loading (菊花转)
 */
- (void)showLoading;

/**
 *  功能:显示在View 中间显示一段文描 message
 */
- (void)showLoadingWithMessage:(NSString *)message;

/**
 *  功能:显示在View 中间显示一段文描 message second秒后消失
 */
- (void)showLoadingWithMessage:(NSString *)message hideAfter:(NSTimeInterval)second;
/**
 *  功能:显示在View 中间显示一段文描 message second秒后消失 isModal 文描是否可点击
 */
- (void)showLoadingWithMessage:(NSString *)message hideAfter:(NSTimeInterval)second isModal:(BOOL)isModal;

/**
 *  功能:隐藏loading
 */
- (void)hideLoading;

@end
