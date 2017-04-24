// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MTPlaceReview.m instead.

#import "_MTPlaceReview.h"

@implementation MTPlaceReviewID
@end

@implementation _MTPlaceReview

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MTPlaceReview" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MTPlaceReview";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MTPlaceReview" inManagedObjectContext:moc_];
}

- (MTPlaceReviewID*)objectID {
	return (MTPlaceReviewID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"ratingValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"rating"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"timeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"time"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic authorAvatarUrl;

@dynamic authorName;

@dynamic language;

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

@dynamic relativeTimeDescription;

@dynamic text;

@dynamic time;

- (int64_t)timeValue {
	NSNumber *result = [self time];
	return [result longLongValue];
}

- (void)setTimeValue:(int64_t)value_ {
	[self setTime:@(value_)];
}

- (int64_t)primitiveTimeValue {
	NSNumber *result = [self primitiveTime];
	return [result longLongValue];
}

- (void)setPrimitiveTimeValue:(int64_t)value_ {
	[self setPrimitiveTime:@(value_)];
}

@dynamic type;

@dynamic parentDetails;

@end

@implementation MTPlaceReviewAttributes 
+ (NSString *)authorAvatarUrl {
	return @"authorAvatarUrl";
}
+ (NSString *)authorName {
	return @"authorName";
}
+ (NSString *)language {
	return @"language";
}
+ (NSString *)rating {
	return @"rating";
}
+ (NSString *)relativeTimeDescription {
	return @"relativeTimeDescription";
}
+ (NSString *)text {
	return @"text";
}
+ (NSString *)time {
	return @"time";
}
+ (NSString *)type {
	return @"type";
}
@end

@implementation MTPlaceReviewRelationships 
+ (NSString *)parentDetails {
	return @"parentDetails";
}
@end

