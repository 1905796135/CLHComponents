//
//  WaterMarkView.h
//  HWIMDome
//
//  Created by 曹连华 on 2020/1/9.
//  Copyright © 2020 曹连华. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WaterMarkView : UIImageView

/**
 设置水印

 @param frame 水印大小
 @param text 水印显示的文字
 */
- (instancetype)initWithFrame:(CGRect)frame
                     withText:(NSString *)text;
/**
设置水印
@param textFont 水印文字 字体
@param textColor 水印文字 颜色
@param h_space 水平间距
@param v_space 竖直间距
*/
- (instancetype)initWithFrame:(CGRect)frame
                     withText:(NSString *)text
                     textFont:(UIFont *)textFont
                    textColor:(UIColor *)textColor
                      h_space:(CGFloat)h_space
                      v_space:(CGFloat)v_space;
/**
设置水印
@param transform_rotation 旋转角度
*/
- (instancetype)initWithFrame:(CGRect)frame
                     withText:(NSString *)text
                     textFont:(UIFont *)textFont
                    textColor:(UIColor *)textColor
                      h_space:(CGFloat)h_space
                      v_space:(CGFloat)v_space
           transform_rotation:(CGFloat)transform_rotation;
@end

NS_ASSUME_NONNULL_END
