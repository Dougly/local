//
//  MTGetPreviousVehicleRequest.m
//  Automatize
//
//  Created by Rostyslav.Stepanyak on 3/16/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MTGetPreviousVehicleRequest.h"
#import "MTGetPreviousVehicleResponse.h"

@implementation MTGetPreviousVehicleRequest

- (NSMutableURLRequest *)serviceURLRequest
{
    NSMutableString *configurationString = [NSMutableString stringWithFormat:@"%@/driverPreviousTruckNo", [SDUserSettings serviceURL]];
    
    NSMutableURLRequest *networkRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:configurationString]];
    [networkRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         [[MTDataModel sharedDatabaseStorage] getAccessToken], @"accessToken",
                         nil];
    
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    
    networkRequest.HTTPBody = postdata;
    networkRequest.HTTPMethod = @"POST";
    return networkRequest;
}

- (SDResult *)emptyResponse
{
    return [[MTGetPreviousVehicleResponse alloc] init];
}

@end
