//
//  MTGetDeliveryDetailsResposne.m
//  Automatize
//
//  Created by Rostyslav.Stepanyak on 3/16/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MTGetDeliveryDetailsResponse.h"

@implementation MTGetDeliveryDetailsResponse

- (void)parseResponseData:(NSData *)responseData {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.delivery = [[MTDataModel sharedDatabaseStorage] parseDeliveryDetails:responseData];
    });
}

@end
