//
//  PZSoftware.h
//  Proz
//
//  Created by RostyslavStepanyak on 1/22/16.
//  Copyright © 2016 Tilf AB. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PZSoftware;

@interface PZSoftwareManager : NSObject
/*Find the software object with the id*/
- (PZSoftware *)getSoftById:(int)softId;
- (NSMutableArray *)allSoftwares;
- (NSString *)idsByElementNames:(NSArray *)names;
@end
