//
//  MTGetPreviousVehicleResponse.m
//  Automatize
//
//  Created by Rostyslav.Stepanyak on 3/16/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MTGetPreviousVehicleResponse.h"

@implementation MTGetPreviousVehicleResponse

- (void)parseResponseData:(NSData *)responseData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.vehicle = [[MTDataModel sharedDatabaseStorage] parsePreviousVehicle:responseData];
    });
}

@end
