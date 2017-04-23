//
//  PZSettings.m
//  Proz
//
//  Created by RostyslavStepanyak on 3/16/16.
//  Copyright © 2016 Tilf AB. All rights reserved.
//

#import "PZSettings.h"
#import "MTDataModel.h"
#import "PZSoftwareManager.h"
#import "PZSettingsPreferences.h"

@interface PZSettings()
@property (nonatomic, strong) NSMutableArray *jobPostingTypes;
@property (nonatomic, strong) NSMutableArray *softwares;
@property (nonatomic, strong) PZSoftwareManager *softwareManager;
@property (nonatomic, strong) PZSettingsPreferences *preferences;
@end

@implementation PZSettings

+ (PZSettings *)sharedSettings
{
    static PZSettings *sharedInstance = nil;
    static dispatch_once_t pred;
    
    if (!sharedInstance)
    {
        dispatch_once(&pred, ^{
            sharedInstance = [PZSettings alloc];
            sharedInstance = [sharedInstance init];
        });
    }
    
    return sharedInstance;
}

- (id)init {
    self = [super init];
    _jobPostingTypes = [[NSMutableArray alloc] init];
    _softwares = [[NSMutableArray alloc] init];
    _preferences = [[PZSettingsPreferences alloc] init];
    
    
    /*Init job posting types array*/
    NSArray *storedPostingTypes = [_preferences getJobPostingTypes];
    if(storedPostingTypes.count == 0) {
        [self addJobPostingTypes:@[POSTING_TYPE_TRANSLATION, POSTING_TYPE_INTERPRET, POSTING_TYPE_POTENTIAL]];
    }
    else {
         [_jobPostingTypes addObjectsFromArray:storedPostingTypes];
    }
   
    
    /*Init softwares*/
    NSArray *storedSoftware = [self.preferences getSoftwares];
    if(storedSoftware.count == 0) {
        [self addSoftwares:[_softwareManager allSoftwares]];
    }
    else {
        [_softwares addObjectsFromArray:storedSoftware];
    }
    
    return self;
}




#pragma mark - Software

- (void)addSoftwares:(NSArray *)softwares {
    for(NSString *software in softwares) {
        if(![self.softwares containsObject:software]) {
            [self.softwares addObject:software];
            [self.preferences addSoftware:software];
        }
    }
}

- (void)removeSoftware:(NSString *)software {
    [self.preferences removeSoftware:software];
}

- (void)addSoftware:(NSString *)software {
    [self.preferences addSoftware:software];
}

- (NSMutableArray *)getSoftwares {
    return [[NSMutableArray alloc] initWithArray:[self.preferences getSoftwares]];
}

#pragma mark - Job posting types

- (void)addJobPostingTypes:(NSArray *)postingTypes {
    for(NSString *postingType in postingTypes) {
        if(![self.jobPostingTypes containsObject:postingType]) {
            [self.jobPostingTypes addObject:postingType];
            [self.preferences addJobPostingType:postingType];
        }
    }
}

- (NSMutableArray *)getJobPostingTypes {
    return [[NSMutableArray alloc] initWithArray:[self.preferences getJobPostingTypes]];
}

- (void)addJobPostingType:(NSString *)jobPostingType {
    [self.preferences addJobPostingType:jobPostingType];
}

- (void)removeJobPostingType:(NSString *)jobPostingType {
    [self.preferences removeJobPostingType:jobPostingType];
}

@end
