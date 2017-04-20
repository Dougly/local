//
//  MTResetPasswordResponse.m
//  Automatize
//
//  Created by Rostyslav.Stepanyak on 3/24/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MTResetPasswordResponse.h"

@implementation MTResetPasswordResponse
- (void)parseResponseData:(NSData *)responseData {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.success = false;
        NSError *error = nil;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
        
        if (!error && [jsonDict isKindOfClass:NSDictionary.class])
        {
            if ([jsonDict[@"status"] integerValue] == 4) {
                self.success = true;
            }
        }
    });
}
@end
