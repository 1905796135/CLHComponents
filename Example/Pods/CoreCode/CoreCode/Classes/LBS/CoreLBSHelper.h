//
//  CoreLBSHelper.h
//  Core
//
//  Created by Jerry on 2017/8/17.
//  Copyright © 2017年 com.core. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@class RACSignal;

@interface CoreLBSHelper : NSObject

@property(nonatomic, strong, readonly) CLLocationManager *locationManager;
@property(nonatomic, strong, readonly) CLLocation *lastLocation;

- (__kindof RACSignal *)rac_startUserLocationService;
- (void)stopUserLocationService;

@end
