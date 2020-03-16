//
//  NSObject+safe.h
//  OneStoreFramework
//
//  Created by Aimy on 14/11/26.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (Safe)

/**
 *  转换成nsstring－》nsnumber
 *
 *  @return NSnumber
 */
- (NSNumber *)toNumberIfNeeded;

@end
