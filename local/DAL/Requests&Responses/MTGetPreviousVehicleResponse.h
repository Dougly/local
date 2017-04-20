//
//  MTGetPreviousVehicleResponse.h
//  Automatize
//
//  Created by Rostyslav.Stepanyak on 3/16/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "SDResult.h"
@class MTPreviousVehicle;

@interface MTGetPreviousVehicleResponse : SDResult
@property (nonatomic, strong) MTPreviousVehicle *vehicle;
@end
