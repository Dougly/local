//
//  MTCompleteOrderRequest.m
//  Automatize
//
//  Created by Rostyslav.Stepanyak on 3/24/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MTCompleteOrderRequest.h"
#import "MTCompleteOrderResponse.h"

@implementation MTCompleteOrderRequest

- (NSMutableURLRequest *)serviceURLRequest
{
    NSMutableString *configurationString = [NSMutableString stringWithFormat:@"%@/driverCompleteJob", [SDUserSettings serviceURL]];
    
    NSMutableURLRequest *networkRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:configurationString]];
    [networkRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         [[MTDataModel sharedDatabaseStorage] getAccessToken], @"accessToken",
                         self.password, @"password",
                         self.orderId, @"orderId",
                         nil];
    
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    
    networkRequest.HTTPBody = postdata;
    networkRequest.HTTPMethod = @"POST";
    return networkRequest;
}

- (SDResult *)emptyResponse
{
    return [[MTCompleteOrderResponse alloc] init];
}

@end
