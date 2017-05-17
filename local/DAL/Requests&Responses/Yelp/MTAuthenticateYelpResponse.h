//
//  MTAuthenticateYelpResponse.h
//  Local
//
//  Created by Rostyslav Stepanyak on 5/17/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "SDResult.h"
@class MTYelpUser;

@interface MTAuthenticateYelpResponse : SDResult
@property (nonatomic, strong) MTYelpUser *yelpUser;
@end
