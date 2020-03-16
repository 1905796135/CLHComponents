//
//  LoopView.m
//  StudyDemo
//
//  Created by qiager on 2018/3/22.
//  Copyright © 2018年 yangka. All rights reserved.
//

#import "DataRoundLoopView.h"

@implementation DataRoundLoopModel

- (CGFloat)ratio {
    if (self.value.floatValue <= 0.f || self.total.floatValue <= 0.f) {
        return 0.0;
    }
    
    return self.value.floatValue/self.total.floatValue;
}

- (CGFloat)angle {
    return  self.ratio*360;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        if ([dict objectForKey:@"name"] && [[dict objectForKey:@"name"] isKindOfClass:[NSString class]]) {
            self.name = [dict objectForKey:@"name"];
        }
        
        if ([dict objectForKey:@"value"] && [[dict objectForKey:@"value"] isKindOfClass:[NSNumber class]]) {
            self.value = [dict objectForKey:@"value"];
        }
        
        if ([dict objectForKey:@"total"] && [[dict objectForKey:@"total"] isKindOfClass:[NSNumber class]]) {
            self.total = [dict objectForKey:@"total"];
        }
        
        if ([dict objectForKey:@"color"] && [[dict objectForKey:@"color"] isKindOfClass:[UIColor class]]) {
            self.color = [dict objectForKey:@"color"];
        } else {
            self.color = [UIColor colorWithRed:207.f/255.f green:207.f/255.f blue:207.f/255.f alpha:1];//默认灰色
        }
        
    }
    return self;
}

+ (DataRoundLoopModel *)defoutModel {
    DataRoundLoopModel *model0 = [[DataRoundLoopModel alloc]initWithDictionary:@{@"name":@"",
                                                                                 @"value":@(25),
                                                                                 @"total":@(100)}];
    return model0;
}

@end

@interface DataRoundLoopView() {
    
    CGFloat _lineWidth;
    NSArray *_colors;
    CGFloat _lWidth;
    CGFloat _lHeight;
    CGFloat _brokenLine;//折线长度（两个点直接的距离）
    NSString * _fontName;
    CGFloat _fontSize;
    BOOL _defout;
    BOOL _isSpace;
}

@property (nonatomic, strong) NSMutableArray<DataRoundLoopModel *> *models;

@end

@implementation DataRoundLoopView


- (NSMutableArray<DataRoundLoopModel *> *)models {
    if (!_models) {
        _models = [NSMutableArray<DataRoundLoopModel *> arrayWithArray:@[[DataRoundLoopModel defoutModel],[DataRoundLoopModel defoutModel],[DataRoundLoopModel defoutModel],[DataRoundLoopModel defoutModel]]];
    }
    return _models;
}

- (instancetype)initWithFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth {
    self = [super initWithFrame:frame];
    if (self) {
        _lineWidth = lineWidth;
        _brokenLine = 15;
        _defout = YES;
        _isSpace = YES;
        _fontName = @"PingFangSC-Medium";
        _fontSize = 13;
        [self setLineWidth:30 height:30];
    }
    return self;
}

- (void)updateWithModels:(NSArray<DataRoundLoopModel *> *)models {
    if (models.count > 0) {
        [self.models removeAllObjects];
        [self.models addObjectsFromArray:models];
        _defout = NO;
    } else {
        self.models = nil;
        _defout = YES;
    }
    
    [self draw];
}

- (void)setLineWidth:(CGFloat)lWidth height:(CGFloat)lHeight {
    _lWidth = lWidth;
    _lHeight = lHeight;
}

- (void)setTextFontName:(NSString *)fontName fontSize:(CGFloat)fontSize {
    if([UIFont fontWithName:fontName size:fontSize]) {
        _fontName = fontName;
        _fontSize = fontSize;
    }
}
- (void)setIsSpace:(BOOL)isSpace {
    _isSpace = isSpace;
}

