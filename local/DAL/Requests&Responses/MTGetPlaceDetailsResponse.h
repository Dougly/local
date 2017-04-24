//
//  MTGetPlaceDetailsResponse.h
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/24/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "SDResult.h"
@class MTPlaceDetails;

@interface MTGetPlaceDetailsResponse : SDResult
@property (nonatomic, strong) MTPlaceDetails *placeDetails;
@end
