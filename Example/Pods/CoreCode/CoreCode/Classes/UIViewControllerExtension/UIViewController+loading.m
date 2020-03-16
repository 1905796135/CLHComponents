//
//  UIViewController+loading.m
//  OneStoreFramework
//
//  Created by Aimy on 14-7-30.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "UIViewController+loading.h"
#import "UIView+loading.h"

@implementation UIViewController (loading)

#pragma mark - loading

- (void)showLoading {
    [self.view showLoadingWithMessage:nil];
}

- (void)showLoadingWithMessage:(NSString *)message {
    [self.view showLoadingWithMessage:message];
}

- (void)showLoadingWithMessage:(NSString *)message hideAfter:(NSTimeInterval)second {
    [self.view showLoadingWithMessage:message hideAfter:second];
}

- (void)hideLoading {
    [self.view hideLoading];
}

@end
