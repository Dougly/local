//
//  MTLocationManager.m
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/24/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MTLocationManager.h"

@interface MTLocationManager()<CLLocationManagerDelegate>
@property (nonatomic) CLLocationCoordinate2D lastLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) LocationCompletion completion;
@end

@implementation MTLocationManager

+ (instancetype)sharedManager {
    static MTLocationManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (void)getLocation:(LocationCompletion)completion {
    self.completion = completion;
    
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

#pragma mark - Location delegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    self.lastLocation = newLocation.coordinate;
    
    if (self.completion) {
        self.completion (true, nil, newLocation.coordinate);
        self.completion = nil;
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    switch([error code])
    {
        case kCLErrorNetwork:
        {
            if (self.completion) {
                self.completion(false, @"Please check your network connection.", kCLLocationCoordinate2DInvalid);
            }
        }
            break;
        case kCLErrorDenied:{
            if (self.completion) {
                self.completion(false, @"You have to enable the Location Service to use this App. To enable, please go to Settings->Privacy->Location Services.", kCLLocationCoordinate2DInvalid);
            }
            
        }
            break;
        default:
        {
            
        }
            break;
    }

}

#pragma mark - access overrides

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    
    return _locationManager;
}

@end
