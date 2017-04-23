//
//  PZSettings.h
//  Proz
//
//  Created by RostyslavStepanyak on 3/16/16.
//  Copyright © 2016 Tilf AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PZSettings : NSObject

+ (PZSettings *)sharedSettings;

/*Softwares*/
- (void)removeSoftware:(NSString *)software;
- (void)addSoftware:(NSString *)software;
- (NSMutableArray *)getSoftwares;

/*Job Posting types*/
- (NSMutableArray *)getJobPostingTypes;
- (void)addJobPostingType:(NSString *)jobPostingType;
- (void)removeJobPostingType:(NSString *)jobPostingType;

@end
