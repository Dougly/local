//
//  MTGoogleQueryString.m
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/24/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MTGoogleQueryString.h"
#import "MTSettings.h"

@implementation MTGoogleQueryString
- (NSString *)stringQuery {
    NSString *query = @"";
    for (NSString *food in [[MTSettings sharedSettings] getFoodTypes]) {
        query = [query stringByAppendingString:[NSString stringWithFormat:@"%@+", food]];
    }
    
    if (query.length > 0) {
        query = [query substringToIndex:query.length - 1];
    }
    
    return query.length > 0 ? query : nil;
}
@end
