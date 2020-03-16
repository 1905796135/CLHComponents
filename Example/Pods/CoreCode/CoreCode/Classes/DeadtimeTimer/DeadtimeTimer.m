//
//  DeadtimeTimer.m
//  OneStoreMain
//
//  Created by Aimy on 14/12/24.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "DeadtimeTimer.h"
#import "CoreMacros.h"

@interface DeadtimeTimer ()

@property(nonatomic, copy) DeadtimeTimerBlock block;

@property(nonatomic, strong) NSTimer *countdownTimer;

@property(nonatomic, copy) NSDate *deadTime;

@end

@implementation DeadtimeTimer

- (void)runCountdownView {
    NSDate *now = [NSDate date];
    if ([self.deadTime compare:now] == NSOrderedDescending) {
        NSCalendarUnit components = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:components fromDate:now toDate:self.deadTime options:(NSCalendarOptions) 0];

        if (self.block) {
            self.block(dateComponents);
        }
    } else {
        if (self.block) {
            self.block(nil);
        }
        _block = nil;
        [self stop];
    }
}

- (void)runWithDeadtime:(NSDate *)deadtime andBLock:(DeadtimeTimerBlock)aBlock {
    self.block = aBlock;

    self.deadTime = deadtime;

    [self stop];

    WEAK_SELF;
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:weakSelf selector:@selector(runCountdownView) userInfo:nil repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:self.countdownTimer forMode:NSRunLoopCommonModes];
    [self.countdownTimer fire];
}

- (void)stop {
    [self.countdownTimer invalidate];
}

- (void)dealloc {
    PBFuncLog;
}

@end
