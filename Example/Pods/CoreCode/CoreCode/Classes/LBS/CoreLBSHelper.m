//
//  CoreLBSHelper.m
//  Core
//
//  Created by Jerry on 2017/8/17.
//  Copyright © 2017年 com.core. All rights reserved.
//

#import "CoreLBSHelper.h"
#import <ReactiveObjC/ReactiveObjC.h>


#define Core_RESTRICTED_LOCATION_ERROR [NSError errorWithDomain:@"com.core" code:0 userInfo:@{NSLocalizedDescriptionKey: @"无法使用定位服务,请在设置-隐私-定位服务中开启"}]

@interface CoreLBSHelper () <CLLocationManagerDelegate>

@property (nonatomic, strong) RACSubject *rac_locationUpdateSubject;
@property (nonatomic, strong) CLLocation *lastLocation;

@end

@implementation CoreLBSHelper

@synthesize locationManager = _locationManager;

- (__kindof RACSignal *)rac_startUserLocationService {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
        return [RACSignal error:Core_RESTRICTED_LOCATION_ERROR];
    }

    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    } else {
        [self.locationManager startUpdatingLocation];
    }

    return self.rac_locationUpdateSubject;
}

- (void)stopUserLocationService {
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if ((status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse)) {
        [manager startUpdatingLocation];
    } else if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        [self.rac_locationUpdateSubject sendError:Core_RESTRICTED_LOCATION_ERROR];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.lastLocation = locations.lastObject;
    [self stopUserLocationService];
    [self.rac_locationUpdateSubject sendNext:self.lastLocation];
    [self.rac_locationUpdateSubject sendCompleted];
}

#pragma mark - Getter & Setter

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locationManager.distanceFilter = 500;
    }
    return _locationManager;
}

- (RACSubject *)rac_locationUpdateSubject {
    if (!_rac_locationUpdateSubject) {
        _rac_locationUpdateSubject = [RACSubject<CLLocation *> subject];
    }

    return _rac_locationUpdateSubject;
}

@end
