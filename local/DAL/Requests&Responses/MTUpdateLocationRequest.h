//
//  MTUpdateLocation.h
//  Automatize
//
//  Created by Rostyslav.Stepanyak on 3/24/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "SDRequest.h"

@interface MTUpdateLocationRequest : SDRequest
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@end
