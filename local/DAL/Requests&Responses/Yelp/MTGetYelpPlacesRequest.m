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
#import "MTDataModel.h"
#import "MTYelpUser.h"

@interface MTGetYelpPlacesRequest()
@end


@implementation MTGetYelpPlacesRequest

- (NSMutableURLRequest *)serviceURLRequest
{
    NSString *urlString = [NSString stringWithFormat:@"https://api.yelp.com/v3/businesses/search?term=%@&latitude=%lf&longitude=%lf&radius=10", self.query, self.latitude, self.longitude];
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSMutableURLRequest *networkRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    MTYelpUser *yelpUser = [[MTDataModel sharedDatabaseStorage] getYelpUser];
    
    NSString *token = @"";
    
    if (yelpUser) {
        token = yelpUser.bearer;
    }
    
    [networkRequest addValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
    
    networkRequest.HTTPMethod = @"GET";
    return networkRequest;
}


- (SDResult *)emptyResponse
{
    return [[MTGetYelpPlacesResponse alloc] init];
}

@end
