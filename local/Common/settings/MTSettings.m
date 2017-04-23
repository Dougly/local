//
//  MTSettings.m
//  Proz
//
//  Created by RostyslavStepanyak on 3/16/16.
//  Copyright © 2016 Tilf AB. All rights reserved.
//

#import "MTSettings.h"
#import "MTDataModel.h"
#import "MTPlaceTypeManager.h"
#import "MTSettingsPreferences.h"

@interface MTSettings()
@property (nonatomic, strong) NSMutableArray *foodTypes;
@property (nonatomic, strong) NSMutableArray *placeTypes;
@property (nonatomic, strong) MTPlaceTypeManager *placeTypesManager;
@property (nonatomic, strong) MTSettingsPreferences *preferences;
@end

@implementation MTSettings

+ (MTSettings *)sharedSettings
{
    static MTSettings *sharedInstance = nil;
    static dispatch_once_t pred;
    
    if (!sharedInstance)
    {
        dispatch_once(&pred, ^{
            sharedInstance = [MTSettings alloc];
            sharedInstance = [sharedInstance init];
        });
    }
    
    return sharedInstance;
}

- (id)init {
    self = [super init];
    _foodTypes = [[NSMutableArray alloc] init];
    _placeTypes = [[NSMutableArray alloc] init];
    _placeTypesManager = [[MTPlaceTypeManager alloc] init];
    _preferences = [[MTSettingsPreferences alloc] init];
    
    
    /*Init job posting types array*/
    NSArray *storedFoodTypes = [_preferences getFoodTypes];
    if(storedFoodTypes.count == 0) {
        [self addFoodTypes:@[FOOD_LUNCH, FOOD_DRINK, FOOD_BREAKFAST]];
    }
    else {
         [_foodTypes addObjectsFromArray:storedFoodTypes];
    }
    
    /*Init place types*/
    NSArray *storedPlaceTypes = [self.preferences getPlaceTypes];
    if(storedPlaceTypes.count == 0) {
        [self addPlaceTypes:[_placeTypesManager allPlaceTypes]];
    }
    else {
        [_placeTypes addObjectsFromArray:storedPlaceTypes];
    }
    
    
    return self;
}

#pragma mark - Software

- (void)addPlaceTypes:(NSArray *)placeTypes {
    for(NSString *placeType in placeTypes) {
        if(![self.placeTypes containsObject:placeType]) {
            [self.placeTypes addObject:placeType];
            [self.preferences addPlaceType:placeType];
        }
    }
}

- (void)removePlaceType:(NSString *)placeType {
    [self.preferences removePlaceType:placeType];
}

- (void)addPlaceType:(NSString *)placeType {
    [self.preferences addPlaceType:placeType];
}

- (NSMutableArray *)getPlaceTypes {
    return [[NSMutableArray alloc] initWithArray:[self.preferences getPlaceTypes]];
}

#pragma mark - Job posting types

- (void)addFoodTypes:(NSArray *)foodTypes {
    for(NSString *foodType in foodTypes) {
        if(![self.foodTypes containsObject:foodType]) {
            [self.foodTypes addObject:foodType];
            [self.preferences addFoodType:foodType];
        }
    }
}

- (NSMutableArray *)getFoodTypes {
    return [[NSMutableArray alloc] initWithArray:[self.preferences getFoodTypes]];
}

- (void)addFoodType:(NSString *)foodType {
    [self.preferences addFoodType:foodType];
}

- (void)removeFoodType:(NSString *)foodType {
    [self.preferences removeFoodType:foodType];
}


#pragma mark - Only open
- (void)setOnlyOpen:(BOOL)onlyOpen {
    [self.preferences setOnlyOpen:onlyOpen];
}

- (BOOL)getOnlyOpen {
    return [self.preferences getOnlyOpen];
}

#pragma mark - Only cheap
- (void)setOnlyCheap:(BOOL)onlyCheap {
    [self.preferences setOnlyCheap:onlyCheap];
}

- (BOOL)getOnlyCheap {
    return [self.preferences getOnlyCheap];
}

#pragma mark - Rating
- (void)setRating:(float)rating {
    [self.preferences setRating:rating];
}

- (float)getRating {
    return [self.preferences getRating];
}

#pragma mark - Distance
- (void)setDistance:(NSUInteger)distance {
    [self.preferences setDistance:distance];
}

- (NSUInteger)getDistance {
    return [self.preferences getDistance];
}

@end
