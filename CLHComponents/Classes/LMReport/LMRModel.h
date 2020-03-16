//
//  LMRModel.h
//  Service
//
//  Created by 曹连华 on 2019/9/23.
//  Copyright © 2019 曹连华. All rights reserved.
//

#import "LMRGrid.h"
NS_ASSUME_NONNULL_BEGIN

@interface LMRModel : LMRGrid

@property (nonatomic, strong) NSString *routerKey;
@property (nonatomic, strong) NSMutableDictionary *routerParam;

+ (LMRModel *)modelTitle:(NSString *)title
               routerKey:(nullable NSString *)routerKey
             routerParam:(nullable NSDictionary *)routerParam;

+ (LMRModel *)modelTitle:(NSString *)title
                    size:(CGSize)size
               routerKey:(nullable NSString *)routerKey
             routerParam:(nullable NSDictionary *)routerParam;

+ (LMRModel *)modelTitle:(NSString *)title
                    size:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
