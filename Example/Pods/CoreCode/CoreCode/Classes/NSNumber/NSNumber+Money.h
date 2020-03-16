//
//  NSNumber+Format.h
//  OneStoreFramework
//
//  Created by airspuer on 14-9-22.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSNumber (Money)

/**
 *	功能:NSNumber类型转换成显示金钱数据的字符串(保留两位有效数字，如果最后一位有效数字为0,则不显示)
 *
 *	@return 金钱数据的string
 */
- (NSString *)moneyFormatString;

/**
 *	功能:NSNumber类型转换成显示金钱数据的字符串(小数点后不留 0)
 *
 *	@return 金钱数据的string
 */
- (NSString *)moneyFormatStringWithoutZero;

/**
 *	功能:double类型数据转换成显示金钱数据的字符串(保留两位有效数字，如果最后一位有效数字为0,则不显示)
 *
 *	@return 金钱数据的string
 */
+ (NSString *)moneyFormat:(double)aValue;

+ (NSString *)valueFormat:(double)aValue;

/**
 能:double类型数据转换成留两位有效数字显示的字符串(只保留一个有效位0)

 @param aValue aValue description
 @return return value description
 */
+ (NSString *)valueFormatWithZero:(double)aValue;

/**
 *  功能:重量字符串，单位kg
 */
+ (NSString *)weightFormat:(double)aValue;

@end
