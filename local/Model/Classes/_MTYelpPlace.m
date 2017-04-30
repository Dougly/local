// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MTYelpPlace.m instead.

#import "_MTYelpPlace.h"

@implementation MTYelpPlaceID
@end

@implementation _MTYelpPlace

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MTYelpPlace" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MTYelpPlace";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MTYelpPlace" inManagedObjectContext:moc_];
}

- (MTYelpPlaceID*)objectID {
	return (MTYelpPlaceID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"ratingValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"rating"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic name;

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

@end

@implementation MTYelpPlaceAttributes 
+ (NSString *)name {
	return @"name";
}
+ (NSString *)rating {
	return @"rating";
}
@end

