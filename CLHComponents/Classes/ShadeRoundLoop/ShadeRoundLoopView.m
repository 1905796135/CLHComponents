//
//  ShadeRoundLoopView.m
//  CoreCode
//
//  Created by 曹连华 on 2019/3/29.
//  Copyright © 2019 曹连华. All rights reserved.
//

#import "ShadeRoundLoopView.h"

@interface ShadeRoundLoopView () {
    UIBezierPath* _bottomPath;
    UIColor* _bgProgressColor;//背景环颜色
    UIColor* _color0;
    UIColor* _color1;
    UIColor* _color2;
    NSMutableArray *_progressColors;
    CGFloat _radius;//半径
    CGPoint _center;//圆心
    CGFloat _progressValue;//进度值
    CGFloat _aWidth;
    CGFloat _aHeight;
}

@end

@implementation ShadeRoundLoopView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame progress:0.0 lineWidth:5.0];
}

- (instancetype)initWithFrame:(CGRect)frame progress:(CGFloat)progress lineWidth:(CGFloat)lineWidth {
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultDataWithProgress:progress lineWidth:lineWidth];
    }
    return self;
}

- (void)setDefaultDataWithProgress:(CGFloat)progress lineWidth:(CGFloat)lineWidth {
    self.lineCap = @"round";
    self.duration = 2.0;
    self.lineWidth = 5.0f;
    self.progressLineWidth = 5.0f;
    self.autoAnimation = NO;
    
    _aWidth = CGRectGetWidth(self.frame);
    _aHeight = CGRectGetHeight(self.frame);
    
    _bgProgressColor = [UIColor groupTableViewBackgroundColor];
    _radius = _aWidth*0.5-self.progressLineWidth*0.5-0.5;
    _center = CGPointMake(_aWidth * 0.5, _aHeight * 0.5);
        
    
    _progressColors = [NSMutableArray array];
    UIColor *color0 = [UIColor colorWithRed:247.0 / 255.0 green:215.0 / 255.0 blue:109.0 / 255.0 alpha:1.0];
    UIColor *color1 = [UIColor colorWithRed:248.0 / 255.0 green:160.0 / 255.0 blue:60.0 / 255.0 alpha:1.0];
    UIColor *color2 = [UIColor colorWithRed:224.0 / 255.0 green:123.0 / 255.0 blue:52.0 / 255.0 alpha:1.0];
        
    
    [_progressColors addObject:(id)color0.CGColor];
    [_progressColors addObject:(id)color1.CGColor];
    [_progressColors addObject:(id)color2.CGColor];
    
    [self updateProgress:progress];
    
}
    

- (void)setProgressColors:(NSArray<UIColor*>*)colors bgProgressColor:(UIColor *)bgProgressColor {
    if (bgProgressColor) {
        _bgProgressColor = bgProgressColor;
    }
    if (colors && colors.count > 0) {
        [_progressColors removeAllObjects];
        for (UIColor *item  in colors) {
            [_progressColors addObject:(id)item.CGColor];
        }
    }
}
    
- (void)setProgressLineWidth:(CGFloat)progressLineWidth lineWidth:(CGFloat)lineWidth {
    self.lineWidth = lineWidth;
    self.progressLineWidth = progressLineWidth;
    _radius = _aWidth*0.5-self.progressLineWidth*0.5-0.5;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _aWidth = CGRectGetWidth(self.bounds);
    _aHeight = CGRectGetHeight(self.bounds);
    _radius = _aWidth*0.5-self.progressLineWidth*0.5-0.5;
    _center = CGPointMake(_aWidth * 0.5, _aHeight * 0.5);
}
    

- (void)updateProgress:(CGFloat)progressValue {
    [self clearAllBezierPath];
    _progressValue = progressValue * 2*M_PI + 1.5*M_PI;//当前进度值
    if (_bottomPath == nil) {
        UIBezierPath* bottomPath = [UIBezierPath bezierPathWithArcCenter:_center radius:_radius startAngle:-M_PI_2 endAngle:M_PI * 2 clockwise:YES];
        CAShapeLayer* shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = bottomPath.CGPath;
        shapeLayer.lineWidth = self.lineWidth;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeColor = _bgProgressColor.CGColor;
        [self.layer addSublayer:shapeLayer];
        _bottomPath = bottomPath;
    }
    
    UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:_center radius:_radius startAngle:1.5*M_PI endAngle:_progressValue clockwise:YES];
    CAShapeLayer* gressLayer = [CAShapeLayer layer];
    gressLayer.path = path.CGPath;
    gressLayer.lineCap = self.lineCap;
    gressLayer.lineWidth = self.progressLineWidth;
    gressLayer.fillColor = [UIColor clearColor].CGColor;
    gressLayer.strokeColor = [UIColor blueColor].CGColor;
    CAGradientLayer* grad1 = [CAGradientLayer layer];
    grad1.mask = gressLayer;
    grad1.frame = CGRectMake(0, 0,_aWidth, _aHeight);
    grad1.colors = _progressColors;
    grad1.locations=@[@0.25f,@0.5f,@0.75f];
    grad1.startPoint = CGPointMake(1, -0.5);
    grad1.endPoint = CGPointMake(0, 0);
    [self.layer addSublayer:grad1];
    if (self.autoAnimation) {
        [self showAnimationWith:gressLayer];
    }
}
    
    

- (void)showAnimationWith:(CAShapeLayer*)layer {
    CABasicAnimation *ani = [ CABasicAnimation animationWithKeyPath : NSStringFromSelector ( @selector (strokeEnd))];
    ani.fromValue = @0;
    ani.toValue = @1;
    ani.duration = self.duration;
    [layer addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];
}

- (void)clearAllBezierPath {
    [self.layer removeAllAnimations];
    _bottomPath = nil;
}

@end
