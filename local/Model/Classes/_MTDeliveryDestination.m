// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MTDeliveryDestination.m instead.

#import "_MTDeliveryDestination.h"

@implementation MTDeliveryDestinationID
@end

@implementation _MTDeliveryDestination

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MTDeliveryDestination" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MTDeliveryDestination";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MTDeliveryDestination" inManagedObjectContext:moc_];
}

- (MTDeliveryDestinationID*)objectID {
	return (MTDeliveryDestinationID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"contactNumberValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"contactNumber"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"latitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"longitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic address;

@dynamic city;

@dynamic contactNumber;

- (int64_t)contactNumberValue {
	NSNumber *result = [self contactNumber];
	return [result longLongValue];
}

- (void)setContactNumberValue:(int64_t)value_ {
	[self setContactNumber:@(value_)];
}

- (int64_t)primitiveContactNumberValue {
	NSNumber *result = [self primitiveContactNumber];
	return [result longLongValue];
}

- (void)setPrimitiveContactNumberValue:(int64_t)value_ {
	[self setPrimitiveContactNumber:@(value_)];
}

@dynamic latitude;

- (double)latitudeValue {
	NSNumber *result = [self latitude];
	return [result doubleValue];
}

- (void)setLatitudeValue:(double)value_ {
	[self setLatitude:@(value_)];
}

- (double)primitiveLatitudeValue {
	NSNumber *result = [self primitiveLatitude];
	return [result doubleValue];
}

- (void)setPrimitiveLatitudeValue:(double)value_ {
	[self setPrimitiveLatitude:@(value_)];
}

@dynamic longitude;

- (double)longitudeValue {
	NSNumber *result = [self longitude];
	return [result doubleValue];
}

- (void)setLongitudeValue:(double)value_ {
	[self setLongitude:@(value_)];
}

- (double)primitiveLongitudeValue {
	NSNumber *result = [self primitiveLongitude];
	return [result doubleValue];
}

- (void)setPrimitiveLongitudeValue:(double)value_ {
	[self setPrimitiveLongitude:@(value_)];
}

@dynamic name;

@dynamic specialInstruction;

@dynamic relationship;

@end

@implementation MTDeliveryDestinationAttributes 
+ (NSString *)address {
	return @"address";
}
+ (NSString *)city {
	return @"city";
}
+ (NSString *)contactNumber {
	return @"contactNumber";
}
+ (NSString *)latitude {
	return @"latitude";
}
+ (NSString *)longitude {
	return @"longitude";
}
+ (NSString *)name {
	return @"name";
}
+ (NSString *)specialInstruction {
	return @"specialInstruction";
}
@end

@implementation MTDeliveryDestinationRelationships 
+ (NSString *)relationship {
	return @"relationship";
}
@end

