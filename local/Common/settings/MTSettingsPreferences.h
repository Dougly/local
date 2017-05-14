//
//  MTSettingsPreferences.h
//  Proz
//
//  Created by RostyslavStepanyak on 3/17/16.
//  Copyright © 2016 Tilf AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTSettingsPreferences : NSObject

/*Place type*/
- (NSArray *)getPlaceTypes;
- (void)removePlaceType:(NSString *)placeType;
- (void)addPlaceType:(NSString *)placeType;

/*Foodtype*/
- (NSArray *)getFoodTypes;
- (void)removeFoodType:(NSString *)foodType;
- (void)addFoodType:(NSString *)foodType;

/*Only open*/
- (void)setOnlyOpen:(BOOL)onlyOpen;
- (BOOL)getOnlyOpen;

/*Only cheap*/
- (void)setOnlyCheap:(BOOL)onlyCheap;
- (BOOL)getOnlyCheap;

/*Rating*/
- (void)setRating:(float)rating;
- (float)getRating;

/*Pricing level*/
#pragma mark - Price
- (void)setPricingLevel:(NSUInteger)pricingLevel;
- (NSUInteger)getPricingLevel;

/*Distance*/
- (void)setDistance:(NSUInteger)distance;
- (NSUInteger)getDistance;

/*Key words*/
- (void)setFilterKeyWords:(NSString *)filterKeyWords;
- (NSString *)getFilterKeyWords;

@end
