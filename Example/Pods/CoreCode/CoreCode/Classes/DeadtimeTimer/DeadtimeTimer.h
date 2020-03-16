//
//  DeadtimeTimer.h
//  OneStoreMain
//
//  Created by Aimy on 14/12/24.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  为nil则表示已经倒计时完成了
 *
 *  @param dateComponents NSDateComponents
 */
typedef void(^DeadtimeTimerBlock)(NSDateComponents *dateComponents);

@interface DeadtimeTimer : NSObject

- (void)runWithDeadtime:(NSDate *)deadtime andBLock:(DeadtimeTimerBlock)aBlock;

- (void)stop;

@end
