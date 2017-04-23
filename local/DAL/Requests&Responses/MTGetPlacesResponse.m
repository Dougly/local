//
//  MTLoginResponse.m
//  Automatize
//
//  Created by Rostyslav.Stepanyak on 3/15/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MTGetPlacesResponse.h"

@implementation MTGetPlacesResponse

- (void)parseResponseData:(NSData *)responseData {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.places = [[MTDataModel sharedDatabaseStorage] parsePlaces:responseData];
        self.pageToken = [[MTDataModel sharedDatabaseStorage] parseNewPageToken:responseData];
    });
}

@end
