//
//  MTGetPlaceDetailRequest.m
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/24/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MTGetPlaceDetailRequest.h"
#import "MTGetPlaceDetailsResponse.h"

@implementation MTGetPlaceDetailRequest

- (NSMutableURLRequest *)serviceURLRequest
{
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=%@",self.placeId, kGoogleMapAPIKey];
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSMutableURLRequest *networkRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [networkRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    networkRequest.HTTPMethod = @"GET";
    return networkRequest;
}


- (SDResult *)emptyResponse
{
    return [[MTGetPlaceDetailsResponse alloc] init];
}

@end
