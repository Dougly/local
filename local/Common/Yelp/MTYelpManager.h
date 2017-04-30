//
//  MTGooglePlacesManager.h
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/22/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@class MTYelpPlace;
@class MTPlace;

typedef void(^YelpCompletion)(BOOL success, MTYelpPlace *place, NSError *error);

@interface MTYelpManager : NSObject

+ (instancetype)sharedManager;
- (void)getYelpPlaceMatchingGooglePlace:(MTPlace *)place completion:(YelpCompletion)completion;
@end
