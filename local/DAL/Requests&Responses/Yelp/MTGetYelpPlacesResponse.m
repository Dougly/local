//
//  MTGetPlaceDetailsResponse.m
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/24/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MTGetYelpPlacesResponse.h"

@implementation MTGetYelpPlacesResponse

- (void)parseResponseData:(NSData *)responseData {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.yelpPlaces = [[MTDataModel sharedDatabaseStorage] parseYelpPlaces:responseData];
    });
}

@end
