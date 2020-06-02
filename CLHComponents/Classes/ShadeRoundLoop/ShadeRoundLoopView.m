//
//  ShadeRoundLoopView.m
//  CoreCode
//
//  Created by 曹连华 on 2019/3/29.
//  Copyright © 2019 曹连华. All rights reserved.
//

#import "ShadeRoundLoopView.h"
#define degreeToRadian(d) ((d)*M_PI)/180.0
#define rgb(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
@interface ShadeRoundLoopView () {
    CGFloat _progress;//进度值
}
@property (nonatomic, assign) CGFloat radius;//半径
@property (nonatomic, assign) CGPoint loopCenter;;//圆心
@property (nonatomic, assign) CGFloat lastProgress; /**<上次进度 0-1 */
@property (nonatomic, strong) UIBezierPath *lastProgressLoopPath;

@property (nonatomic, strong) CAShapeLayer *backLoopShapeLayer;
@property (nonatomic, strong) CAShapeLayer *progressShapeLayer;
@property (nonatomic, strong) CAGradientLayer *progressGradientLayer;

@end

@implementation ShadeRoundLoopView
- (CGFloat)radius {
    return CGRectGetWidth(self.frame)*0.5-self.progressLoopWidth*0.5-0.5;
}
- (CGPoint)loopCenter {
    return CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame) * 0.5);
}

- (CAShapeLayer *)backLoopShapeLayer {
    if (!_backLoopShapeLayer) {
        _backLoopShapeLayer = [CAShapeLayer layer];
        _backLoopShapeLayer.lineCap = self.lineCap;
        _backLoopShapeLayer.lineWidth = self.backLoopWidth;
        _backLoopShapeLayer.strokeColor = self.backLoopColor.CGColor;
        _backLoopShapeLayer.fillColor = self.fillColor.CGColor;
        
    }
    return _backLoopShapeLayer;
}
- (CAShapeLayer *)progressShapeLayer {
    if (!_progressShapeLayer) {
        _progressShapeLayer = [CAShapeLayer layer];
        _progressShapeLayer.lineCap = self.lineCap;
        _progressShapeLayer.lineWidth = self.progressLoopWidth;
        _progressShapeLayer.strokeColor = self.progressColors.firstObject.CGColor;
        _progressShapeLayer.fillColor = self.fillColor.CGColor;
        
    }
    return _progressShapeLayer;
}

- (CAGradientLayer *)progressGradientLayer {
    if (!_progressGradientLayer) {
        _progressGradientLayer = [CAGradientLayer layer];
        _progressGradientLayer.locations = @[@0.25f,@0.5f,@0.75f];
        _progressGradientLayer.startPoint = CGPointMake(1, -0.5);
        _progressGradientLayer.endPoint = CGPointMake(0, 0);
    }
    return _progressGradientLayer;
}

- (UIBezierPath *)backLoopPath {
    return [UIBezierPath bezierPathWithArcCenter:self.loopCenter radius:self.radius startAngle:self.startAngle endAngle:(2 * M_PI - self.reduceAngle + self.startAngle) clockwise:YES];
}

- (UIBezierPath *)progressLoopPath {
    BOOL clockwise = NO;
    if (self.progress < self.lastProgress && self.increaseFromLast) {
        clockwise = YES;
    }
    CGFloat startAngle = self.increaseFromLast?(2*M_PI - self.reduceAngle) * self.lastProgress + self.startAngle:self.startAngle;
    CGFloat endAngle = (2*M_PI - self.reduceAngle) * self.progress + self.startAngle;
    return [UIBezierPath bezierPathWithArcCenter:self.loopCenter radius:self.radius startAngle:startAngle endAngle:endAngle clockwise:!clockwise];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultData];
    }
    return self;
}

- (void)setDefaultData {
    self.lineCap = @"round";
    
    self.duration = 2.0;
    self.autoAnimation = NO;
    self.increaseFromLast = NO;
    self.startAngle = degreeToRadian(0);
    self.reduceAngle = degreeToRadian(0);
    
    self.fillColor = [UIColor clearColor];
    
    self.backLoopWidth = 5.0f;
    self.backLoopColor = rgb(233, 233, 233);
    
    self.progressLoopWidth = 5.0f;
    self.progressColors = @[rgb(247.0, 215.0, 109.0),rgb(248.0, 160.0, 60.0),rgb(224.0, 123.0, 52.0)];
   
    self.progress = 0.5f;
    
    self.progressGradientLayer.mask = self.progressShapeLayer;
    [self.layer addSublayer:self.backLoopShapeLayer];
    [self.layer addSublayer:self.progressShapeLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backLoopShapeLayer.path = [self backLoopPath].CGPath;
    self.progressShapeLayer.path  = [self progressLoopPath].CGPath;

    if (self.autoAnimation) {
        [self showAnimationWith:self.progressShapeLayer];
    }
    self.lastProgress = self.progress;
}

- (void)setLineCap:(NSString *)lineCap {
    _lineCap = lineCap;
    self.progressShapeLayer.lineCap = _lineCap;
    self.backLoopShapeLayer.lineCap = _lineCap;
}

- (void)setBackLoopWidth:(CGFloat)backLoopWidth {
    _backLoopWidth = backLoopWidth;
    self.backLoopShapeLayer.lineWidth = _backLoopWidth;
}

- (void)setBackLoopColor:(UIColor *)backLoopColor {
    _backLoopColor = backLoopColor;
    self.backLoopShapeLayer.strokeColor = _backLoopColor.CGColor;
}

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    self.backLoopShapeLayer.fillColor = _fillColor.CGColor;
    self.progressShapeLayer.fillColor = _fillColor.CGColor;
}

- (void)setProgressLoopWidth:(CGFloat)progressLoopWidth {
    _progressLoopWidth = progressLoopWidth;
    self.progressShapeLayer.lineWidth = _progressLoopWidth;
}

- (void)setProgressColors:(NSArray<UIColor *> *)progressColors{
    NSMutableArray *colors = [NSMutableArray array];
    if (progressColors && progressColors.count > 0) {
        for (UIColor *item  in progressColors) {
            [colors addObject:(id)item.CGColor];
        }
    }
    _progressColors = progressColors;
    self.progressShapeLayer.strokeColor = _progressColors.firstObject.CGColor;
    self.progressGradientLayer.colors = colors;
}

- (void)setProgress:(CGFloat)progress {
    _progress = MAX(MIN(1, progress), 0);
    [self setNeedsLayout];
    
}

- (void)setStartAngle:(CGFloat)startAngle {
    _startAngle = degreeToRadian(-startAngle);
}

- (void)setReduceAngle:(CGFloat)reduceAngle {
    if (reduceAngle>=360) {
        return;
    }
    _reduceAngle = degreeToRadian(reduceAngle);
}
- (void)showAnimationWith:(CAShapeLayer*)layer {
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = self.duration;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.fromValue = [NSNumber numberWithFloat:self.increaseFromLast ? self.lastProgress : 0];
    pathAnimation.toValue = [NSNumber numberWithFloat:self.progress];
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    [layer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
}

@end
