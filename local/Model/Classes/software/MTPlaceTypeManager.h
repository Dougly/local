//
//  MTSoftware.h
//  Proz
//
//  Created by RostyslavStepanyak on 1/22/16.
//  Copyright © 2016 Tilf AB. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MTPlaceType;

@interface MTPlaceTypeManager : NSObject
/*Find the software object with the id*/
- (MTPlaceType *)getPlaceTypeById:(int)placeTypeId;
- (NSMutableArray *)allPlaceTypes;
- (NSString *)idsByElementNames:(NSArray *)names;
@end
