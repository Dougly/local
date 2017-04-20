//
//  MTUpdateTicketRequest.h
//  Automatize
//
//  Created by Rostyslav.Stepanyak on 3/24/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "SDRequest.h"

@interface MTUpdateTicketRequest : SDRequest
@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *orderId;
@end
