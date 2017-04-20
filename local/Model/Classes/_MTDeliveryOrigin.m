// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MTDeliveryOrigin.m instead.

#import "_MTDeliveryOrigin.h"

@implementation MTDeliveryOriginID
@end

@implementation _MTDeliveryOrigin

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MTDeliveryOrigin" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MTDeliveryOrigin";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MTDeliveryOrigin" inManagedObjectContext:moc_];
}

- (MTDeliveryOriginID*)objectID {
	return (MTDeliveryOriginID*)[super objectID];
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

@dynamic loadingInstruction;

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

@dynamic relationship;

@end

@implementation MTDeliveryOriginAttributes 
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
+ (NSString *)loadingInstruction {
	return @"loadingInstruction";
}
+ (NSString *)longitude {
	return @"longitude";
}
+ (NSString *)name {
	return @"name";
}
@end

@implementation MTDeliveryOriginRelationships 
+ (NSString *)relationship {
	return @"relationship";
}
@end

