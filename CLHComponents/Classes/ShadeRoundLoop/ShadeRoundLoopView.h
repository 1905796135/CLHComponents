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

/** 动画时间 */
@property (nonatomic, assign) CGFloat duration;

/** 是否需要动画 */
@property (nonatomic, assign) BOOL autoAnimation;

/** 进度值 0.0 ~ 1.0  */
@property (nonatomic, assign) CGFloat progress;

/** 进度环 宽度 */
@property (nonatomic, assign) CGFloat progressLoopWidth;

/** 进度环 颜色 传多个 支持 渐变色 */
@property (nonatomic, strong) NSArray<UIColor *> *progressColors;

/** 背景环 宽度 */
@property (nonatomic, assign) CGFloat backLoopWidth;

/** 背景环 颜色 */
@property (nonatomic, strong) UIColor *backLoopColor;

/** 环内 填充色 */
@property (nonatomic, strong) UIColor *fillColor;

/**  设置进度条 两端 是否圆角 lineCap Options are `butt', `round' and `square'. Defaults to `round'. */
@property (nonatomic, strong) NSString *lineCap;


/** < 起点角度。角度从水平右侧开始为0，传 正数 起点在水平线 上方  起点在水平线 下方  顺时针  */
@property (nonatomic, assign) CGFloat startAngle;

/**<减少的角度 直接传度数 如30*/
@property (nonatomic, assign) CGFloat reduceAngle;

/**<是否从上次数值开始动画，默认为NO */
@property (nonatomic, assign) BOOL increaseFromLast;


@end

NS_ASSUME_NONNULL_END
