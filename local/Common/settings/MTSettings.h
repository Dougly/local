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

@property (nonatomic, strong) NSString *filterKeyWords;

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

/*Pricing level*/
- (void)setPricingLevel:(NSUInteger)pricingLevel;
- (NSUInteger)getPricingLevel;


/*Distance*/
- (void)setDistance:(NSUInteger)distance;
- (NSUInteger)getDistance;

- (void)overwriteKeyWordsAccordingToDayTime;
@end
