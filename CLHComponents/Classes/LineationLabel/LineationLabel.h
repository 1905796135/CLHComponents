//
//  BaseCustomLineLabel.h
//  OneStoreFramework
//
//  Created by Aimy on 9/12/14.
//  Copyright (c) 2014 OneStore. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LineationLabelLineTypeNone,//没有画线
    LineationLabelLineTypeUp,// 上边画线
    LineationLabelLineTypeMiddle,//中间画线,默认
    LineationLabelLineTypeDown,//下边画线
} LineationLabelLineType;

/**
 *  显示划去横线的label
 */
@interface LineationLabel : UILabel
/**
 *  划去横线的位置
 */
@property(nonatomic) LineationLabelLineType lineType;

/**
*  划去横线的颜色
*/
@property(nonatomic, strong) UIColor *lineColor;

@end
