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

@property (nonatomic, assign) BOOL autoAnimation; // 设置是否需要动画
@property (nonatomic, assign) CGFloat duration;//动画时间

/*
 * 设置进度条 两端 是否圆角 lineCap Options are `butt', `round' and `square'. Defaults to `round'.
 */
@property (nonatomic, strong) NSString *lineCap;
@property (nonatomic, assign) CGFloat progressLineWidth;//进度环 宽度
@property (nonatomic, assign) CGFloat lineWidth;//背景环 宽度
/**
 * progress 0.0~1.0
 * loopWidth 环的宽度
 */
- (instancetype)initWithFrame:(CGRect)frame progress:(CGFloat)progress lineWidth:(CGFloat)lineWidth;

/**
 * 设置进度环 颜色
 * 渐变色环 需要传入至少三个 不同颜色
 * 单色环  需要传入至少两个相同颜色
 * bgProgressColor 背景环颜色
 */
- (void)setProgressColors:(NSArray<UIColor*>*)colors bgProgressColor:(UIColor *)bgProgressColor;


/**
 * progressLineWidth 进度环宽度
 * lineWidth 背景环宽度
 */
- (void)setProgressLineWidth:(CGFloat)progressLineWidth lineWidth:(CGFloat)lineWidth;

/**
 * progressValue 进度值 0~1
 */
- (void)updateProgress:(CGFloat)progressValue;

@end

NS_ASSUME_NONNULL_END
