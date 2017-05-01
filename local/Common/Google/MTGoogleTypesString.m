//
//  MTGoogleTypesString.m
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/24/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MTGoogleTypesString.h"
#import "MTSettings.h"

@implementation MTGoogleTypesString
- (NSString *)stringTypes {
    /*NSString *types = @"";
    for (NSString *type in [[MTSettings sharedSettings] getPlaceTypes]) {
        types = [types stringByAppendingString:[NSString stringWithFormat:@"%@|", type]];
    }
    
    if (types.length > 0) {
        types = [types substringToIndex:types.length - 1];
    }
    
    return types.length > 0 ? types : nil;*/
    
    NSString *keywords = [MTSettings sharedSettings].filterKeyWords;
    
    if ([keywords containsString:@"beer"]) {
        return @"bar";
    }
    
    return @"cafe";
}
@end
