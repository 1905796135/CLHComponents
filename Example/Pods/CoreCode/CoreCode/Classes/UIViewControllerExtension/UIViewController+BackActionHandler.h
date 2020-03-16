//
//  UIViewController+BackActionHandler.h
//  PBKit
//
//  Created by Jerry on 16/9/23.
//  Copyright © 2016年 core. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackActionHandlerProtocol <NSObject>

@optional
-(BOOL)navigationShouldPopOnBackButtonClicked;

@end

@interface UIViewController (BackActionHandler)<BackActionHandlerProtocol>

@end
