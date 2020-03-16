//
//  LMRModel.m
//  Service
//
//  Created by 曹连华 on 2019/9/23.
//  Copyright © 2019 曹连华. All rights reserved.
//

#import "LMRModel.h"
#import <CoreCode/CoreCode.h>
@implementation LMRModel

- (NSMutableDictionary *)routerParam {
    if (!_routerParam) {
        _routerParam = [NSMutableDictionary dictionary];
    }
    return _routerParam;
}

+ (LMRModel *)modelTitle:(NSString *)title
                    size:(CGSize)size {
    LMRModel *model = [LMRModel modelTitle:title size:size routerKey:nil routerParam:nil];
    model.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
    model.backgroundColor = rgb(233,238,248);
    model.textColor = rgb(25,66,102);
    return model;
}
+ (LMRModel *)modelTitle:(NSString *)title
               routerKey:(nullable NSString *)routerKey
             routerParam:(nullable NSDictionary *)routerParam {
    return [LMRModel modelTitle:title size:CGSizeZero routerKey:routerKey routerParam:routerParam];
}
+ (LMRModel *)modelTitle:(NSString *)title
                    size:(CGSize)size
               routerKey:(nullable NSString *)routerKey
             routerParam:(nullable NSDictionary *)routerParam {
    LMRModel *model = [[LMRModel alloc]init];
    model.text = title;
    model.colWidth = size.width;
    model.rowHeight = size.height;
    
    if (routerKey.length > 0) {
        model.textColor = [UIColor colorWithRed:4.0/255.0 green:135.0/255.0 blue:237.0/255.0 alpha:1];
    } else {
        model.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    }
    model.routerKey = routerKey;
    if (routerParam.count > 0) {
        [model.routerParam addEntriesFromDictionary:routerParam];
    }
    
    model.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    model.backgroundColor = [UIColor whiteColor];
    return model;
}

@end
