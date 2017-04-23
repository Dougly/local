// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MTPlace.m instead.

#import "_MTPlace.h"

@implementation MTPlaceID
@end

@implementation _MTPlace

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MTPlace" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MTPlace";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MTPlace" inManagedObjectContext:moc_];
}

- (MTPlaceID*)objectID {
	return (MTPlaceID*)[super objectID];
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
	if ([key isEqualToString:@"pricingLevelValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"pricingLevel"];
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

@dynamic icon;

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

@dynamic placeId;

@dynamic pricingLevel;

- (int16_t)pricingLevelValue {
	NSNumber *result = [self pricingLevel];
	return [result shortValue];
}

- (void)setPricingLevelValue:(int16_t)value_ {
	[self setPricingLevel:@(value_)];
}

- (int16_t)primitivePricingLevelValue {
	NSNumber *result = [self primitivePricingLevel];
	return [result shortValue];
}

- (void)setPrimitivePricingLevelValue:(int16_t)value_ {
	[self setPrimitivePricingLevel:@(value_)];
}

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

@dynamic reference;

@dynamic scope;

@dynamic types;

@dynamic uniqueId;

@dynamic vincinity;

@dynamic photos;

- (NSMutableSet<MTPhoto*>*)photosSet {
	[self willAccessValueForKey:@"photos"];

	NSMutableSet<MTPhoto*> *result = (NSMutableSet<MTPhoto*>*)[self mutableSetValueForKey:@"photos"];

	[self didAccessValueForKey:@"photos"];
	return result;
}

@end

@implementation MTPlaceAttributes 
+ (NSString *)icon {
	return @"icon";
}
+ (NSString *)isOpenNow {
	return @"isOpenNow";
}
+ (NSString *)lat {
	return @"lat";
}
+ (NSString *)lon {
	return @"lon";
}
+ (NSString *)name {
	return @"name";
}
+ (NSString *)placeId {
	return @"placeId";
}
+ (NSString *)pricingLevel {
	return @"pricingLevel";
}
+ (NSString *)rating {
	return @"rating";
}
+ (NSString *)reference {
	return @"reference";
}
+ (NSString *)scope {
	return @"scope";
}
+ (NSString *)types {
	return @"types";
}
+ (NSString *)uniqueId {
	return @"uniqueId";
}
+ (NSString *)vincinity {
	return @"vincinity";
}
@end

@implementation MTPlaceRelationships 
+ (NSString *)photos {
	return @"photos";
}
@end

