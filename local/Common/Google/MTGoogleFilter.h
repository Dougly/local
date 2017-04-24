//
//  MTGoogleFilter.h
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/24/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MTPlace;
@interface MTGoogleFilter : NSObject

- (BOOL)doesPlaceConformToAllFilters:(MTPlace *)place;
@end
