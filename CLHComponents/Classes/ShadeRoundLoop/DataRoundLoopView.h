//
//  LoopView.h
//  StudyDemo
//
//  Created by qiager on 2018/3/22.
//  Copyright © 2018年 yangka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataRoundLoopModel : NSObject

@property (nonatomic, copy) NSString* name;

@property (nonatomic, strong) NSNumber *value;

@property (nonatomic, strong) NSNumber *total;

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, readonly, assign) CGFloat ratio;

@property (nonatomic, readonly, assign) CGFloat angle;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

+ (DataRoundLoopModel *)defoutModel;

@end

@interface DataRoundLoopView : UIView


- (instancetype)initWithFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth;

- (void)updateWithModels:(NSArray<DataRoundLoopModel *> *)models;

/*
* 设置折线上 文字 字体 大小
 */
- (void)setTextFontName:(NSString *)fontName fontSize:(CGFloat)fontSize;
/*
 * 设置折线 宽高
  */
- (void)setLineWidth:(CGFloat)lWidth height:(CGFloat)lHeight;

/*
 * 设置环与环衔接处 是否有间隙
 */
- (void)setIsSpace:(BOOL)isSpace;

- (void)draw;

@end
