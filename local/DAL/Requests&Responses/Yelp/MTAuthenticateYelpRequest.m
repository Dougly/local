//
//  MTAuthenticateYelpRequest.m
//  Local
//
//  Created by Rostyslav Stepanyak on 5/17/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MTAuthenticateYelpRequest.h"
#import "MTAuthenticateYelpResponse.h"

@implementation MTAuthenticateYelpRequest
- (NSMutableURLRequest *)serviceURLRequest
{
    NSString *urlString = @"https://api.yelp.com/oauth2/token";
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSMutableURLRequest *networkRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSString *post = [NSString stringWithFormat:@"grant_type=client_credentials&client_id=%@&client_secret=%@",kYELP_CLIENT_ID, kYELP_CLIENT_SECRET];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    [networkRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [networkRequest setHTTPBody:postData];
    [networkRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    
    networkRequest.HTTPMethod = @"POST";
    return networkRequest;
}


- (SDResult *)emptyResponse
{
    return [[MTAuthenticateYelpResponse alloc] init];
}

@end
