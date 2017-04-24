//
//  MTLoginRequest.h
//  Automatize
//
//  Created by Rostyslav.Stepanyak on 3/15/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "SDRequest.h"

@interface MTGetPlacesRequest : SDRequest

@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longitude;
@property (nonatomic) NSUInteger radius;
@property (nonatomic, strong) NSString *pageToken;
@property (nonatomic, strong) NSString *types;
@property (nonatomic, strong) NSString *query;

@end
