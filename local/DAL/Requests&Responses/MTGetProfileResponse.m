//
//  MTGetProfileResponse.m
//  Automatize
//
//  Created by Rostyslav.Stepanyak on 3/19/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MTGetProfileResponse.h"

@implementation MTGetProfileResponse

- (void)parseResponseData:(NSData *)responseData {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.profile = [[MTDataModel sharedDatabaseStorage] parseProfile:responseData];
    });
}

@end
