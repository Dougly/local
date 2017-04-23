//
//  MTLoginRequest.m
//  Automatize
//
//  Created by Rostyslav.Stepanyak on 3/15/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MTGetPlacesRequest.h"
#import "MTGetPlacesResponse.h"

@implementation MTGetPlacesRequest

- (NSMutableURLRequest *)serviceURLRequest
{
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%lf,%lf&types=cafe|restaurant|pub&key=%@&radius=%ld&sensor=false", self.latitude, self.longitude, kGoogleMapAPIKey, self.radius];
    
    if (self.pageToken) {
        NSString *tokenPart = [NSString stringWithFormat:@"&pagetoken=%@", self.pageToken];
        urlString = [urlString stringByAppendingString:tokenPart];
    }
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSMutableURLRequest *networkRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [networkRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    networkRequest.HTTPMethod = @"GET";
    return networkRequest;
}


- (SDResult *)emptyResponse
{
    return [[MTGetPlacesResponse alloc] init];
}

@end
