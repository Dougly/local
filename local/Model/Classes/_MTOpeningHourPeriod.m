// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MTOpeningHourPeriod.m instead.

#import "_MTOpeningHourPeriod.h"

@implementation MTOpeningHourPeriodID
@end

@implementation _MTOpeningHourPeriod

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MTOpeningHourPeriod" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MTOpeningHourPeriod";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MTOpeningHourPeriod" inManagedObjectContext:moc_];
}

- (MTOpeningHourPeriodID*)objectID {
	return (MTOpeningHourPeriodID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"closeDayValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"closeDay"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"openDayValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"openDay"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic closeDay;

- (int16_t)closeDayValue {
	NSNumber *result = [self closeDay];
	return [result shortValue];
}

- (void)setCloseDayValue:(int16_t)value_ {
	[self setCloseDay:@(value_)];
}

- (int16_t)primitiveCloseDayValue {
	NSNumber *result = [self primitiveCloseDay];
	return [result shortValue];
}

- (void)setPrimitiveCloseDayValue:(int16_t)value_ {
	[self setPrimitiveCloseDay:@(value_)];
}

@dynamic closeTime;

@dynamic openDay;

- (int16_t)openDayValue {
	NSNumber *result = [self openDay];
	return [result shortValue];
}

- (void)setOpenDayValue:(int16_t)value_ {
	[self setOpenDay:@(value_)];
}

- (int16_t)primitiveOpenDayValue {
	NSNumber *result = [self primitiveOpenDay];
	return [result shortValue];
}

- (void)setPrimitiveOpenDayValue:(int16_t)value_ {
	[self setPrimitiveOpenDay:@(value_)];
}

@dynamic openTime;

@dynamic parentDetails;

@end

@implementation MTOpeningHourPeriodAttributes 
+ (NSString *)closeDay {
	return @"closeDay";
}
+ (NSString *)closeTime {
	return @"closeTime";
}
+ (NSString *)openDay {
	return @"openDay";
}
+ (NSString *)openTime {
	return @"openTime";
}
@end

@implementation MTOpeningHourPeriodRelationships 
+ (NSString *)parentDetails {
	return @"parentDetails";
}
@end

