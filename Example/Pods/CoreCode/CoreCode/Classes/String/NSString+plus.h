//
//  NSString+plus.h
//  OneStoreFramework
//
//  Created by Aimy on 8/27/14.
//  Copyright (c) 2014 OneStore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (plus)

/**
 *  NSString转为NSNumber
 *
 *  @return NSNumber
 */
- (NSNumber *)toNumber;

/**
 *  urlencoding
 *
 *  @return NSString
 */
- (NSString *)urlEncoding;

/**
 *  base64 编码
 *
 *  @return NSString
 */
- (NSString *)base64Encode;

/**
 *  base64 解码
 *
 *  @return NSString
 */
- (NSString *)base64Dencode;

/**
 *  url encoding所有字符
 *
 *  @return NSString
 */
- (NSString *)urlEncodingAllCharacter;

/**
 *  功能:拼装2个组合字串(知道首字串长度)
 */
- (NSAttributedString *)attributedStringWithHeadAttributes:(NSDictionary *)aAttributes
                                            tailAttributes:(NSDictionary *)bAttributes
                                                headLength:(NSUInteger)aLength;

/**
 *  功能:拼装2个组合字串(知道尾字串长度)
 */
- (NSAttributedString *)attributedStringWithHeadAttributes:(NSDictionary *)aAttributes
                                            tailAttributes:(NSDictionary *)bAttributes
                                                tailLength:(NSUInteger)aLength;
/**
 *  功能:从开头截取字符长度为 length 的文字。 ex: "测试test测试" length 为 5 的情况下返回 "测试t" length 为 9 返回“测试test”
 */
- (NSString *)stringClipByCharLength:(NSUInteger)charlength;

//计算一段字符串的长度，两个英文字符占一个长度。
+ (int)countTheStrLength:(NSString *)strtemp;

//计算一段字符串的字符长度 一个中文占两个字符长度
+ (int)countTheStrCharLength:(NSString *)strtemp;

//是否是纯int
- (BOOL)isPureInt;

/**是否是英/数字/常见的符号*/
- (BOOL)isENS;

/**是否是英/数字*/
- (BOOL)isEN;

/**是否是中文/英/数字*/
- (BOOL)isCEN;

/**
 *  功能:价格字符串小数点前后字体和颜色
 */
- (NSMutableAttributedString *)stringWithColor:(UIColor *)aColor
                                    symbolFont:(UIFont *)aSymbolFont
                                   integerFont:(UIFont *)aIntrgerFont
                                   decimalFont:(UIFont *)aDecimalFont;

/**
 *  功能:是否浮点型
 */
- (BOOL)isPureFloat;

/**
 *  功能:手机号码脱敏
 */
- (NSString *)phoneRidOfSensitivity:(NSString *)phone;

@end
