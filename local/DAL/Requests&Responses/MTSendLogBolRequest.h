//
//  MTSendLogBolRequest.h
//  Automatize
//
//  Created by Rostyslav.Stepanyak on 3/24/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "SDRequest.h"

@interface MTSendLogBolRequest : SDRequest
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *orderId;
@end
