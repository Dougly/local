//
//  MTGetPlaceDetailsResponse.m
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/24/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MTGetPlaceDetailsResponse.h"

@implementation MTGetPlaceDetailsResponse

- (void)parseResponseData:(NSData *)responseData {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.placeDetails = [[MTDataModel sharedDatabaseStorage] parsePlaceDetails:responseData];
    });
}

@end
