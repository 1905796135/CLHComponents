//
//  BaseCustomLineLabel.m
//  OneStoreFramework
//
//  Created by Aimy on 9/12/14.
//  Copyright (c) 2014 OneStore. All rights reserved.
//

#import "LineationLabel.h"

@implementation LineationLabel

- (id)init {
    self = [super init];
    if (self) {
        self.adjustsFontSizeToFitWidth = YES;
    }

    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.adjustsFontSizeToFitWidth = YES;
        self.textColor = [UIColor grayColor];
        self.lineType = LineationLabelLineTypeMiddle;
    }
    return self;
}

- (void)setLineType:(LineationLabelLineType)lineType {
    _lineType = lineType;
    [self setNeedsDisplay];
}
- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    [self setNeedsDisplay];
}
- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:rect];

    CGSize textSize = [[self text] sizeWithAttributes:@{NSFontAttributeName: self.font}];
    CGFloat strikeWidth = textSize.width;
    CGRect lineRect;
    CGFloat origin_x;
    CGFloat origin_y = 0.f;

    if ([self textAlignment] == NSTextAlignmentRight) {
        origin_x = rect.size.width - strikeWidth;
    } else if ([self textAlignment] == NSTextAlignmentCenter) {
        origin_x = (rect.size.width - strikeWidth) / 2;
    } else {
        origin_x = 0;
    }
    if (self.lineType == LineationLabelLineTypeNone) {
        origin_y = -10;
    }

    if (self.lineType == LineationLabelLineTypeUp) {
        origin_y = 2;
    }

    if (self.lineType == LineationLabelLineTypeMiddle) {
        origin_y = rect.size.height / 2;
    }

    if (self.lineType == LineationLabelLineTypeDown) {//下画线
        origin_y = rect.size.height - 2;
    }

    lineRect = CGRectMake(origin_x, origin_y, strikeWidth, 1);
    if (self.lineType != LineationLabelLineTypeNone) {

        CGContextRef context = UIGraphicsGetCurrentContext();
        CGFloat R, G, B, A;
        UIColor *uiColor = self.textColor;
        CGColorRef color = _lineColor?_lineColor.CGColor:[uiColor CGColor];
        size_t numComponents = CGColorGetNumberOfComponents(color);

        if (numComponents == 4) {
            const CGFloat *components = CGColorGetComponents(color);
            R = components[0];
            G = components[1];
            B = components[2];
            A = components[3];
            CGContextSetRGBFillColor(context, R, G, B, A);
        }

        CGContextFillRect(context, lineRect);
    }
}

@end
