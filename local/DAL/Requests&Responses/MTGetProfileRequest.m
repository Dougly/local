//
//  MTGetProfileRequest.m
//  Automatize
//
//  Created by Rostyslav.Stepanyak on 3/19/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MTGetProfileRequest.h"
#import "MTGetProfileResponse.h"

@implementation MTGetProfileRequest

- (NSMutableURLRequest *)serviceURLRequest
{
    NSMutableString *configurationString = [NSMutableString stringWithFormat:@"%@/viewProfile", [SDUserSettings serviceURL]];
    
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
    return [[MTGetProfileResponse alloc] init];
}

@end
