// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MTWeekdayText.m instead.

#import "_MTWeekdayText.h"

@implementation MTWeekdayTextID
@end

@implementation _MTWeekdayText

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MTWeekdayText" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MTWeekdayText";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MTWeekdayText" inManagedObjectContext:moc_];
}

- (MTWeekdayTextID*)objectID {
	return (MTWeekdayTextID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"dayValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"day"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic day;

- (int16_t)dayValue {
	NSNumber *result = [self day];
	return [result shortValue];
}

- (void)setDayValue:(int16_t)value_ {
	[self setDay:@(value_)];
}

- (int16_t)primitiveDayValue {
	NSNumber *result = [self primitiveDay];
	return [result shortValue];
}

- (void)setPrimitiveDayValue:(int16_t)value_ {
	[self setPrimitiveDay:@(value_)];
}

@dynamic name;

@dynamic parentDetails;

@end

@implementation MTWeekdayTextAttributes 
+ (NSString *)day {
	return @"day";
}
+ (NSString *)name {
	return @"name";
}
@end

@implementation MTWeekdayTextRelationships 
+ (NSString *)parentDetails {
	return @"parentDetails";
}
@end

