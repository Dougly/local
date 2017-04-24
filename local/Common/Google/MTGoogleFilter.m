//
//  MTGoogleFilter.m
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/24/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MTGoogleFilter.h"
#import "MTPlace.h"
#import "MTSettings.h"

#define MIN_PRICING_LEVEL             1
@implementation MTGoogleFilter

- (BOOL)doesPlaceConformToAllFilters:(MTPlace *)place {
    MTSettings *settings = [MTSettings sharedSettings];

    if ([settings getOnlyOpen]) {
        if (!place.isOpenNow) {
            return false;
        }
    }
    
    if ([settings getOnlyCheap]) {
        if (place.pricingLevel.integerValue > MIN_PRICING_LEVEL) {
            return false;
        }
    }
    
    if ([settings getRating] > place.rating.floatValue) {
        return false;
    }
    
    return true;
}

@end
