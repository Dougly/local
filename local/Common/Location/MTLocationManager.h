//
//  MTLocationManager.h
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/24/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^LocationCompletion)(BOOL success, NSString *erroMessage, CLLocationCoordinate2D coordinate);

@interface MTLocationManager : NSObject
+ (instancetype)sharedManager;
- (void)getLocation:(LocationCompletion)completion;
@end
