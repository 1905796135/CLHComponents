//
//  CoreAlertController.m
//  OneStoreBase
//
//  Created by Jiang on 16/12/5.
//  Copyright © 2016年 OneStoreBase. All rights reserved.
//

#import "CoreAlertController.h"

@interface CoreAlertController ()

@property(nonatomic, copy) CoreAlertControllerBlock block;

@end

@implementation CoreAlertController

+ (CoreAlertController *)alertWithMessage:(NSString *)message
                        andCompleteBlock:(CoreAlertControllerBlock)completeBlock {

    return [self alertWithTitle:nil message:message
               andCompleteBlock:completeBlock];
}

+ (CoreAlertController *)alertWithTitle:(NSString *)title
                               message:(NSString *)message
                      andCompleteBlock:(CoreAlertControllerBlock)completeBlock {

    return [self alertWithTitle:title message:message leftButtonTitle:@"确定" rightButtonTitle:nil andCompleteBlock:completeBlock];
}

+ (CoreAlertController *)alertWithTitle:(NSString *)title
                               message:(NSString *)message
                       leftButtonTitle:(NSString *)leftButtonTitle
                      rightButtonTitle:(NSString *)rightButtonTitle
                      andCompleteBlock:(CoreAlertControllerBlock)completeBlock {
    return [self alertWithTitle:title
                        message:message
                leftButtonTitle:leftButtonTitle
               rightButtonTitle:rightButtonTitle
                 rightHighlight:NO
               andCompleteBlock:completeBlock];
}
+ (CoreAlertController *)alertWithTitle:(NSString *)title
                               message:(NSString *)message
                       leftButtonTitle:(NSString *)leftButtonTitle
                      rightButtonTitle:(NSString *)rightButtonTitle
                        rightHighlight:(BOOL)isRightHighlight
                      andCompleteBlock:(CoreAlertControllerBlock)completeBlock {
    NSAssert((!title) || [title isKindOfClass:[NSString class]], @"title 类型不对!");
    NSAssert((!message) || [message isKindOfClass:[NSString class]], @"message类型不对!");
    NSAssert((!leftButtonTitle) || [leftButtonTitle isKindOfClass:[NSString class]], @"title 类型不对!");
    NSAssert((!rightButtonTitle) || [rightButtonTitle isKindOfClass:[NSString class]], @"message类型不对!");

    if (title && ![title isKindOfClass:[NSString class]]) {
        return nil;
    }
    if (message && ![message isKindOfClass:[NSString class]]) {
        return nil;
    }
    if (leftButtonTitle && ![leftButtonTitle isKindOfClass:[NSString class]]) {
        leftButtonTitle = nil;
    }
    if (!leftButtonTitle) {
        leftButtonTitle = @"确定";
    }
    if (rightButtonTitle && ![rightButtonTitle isKindOfClass:[NSString class]]) {
        return nil;
    }

    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.1 && title == nil && message != nil) {//iOS 8的设备 如果只有 message 没有 title 会导致 message的提示 顶在顶部,不居中,比较丑陋
        title = message;
        message = nil;
    }
    CoreAlertController *alertController = [CoreAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    if (leftButtonTitle) {
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:leftButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            if (completeBlock) {
                completeBlock( 0);
            }
        }];
        [alertController addAction:cancelButton];
    }

    if (rightButtonTitle) {
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:rightButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if (completeBlock) {
                completeBlock(1);
            }
        }];
        [alertController addAction:okButton];
        if (isRightHighlight && [alertController respondsToSelector:@selector(setPreferredAction:)]) {
            if (@available(iOS 9.0, *)) {
                alertController.preferredAction = okButton;
            } else {
                // Fallback on earlier versions
            }
        }
    }
    [[[CoreAlertController window] rootViewController] presentViewController:alertController animated:YES completion:nil];
    return alertController;
}
+ (CoreAlertController *)alertSheetWithTitle:(NSString *)title
                                     message:(NSString *)message
                                     actions:(NSArray <NSString *>*)actionTitles
                            andCompleteBlock:(CoreAlertControllerBlock)completeBlock {
    return [self alertSheetWithTitle:title
                             message:message
                             actions:actionTitles
                         cancleTitle:@"取消"
                    andCompleteBlock:completeBlock];
}
+ (CoreAlertController *)alertSheetWithTitle:(NSString *)title
                                     message:(NSString *)message
                                     actions:(NSArray <NSString *>*)actionTitles
                                 cancleTitle:(NSString *)cancleTitle
                            andCompleteBlock:(CoreAlertControllerBlock)completeBlock {
    
    NSAssert((!title) || [title isKindOfClass:[NSString class]], @"title 类型不对!");
    NSAssert((!message) || [message isKindOfClass:[NSString class]], @"message类型不对!");
    NSAssert((!actionTitles) || [actionTitles isKindOfClass:[NSArray<NSString*> class]], @"actionTitles类型不对!");
    NSAssert((!cancleTitle) || [cancleTitle isKindOfClass:[NSString class]], @"cancleTitle类型不对!");
    
    CoreAlertController *alertController = [CoreAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (actionTitles.count > 0) {
        for (int index = 0; index < actionTitles.count; index ++ ) {
            NSString *actionTitle = [actionTitles objectAtIndex:index];
           
            UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (completeBlock) {
                    completeBlock(index);
                }
            }];
            [alertController addAction:action];
        }
        
    }
    
    if (cancleTitle && cancleTitle.length > 0) {
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:cancleTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            if (completeBlock) {
                completeBlock(-1);
            }
        }];
        [alertController addAction:cancle];
    }
    [[[CoreAlertController window] rootViewController] presentViewController:alertController animated:YES completion:nil];
    return alertController;
}

+ (UIWindow *)window {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (@available(iOS 13.0, *)) {
        if ([CoreAlertController multipleScene] ){
            for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
                if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                    window = windowScene.windows.firstObject;
                    break;
                }
            }
        } else {
            if (window == nil) {
                if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(window)]) {
                    window = [[UIApplication sharedApplication].delegate window];
                }
            }
        }
    } else {
        if (window == nil) {
            if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(window)]) {
                window = [[UIApplication sharedApplication].delegate window];
            }
        }
    }
    return window;
}

+ (BOOL)multipleScene {
    NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
    if ([infoDict objectForKey:@"UIApplicationSceneManifest"]) {
        return YES;
    } else {
        return NO;
    }
}

@end
