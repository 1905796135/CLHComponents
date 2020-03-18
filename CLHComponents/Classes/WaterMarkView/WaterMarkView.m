#import "WaterMarkView.h"

@implementation WaterMarkView

- (instancetype)initWithFrame:(CGRect)frame withText:(NSString *)text {
    self = [self initWithFrame:frame withText:text textFont:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithRed:152.0 / 255.0 green:152.0 / 255.0 blue:152.0 / 255.0 alpha:0.3] h_space:80 v_space:80];
    if (self){
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
                     withText:(NSString *)text
                     textFont:(UIFont *)textFont
                    textColor:(UIColor *)textColor
                      h_space:(CGFloat)h_space
                      v_space:(CGFloat)v_space {
    self = [self initWithFrame:frame withText:text textFont:textFont textColor:textColor h_space:h_space v_space:v_space transform_rotation:-M_PI_2/3];
    if (self) {
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
                     withText:(NSString *)text
                     textFont:(UIFont *)textFont
                    textColor:(UIColor *)textColor
                      h_space:(CGFloat)h_space
                      v_space:(CGFloat)v_space
           transform_rotation:(CGFloat)transform_rotation {
    self = [super initWithFrame:frame];
    if (self) {
        
        UIFont *font = textFont;
        
        UIColor *color = textColor;
        
        //原始image的宽高
        CGFloat viewWidth = frame.size.width;
        CGFloat viewHeight = frame.size.height;
        
        //为了防止图片失真，绘制区域宽高和原始图片宽高一样
        UIGraphicsBeginImageContext(CGSizeMake(viewWidth, viewHeight));
        
        //sqrtLength：原始image的对角线length。在水印旋转矩阵中只要矩阵的宽高是原始image的对角线长度，无论旋转多少度都不会有空白。
        CGFloat sqrtLength = sqrt(viewWidth*viewWidth + viewHeight*viewHeight);
        //文字的属性
        NSDictionary *attr = @{
            //设置字体大小
            NSFontAttributeName: font,
            //设置文字颜色
            NSForegroundColorAttributeName :color,
        };
        NSString* mark = text;
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:mark attributes:attr];
        //绘制文字的宽高
        CGFloat strWidth = attrStr.size.width;
        CGFloat strHeight = attrStr.size.height;
        
        //开始旋转上下文矩阵，绘制水印文字
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //将绘制原点（0，0）调整到原image的中心
        CGContextConcatCTM(context, CGAffineTransformMakeTranslation(viewWidth/2, viewHeight/2));
        //以绘制原点为中心旋转
        CGContextConcatCTM(context, CGAffineTransformMakeRotation(transform_rotation));
        //将绘制原点恢复初始值，保证当前context中心和源image的中心处在一个点(当前context已经旋转，所以绘制出的任何layer都是倾斜的)
        CGContextConcatCTM(context, CGAffineTransformMakeTranslation(-viewWidth/2, -viewHeight/2));
        
        //计算需要绘制的列数和行数
        int horCount = sqrtLength / (strWidth + h_space) + 1;
        int verCount = sqrtLength / (strHeight + v_space) + 1;
        
        //此处计算出需要绘制水印文字的起始点，由于水印区域要大于图片区域所以起点在原有基础上移
        CGFloat orignX = -(sqrtLength-viewWidth)/2;
        CGFloat orignY = -(sqrtLength-viewHeight)/2;
        
        //在每列绘制时X坐标叠加
        CGFloat tempOrignX = orignX;
        //在每行绘制时Y坐标叠加
        CGFloat tempOrignY = orignY;
        for (int i = 0; i < horCount * verCount; i++) {
            [mark drawInRect:CGRectMake(tempOrignX, tempOrignY, strWidth, strHeight) withAttributes:attr];
            if (i % horCount == 0 && i != 0) {
                tempOrignX = orignX;
                tempOrignY += (strHeight + v_space);
            }else{
                tempOrignX += (strWidth + h_space);
            }
        }
        //根据上下文制作成图片
        UIImage *finalImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGContextRestoreGState(context);
        
        self.image = finalImg;
    }
    
    return self;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    //1.判断自己能否接收事件
    if(self.userInteractionEnabled == NO || self.hidden == YES || self.alpha <= 0.01) {
        return nil;
    }
    //2.判断当前点在不在当前View.
    if (![self pointInside:point withEvent:event]) {
        return nil;
    }
    //3.从后往前遍历自己的子控件.让子控件重复前两步操作,(把事件传递给,让子控件调用hitTest)
    int count = (int)self.subviews.count;
    for (int i = count - 1; i >= 0; i--) {
        //取出每一个子控件
        UIView *chileV =  self.subviews[i];
        //把当前的点转换成子控件坐标系上的点.
        CGPoint childP = [self convertPoint:point toView:chileV];
        UIView *fitView = [chileV hitTest:childP withEvent:event];
        //判断有没有找到最适合的View
        if(fitView){
            return fitView;
        }
    }
    
    //4.没有找到比它自己更适合的View.那么它自己就是最适合的View
    return self;
}

//作用:判断当前点在不在它调用View,(谁调用pointInside,这个View就是谁)
//什么时候调用:它是在hitTest方法当中调用的.
//注意:point点必须得要跟它方法调用者在同一个坐标系里面
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    return NO;
}

@end

