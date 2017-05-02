//
//  MTGooglePlacesManager.h
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/22/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "QTree.h"

typedef void(^GooglePlaceCompletion)(BOOL success, NSArray *places, NSError *error);

@interface MTGooglePlacesManager : NSObject
@property (nonatomic, strong, readonly) QTree *qTree;

+ (instancetype)sharedManager;

- (void)query:(CLLocationCoordinate2D)coordinate
       radius:(NSUInteger)radius
   completion:(GooglePlaceCompletion)completion;
@end
