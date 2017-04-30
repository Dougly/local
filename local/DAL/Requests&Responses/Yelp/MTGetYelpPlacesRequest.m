//
//  MTGetPlaceDetailRequest.m
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/24/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MTGetYelpPlacesRequest.h"
#import "MTGetYelpPlacesResponse.h"
#import "MTGoogleQueryString.h"

@interface MTGetYelpPlacesRequest()
@end


@implementation MTGetYelpPlacesRequest

- (NSMutableURLRequest *)serviceURLRequest
{
    NSString *urlString = [NSString stringWithFormat:@"https://api.yelp.com/v3/businesses/search?term=%@&latitude=%lf&longitude=%lf&radius=10", self.query, self.latitude, self.longitude];
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSMutableURLRequest *networkRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //[networkRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [networkRequest addValue:@"Bearer Z2NZ370JEhYtOMjiRGN3F0PlVUxhcLJ_Y1qz3NOscIRbAQqEge7IUZdD_ZHzKf9LlVL8tLDi5FfG1PGur1lZra5tDLXoN7Ylrpv6lRO6VcUhdXZbNaorBKszCPYFWXYx" forHTTPHeaderField:@"Authorization"];
    
    networkRequest.HTTPMethod = @"GET";
    return networkRequest;
}


- (SDResult *)emptyResponse
{
    return [[MTGetYelpPlacesResponse alloc] init];
}

@end
