//
//  MTSettingsPreferences.m
//  Proz
//
//  Created by RostyslavStepanyak on 3/17/16.
//  Copyright © 2016 Tilf AB. All rights reserved.
//

#import "MTSettingsPreferences.h"

@interface MTSettingsPreferences()
@property (nonatomic, strong) NSUserDefaults *defaults;
@end

@implementation MTSettingsPreferences
NSString *const FOOD_TYPE_KEY  = @"FOOD_TYPE_KEY";
NSString *const PLACE_TYPE_KEY = @"PLACE_TYPE_KEY";

NSString *const ONLY_OPEN_KEY  = @"ONLY_OPEN_KEY";
NSString *const ONLY_CHEAP_KEY = @"ONLY_CHEAP_KEY";
NSString *const RATING_KEY     = @"RATING_KEY";
NSString *const PRICING_LEVEL_KEY = @"PRICING_LEVEL_KEY";
NSString *const DISTANCE_KEY   = @"DISTANCE_KEY";


NSString *const KEY_WORDS_KEY = @"KEY_WRODS_KEY";

- (id)init {
    self = [super init];
    _defaults = [NSUserDefaults standardUserDefaults];
    [self setupInitialValues];
    return self;
}

- (void)setupInitialValues {
    if(![_defaults valueForKey:FOOD_TYPE_KEY]) {
        for (NSString *foodType in FOOD_TYPES) {
            [self addFoodType:foodType];
        }
    }
    
    if(![_defaults valueForKey:ONLY_OPEN_KEY]) {
        [self setOnlyOpen:YES];
    }
    
    if(![_defaults valueForKey:RATING_KEY]) {
        [self setRating:4.0];
    }
    
    if(![_defaults valueForKey:PRICING_LEVEL_KEY]) {
        [self setPricingLevel:MTPriceLevelAll];
    }
    
    if(![_defaults valueForKey:DISTANCE_KEY]) {
        [self setDistance:3];
    }
}

#pragma mark - job posting type

- (NSArray *)getFoodTypes {
    return [self getArrayOfEntries:FOOD_TYPE_KEY];
}

- (void)removeFoodType:(NSString *)foodType {
    [self removeEntry:foodType atKey:FOOD_TYPE_KEY];
}

- (void)addFoodType:(NSString *)foodType {
    [self addEntry:foodType forKey:FOOD_TYPE_KEY];
}

#pragma mark - Place Types

- (NSArray *)getPlaceTypes {
    return [self getArrayOfEntries:PLACE_TYPE_KEY];
}

- (void)removePlaceType:(NSString *)placeType {
    [self removeEntry:placeType atKey:PLACE_TYPE_KEY];
}

- (void)addPlaceType:(NSString *)placeType {
    [self addEntry:placeType forKey:PLACE_TYPE_KEY];
}

#pragma mark - Only open
- (void)setOnlyOpen:(BOOL)onlyOpen {
    [self.defaults setValue:@(onlyOpen) forKey:ONLY_OPEN_KEY];

}

- (BOOL)getOnlyOpen {
    return [[self.defaults valueForKey:ONLY_OPEN_KEY] boolValue];
}

#pragma mark - Only cheap
- (void)setOnlyCheap:(BOOL)onlyCheap {
    [self.defaults setValue:@(onlyCheap) forKey:ONLY_CHEAP_KEY];

}

- (BOOL)getOnlyCheap {
    return [[self.defaults valueForKey:ONLY_CHEAP_KEY] boolValue];
}

#pragma mark - Rating
- (void)setRating:(float)rating {
    [self.defaults setValue:@(rating) forKey:RATING_KEY];

}

- (float)getRating {
    return [[self.defaults valueForKey:RATING_KEY] floatValue];
}

#pragma mark - Price
- (void)setPricingLevel:(NSUInteger)pricingLevel {
    [self.defaults setValue:@(pricingLevel) forKey:PRICING_LEVEL_KEY];
}

- (NSUInteger)getPricingLevel {
    return [[self.defaults valueForKey:PRICING_LEVEL_KEY] integerValue];
}

#pragma mark - Distance

- (void)setDistance:(NSUInteger)distance {
    [self.defaults setValue:@(distance) forKey:DISTANCE_KEY];
}

- (NSUInteger)getDistance {
    return [[self.defaults valueForKey:DISTANCE_KEY] integerValue];
}

#pragma mark - KeyWords
- (void)setFilterKeyWords:(NSString *)filterKeyWords {
     [self.defaults setValue:filterKeyWords forKey:KEY_WORDS_KEY];
}

- (NSString *)getFilterKeyWords {
     return [self.defaults valueForKey:KEY_WORDS_KEY];
}

#pragma mark - string processing

- (NSArray *)getArrayOfEntries:(NSString *)key {
    NSString *entities = [self.defaults valueForKey:key];
    if(entities && entities.length > 0) {
        return [entities componentsSeparatedByString:DELIMITER];
    }
    else {
        return [[NSArray alloc] init];
    }
}

- (void)removeEntry:(NSString *)entry atKey:(NSString *)key {
    NSString *entires = [self.defaults valueForKey:key];
    if(entires) {
        if([entires rangeOfString:DELIMITER].location != NSNotFound) {
            /*Its the first element in the string, so remove it and the delimiter following this element*/
            if([entires rangeOfString:entry].location == 0) {
                entires = [entires stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@%@", entry, DELIMITER] withString:@""];
            }
            else {
                /*Its not the first element. So remove the delimiter in front of it and the element*/
                entires = [entires stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@%@", DELIMITER, entry] withString:@""];
            }
        }
        else {
            entires = [entires stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@", entry] withString:@""];
        }
        [self.defaults setValue:entires forKey:key];
        [self.defaults synchronize];
    }
}

- (void)addEntry:(NSString *)entry forKey:(NSString *)key {
    NSString *entries = [self.defaults valueForKey:key];
    if(!entries) {
        entries = @"";
    }
    
    Boolean elementAlreadyExits = false;
    
    if([entries rangeOfString:entry].location != NSNotFound) {
        /*We got match. It means either the element exists or its just a part of anotehr element*/
        NSArray *elements = [entries componentsSeparatedByString:DELIMITER];
        if([elements containsObject:entry]) {
            elementAlreadyExits = YES;
        }
    }
    
    if(!elementAlreadyExits) {
        if(entries.length > 0) {
            entries = [entries stringByAppendingString:[NSString stringWithFormat:@"%@%@", DELIMITER, entry]];
        }
        else {
            entries = entry;
        }
        
        [self.defaults setValue:entries forKey:key];
        [self.defaults synchronize];
    }
}

@end
