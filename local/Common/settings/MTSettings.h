//
//  MTSettings.h
//  Proz
//
//  Created by RostyslavStepanyak on 3/16/16.
//  Copyright © 2016 Tilf AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTSettings : NSObject

+ (MTSettings *)sharedSettings;

/*Place types*/
- (void)removePlaceType:(NSString *)placeType;
- (void)addPlaceType:(NSString *)placeType;
- (NSMutableArray *)getPlaceTypes;

/*Food types*/
- (void)removeFoodType:(NSString *)foodType;
- (void)addFoodType:(NSString *)foodType;
- (NSMutableArray *)getFoodTypes;

/*Only open*/
- (void)setOnlyOpen:(BOOL)onlyOpen;
- (BOOL)getOnlyOpen;

/*Only cheap*/
- (void)setOnlyCheap:(BOOL)onlyCheap;
- (BOOL)getOnlyCheap;

/*Rating*/
- (void)setRating:(float)rating;
- (float)getRating;

/*Distance*/
- (void)setDistance:(NSUInteger)distance;
- (NSUInteger)getDistance;

@end
