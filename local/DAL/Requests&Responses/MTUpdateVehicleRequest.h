//
//  MTUpdateVehicleRequest.h
//  Automatize
//
//  Created by Rostyslav.Stepanyak on 3/16/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "SDRequest.h"

@interface MTUpdateVehicleRequest : SDRequest

@property (nonatomic, strong) NSString *truckNumber;
@property (nonatomic, strong) NSString *trailerNumber;

@end
