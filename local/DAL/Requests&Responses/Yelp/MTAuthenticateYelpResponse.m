//
//  MTAuthenticateYelpResponse.m
//  Local
//
//  Created by Rostyslav Stepanyak on 5/17/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MTAuthenticateYelpResponse.h"
#import "MTDataModel.h"

@implementation MTAuthenticateYelpResponse

- (void)parseResponseData:(NSData *)responseData {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.yelpUser = [[MTDataModel sharedDatabaseStorage] parseYelpUser:responseData];
    });
}

@end
