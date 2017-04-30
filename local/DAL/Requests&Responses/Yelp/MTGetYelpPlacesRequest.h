//
//  MTGetPlaceDetailRequest.h
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/24/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "SDRequest.h"

@interface MTGetYelpPlacesRequest : SDRequest
@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longitude;
@property (nonatomic, strong) NSString *query;
@end
