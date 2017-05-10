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
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?location=%lf,%lf&key=%@&radius=%ld&rankBy=distance", self.latitude, self.longitude, kGoogleMapAPIKey, (unsigned long)self.radius];
    if (self.types) {
        NSString *placeTypesPart = [NSString stringWithFormat:@"&type=%@", self.types];
        urlString = [urlString stringByAppendingString:placeTypesPart];
    }
    if (self.query) {
        NSString *placeTypesPart = [NSString stringWithFormat:@"&query=%@", self.query];
        urlString = [urlString stringByAppendingString:placeTypesPart];
    }
    if (self.pageToken) {
        NSString *tokenPart = [NSString stringWithFormat:@"&pagetoken=%@", self.pageToken];
        urlString = [urlString stringByAppendingString:tokenPart];
    }
    
    
    NSLog(@"GOOGLE-URL: %@", urlString);
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
