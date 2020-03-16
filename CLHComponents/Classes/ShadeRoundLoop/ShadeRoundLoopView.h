//
//  ShadeRoundLoopView.h
//  CoreCode
//
//  Created by 曹连华 on 2019/3/29.
//  Copyright © 2019 曹连华. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShadeRoundLoopView : UIView

- (instancetype)initWithFrame:(CGRect)frame progressValue:(CGFloat)progress;

/**
 * 设置进度环 颜色
 * 渐变色环 需要传入至少三个 不同颜色
 * 单色环  需要传入至少两个相同颜色
 * bgProgressColor 背景环颜色
 */
- (void)setProgressColors:(NSArray<UIColor*>*)colors bgProgressColor:(UIColor *)bgProgressColor;


/**
 * progressWidth 进度环宽度
 * bgWidth 背景环宽度
 */
- (void)setProgressWidth:(CGFloat)progressWidth bgWidth:(CGFloat)bgWidth;

/**
 * 设置动画时间
 */
- (void)setAnimationDuration:(CGFloat)duration;

/**
 * 设置进度条 两端 是否圆角
 * lineCap Options are `butt', `round' and `square'. Defaults to `round'.
 *
 */
- (void)setLineCapStr:(NSString *)lineCap;

/**
 * progressValue 进度值 0~1
 */
- (void)updateProgress:(CGFloat)progressValue;

@end

NS_ASSUME_NONNULL_END
