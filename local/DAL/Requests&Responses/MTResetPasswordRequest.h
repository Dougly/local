//
//  MTResetPasswordRequest.h
//  Automatize
//
//  Created by Rostyslav.Stepanyak on 3/24/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "SDRequest.h"

@interface MTResetPasswordRequest : SDRequest
@property (nonatomic, strong) NSString *email;
@end
