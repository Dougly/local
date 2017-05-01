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
            [sharedInstance overwriteKeyWordsAccordingToDayTime];
        });
    }
    
    return sharedInstance;
}

- (id)init {
    self = [super init];
    _filterKeyWords = FILTERS_KEY_WORDS[0];
    
    _foodTypes = [[NSMutableArray alloc] init];
    _placeTypes = [[NSMutableArray alloc] init];
    _placeTypesManager = [[MTPlaceTypeManager alloc] init];
    _preferences = [[MTSettingsPreferences alloc] init];
    
    
    /*Init job posting types array*/
    NSArray *storedFoodTypes = [_preferences getFoodTypes];
    if(storedFoodTypes.count == 0) {
        [self addFoodTypes:FOOD_TYPES];
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

- (void)overwriteKeyWordsAccordingToDayTime {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:[NSDate date]];
    NSInteger hour = [components hour];
    
    NSString *keyWords = MEAL_TYPES[0];
    if(hour >= 0 && hour < 6) {
        keyWords = FILTERS_KEY_WORDS[1];
    }
    else if(hour >= 6 && hour < 12) {
        keyWords = MEAL_TYPES[0];
    }
    else if(hour >= 12 && hour < 17) {
        keyWords =MEAL_TYPES[1];
    }
    else if(hour >= 17){
        keyWords = MEAL_TYPES[2];
    }
    
    _filterKeyWords = keyWords;
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

#pragma mark - key words

- (void)setFilterKeyWords:(NSString *)filterKeyWords {
    _filterKeyWords = filterKeyWords;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:nKEYWORDS_CHANGED object:nil];
}

@end
