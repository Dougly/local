//
//  MTGetProfileResponse.h
//  Automatize
//
//  Created by Rostyslav.Stepanyak on 3/19/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "SDResult.h"
@class MTProfile;

@interface MTGetProfileResponse : SDResult
@property (nonatomic, strong) MTProfile *profile;
- (void)parseResponseData:(NSData *)responseData;
@end
