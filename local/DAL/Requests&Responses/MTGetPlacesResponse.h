//
//  MTLoginResponse.h
//  Automatize
//
//  Created by Rostyslav.Stepanyak on 3/15/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "SDResult.h"

@interface MTGetPlacesResponse : SDResult
@property (nonatomic, strong) NSArray *places;
@property (nonatomic, strong) NSString *pageToken;
@end
