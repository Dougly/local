// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MTPlaceDetails.m instead.

#import "_MTPlaceDetails.h"

@implementation MTPlaceDetailsID
@end

@implementation _MTPlaceDetails

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MTPlaceDetails" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MTPlaceDetails";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MTPlaceDetails" inManagedObjectContext:moc_];
}

- (MTPlaceDetailsID*)objectID {
	return (MTPlaceDetailsID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"isOpenNowValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isOpenNow"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"latValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"lat"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"lonValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"lon"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"ratingValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"rating"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic adminLevel2;

@dynamic formattedAddress;

@dynamic internationalPhone;

@dynamic isOpenNow;

- (BOOL)isOpenNowValue {
	NSNumber *result = [self isOpenNow];
	return [result boolValue];
}

- (void)setIsOpenNowValue:(BOOL)value_ {
	[self setIsOpenNow:@(value_)];
}

- (BOOL)primitiveIsOpenNowValue {
	NSNumber *result = [self primitiveIsOpenNow];
	return [result boolValue];
}

- (void)setPrimitiveIsOpenNowValue:(BOOL)value_ {
	[self setPrimitiveIsOpenNow:@(value_)];
}

@dynamic lat;

- (float)latValue {
	NSNumber *result = [self lat];
	return [result floatValue];
}

- (void)setLatValue:(float)value_ {
	[self setLat:@(value_)];
}

- (float)primitiveLatValue {
	NSNumber *result = [self primitiveLat];
	return [result floatValue];
}

- (void)setPrimitiveLatValue:(float)value_ {
	[self setPrimitiveLat:@(value_)];
}

@dynamic localPhone;

@dynamic lon;

- (float)lonValue {
	NSNumber *result = [self lon];
	return [result floatValue];
}

- (void)setLonValue:(float)value_ {
	[self setLon:@(value_)];
}

- (float)primitiveLonValue {
	NSNumber *result = [self primitiveLon];
	return [result floatValue];
}

- (void)setPrimitiveLonValue:(float)value_ {
	[self setPrimitiveLon:@(value_)];
}

@dynamic name;

@dynamic neighbourhood;

@dynamic placeId;

@dynamic rating;

- (float)ratingValue {
	NSNumber *result = [self rating];
	return [result floatValue];
}

- (void)setRatingValue:(float)value_ {
	[self setRating:@(value_)];
}

- (float)primitiveRatingValue {
	NSNumber *result = [self primitiveRating];
	return [result floatValue];
}

- (void)setPrimitiveRatingValue:(float)value_ {
	[self setPrimitiveRating:@(value_)];
}

@dynamic streetName;

@dynamic streetNumber;

@dynamic sublocality;

@dynamic vincinity;

@dynamic website;

@dynamic openingHoursPeriods;

- (NSMutableSet<MTOpeningHourPeriod*>*)openingHoursPeriodsSet {
	[self willAccessValueForKey:@"openingHoursPeriods"];

	NSMutableSet<MTOpeningHourPeriod*> *result = (NSMutableSet<MTOpeningHourPeriod*>*)[self mutableSetValueForKey:@"openingHoursPeriods"];

	[self didAccessValueForKey:@"openingHoursPeriods"];
	return result;
}

@dynamic photos;

- (NSMutableSet<MTPhoto*>*)photosSet {
	[self willAccessValueForKey:@"photos"];

	NSMutableSet<MTPhoto*> *result = (NSMutableSet<MTPhoto*>*)[self mutableSetValueForKey:@"photos"];

	[self didAccessValueForKey:@"photos"];
	return result;
}

@dynamic reviews;

- (NSMutableSet<MTPlaceReview*>*)reviewsSet {
	[self willAccessValueForKey:@"reviews"];

	NSMutableSet<MTPlaceReview*> *result = (NSMutableSet<MTPlaceReview*>*)[self mutableSetValueForKey:@"reviews"];

	[self didAccessValueForKey:@"reviews"];
	return result;
}

@dynamic weekdayTexts;

- (NSMutableSet<MTWeekdayText*>*)weekdayTextsSet {
	[self willAccessValueForKey:@"weekdayTexts"];

	NSMutableSet<MTWeekdayText*> *result = (NSMutableSet<MTWeekdayText*>*)[self mutableSetValueForKey:@"weekdayTexts"];

	[self didAccessValueForKey:@"weekdayTexts"];
	return result;
}

@end

@implementation MTPlaceDetailsAttributes 
+ (NSString *)adminLevel2 {
	return @"adminLevel2";
}
+ (NSString *)formattedAddress {
	return @"formattedAddress";
}
+ (NSString *)internationalPhone {
	return @"internationalPhone";
}
+ (NSString *)isOpenNow {
	return @"isOpenNow";
}
+ (NSString *)lat {
	return @"lat";
}
+ (NSString *)localPhone {
	return @"localPhone";
}
+ (NSString *)lon {
	return @"lon";
}
+ (NSString *)name {
	return @"name";
}
+ (NSString *)neighbourhood {
	return @"neighbourhood";
}
+ (NSString *)placeId {
	return @"placeId";
}
+ (NSString *)rating {
	return @"rating";
}
+ (NSString *)streetName {
	return @"streetName";
}
+ (NSString *)streetNumber {
	return @"streetNumber";
}
+ (NSString *)sublocality {
	return @"sublocality";
}
+ (NSString *)vincinity {
	return @"vincinity";
}
+ (NSString *)website {
	return @"website";
}
@end

@implementation MTPlaceDetailsRelationships 
+ (NSString *)openingHoursPeriods {
	return @"openingHoursPeriods";
}
+ (NSString *)photos {
	return @"photos";
}
+ (NSString *)reviews {
	return @"reviews";
}
+ (NSString *)weekdayTexts {
	return @"weekdayTexts";
}
@end