- (void)draw {
    
    if (self.models.count <= 0) {
        return;
    }
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CGFloat radius = self.frame.size.width/2;
    
    CGFloat start = 0;
    for (int i = 0; i < self.models.count; i++) {
        
        DataRoundLoopModel *model = self.models[i];
        
        CGFloat startAngle = [self angleForValue:start] + ((_isSpace&&!_defout)?0.025:0);
        start += model.angle;
        CGFloat endAngle  = [self angleForValue:start];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.frame = self.bounds;
        shapeLayer.lineWidth = _lineWidth;
        UIColor *color = model.color;
        shapeLayer.strokeColor = color.CGColor;
        shapeLayer.fillColor = nil;
        shapeLayer.shadowColor = [UIColor colorWithRed:181.0f/255.0f green:181.0f/255.0f blue:181.0f/255.0f alpha:0.4f].CGColor;
        shapeLayer.shadowRadius = 3.f;
        if(!_defout) {
            shapeLayer.shadowOpacity = 1.0f;
            shapeLayer.shadowOffset = CGSizeMake(0, 3);
        }

        [self.layer addSublayer:shapeLayer];
        
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                            radius:radius - _lineWidth/2
                                                        startAngle:startAngle
                                                          endAngle:endAngle
                                                         clockwise:YES];
        shapeLayer.path = path.CGPath;
        
        CGFloat angle = startAngle + (endAngle - startAngle)/2;
        BOOL isLeft = ( angle > 7.853982);
        
        //折线
        CGPoint point1 = [self positionForCenter:center radius:radius angle:angle];//以整个圆环为参照物 折线起点
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        lineLayer.frame = CGRectMake(point1.x - _lWidth/2, point1.y - _lHeight/2, _lWidth, _lHeight);
        lineLayer.fillColor = nil;
        lineLayer.strokeColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1].CGColor;
        if (_defout) {
            if (i == 0) {
                [self.layer addSublayer:lineLayer];
            }
        } else {
            [self.layer addSublayer:lineLayer];
        }
        
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        CGPoint linePoint1 = CGPointMake(_lWidth/2, _lHeight/2);//以 lineLayer 为参照 折线起点（是lineLayer的中心点）
        [linePath moveToPoint:linePoint1];
        
        CGPoint linePoint2 = [self positionForCenter:linePoint1 radius:_brokenLine angle:angle];//以 lineLayer 为参照 折线第二个点
        [linePath addLineToPoint:linePoint2];
        
        CGPoint linePoint3 = CGPointZero;//以 lineLayer 为参照 折线第三个点
        if (isLeft) {
            linePoint3 = CGPointMake(linePoint2.x - _brokenLine , linePoint2.y);
            [linePath addLineToPoint:linePoint3];
        } else {
            linePoint3 = CGPointMake(linePoint2.x + _brokenLine, linePoint2.y);
            [linePath addLineToPoint:linePoint3];
        }
        lineLayer.path = linePath.CGPath;
        
        //边框
        CATextLayer *textLayer = [CATextLayer layer];
        NSString *string = [NSString stringWithFormat:@"%.f%%",model.ratio*100];
        if (_defout) {
            textLayer.string = @"0%";
        } else {
            textLayer.string = string;
        }
        textLayer.font = CFBridgingRetain(_fontName);
        textLayer.fontSize = _fontSize;
        textLayer.wrapped = YES;
        textLayer.contentsScale = 2;
        textLayer.foregroundColor = [UIColor blackColor].CGColor;
        if (_defout) {
            if (i == 0) {
                [shapeLayer addSublayer:textLayer];
            }
        } else {
            [shapeLayer addSublayer:textLayer];
        }
        
        CGSize textSize = [textLayer.string sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:_fontName size:_fontSize]}];
        CGPoint point2 = [self positionForCenter:center radius:radius+_brokenLine angle:angle];//以整个圆环为参照物 折线第二个点
        CGPoint point3 = CGPointZero;//以整个圆环为参照物 折线第三个点
        if (isLeft) {
            point3 = CGPointMake(point2.x - _brokenLine, point2.y);
            textLayer.frame = CGRectMake(point3.x - textSize.width, point3.y - textSize.height, textSize.width, textSize.height);
            textLayer.alignmentMode = @"right";
        } else {
            point3 = CGPointMake(point2.x + _brokenLine, point2.y);
            textLayer.frame = CGRectMake(point3.x, point3.y - textSize.height, textSize.width, textSize.height);
            textLayer.alignmentMode = @"left";
        }
    }
}

- (CGFloat)angleForValue:(CGFloat)value{
    value = 360 + (value - 90);
    return value*(M_PI/180);
}

- (CGPoint)positionForCenter:(CGPoint)center radius:(CGFloat)radius angle:(CGFloat)angle{
    CGFloat x = radius*cosf(angle);
    CGFloat y = radius*sinf(angle);
    return CGPointMake(center.x + x, center.y + y);
}

@end

