// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MTDeliveryDetails.m instead.

#import "_MTDeliveryDetails.h"

@implementation MTDeliveryDetailsID
@end

@implementation _MTDeliveryDetails

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MTDeliveryDetails" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MTDeliveryDetails";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MTDeliveryDetails" inManagedObjectContext:moc_];
}

- (MTDeliveryDetailsID*)objectID {
	return (MTDeliveryDetailsID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"mileageValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"mileage"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"mtValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"mt"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"orderIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"orderId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"poValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"po"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"statusValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"status"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"weightValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"weight"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic mileage;

- (int32_t)mileageValue {
	NSNumber *result = [self mileage];
	return [result intValue];
}

- (void)setMileageValue:(int32_t)value_ {
	[self setMileage:@(value_)];
}

- (int32_t)primitiveMileageValue {
	NSNumber *result = [self primitiveMileage];
	return [result intValue];
}

- (void)setPrimitiveMileageValue:(int32_t)value_ {
	[self setPrimitiveMileage:@(value_)];
}

@dynamic mt;

- (int32_t)mtValue {
	NSNumber *result = [self mt];
	return [result intValue];
}

- (void)setMtValue:(int32_t)value_ {
	[self setMt:@(value_)];
}

- (int32_t)primitiveMtValue {
	NSNumber *result = [self primitiveMt];
	return [result intValue];
}

- (void)setPrimitiveMtValue:(int32_t)value_ {
	[self setPrimitiveMt:@(value_)];
}

@dynamic orderId;

- (int64_t)orderIdValue {
	NSNumber *result = [self orderId];
	return [result longLongValue];
}

- (void)setOrderIdValue:(int64_t)value_ {
	[self setOrderId:@(value_)];
}

- (int64_t)primitiveOrderIdValue {
	NSNumber *result = [self primitiveOrderId];
	return [result longLongValue];
}

- (void)setPrimitiveOrderIdValue:(int64_t)value_ {
	[self setPrimitiveOrderId:@(value_)];
}

@dynamic po;

- (int32_t)poValue {
	NSNumber *result = [self po];
	return [result intValue];
}

- (void)setPoValue:(int32_t)value_ {
	[self setPo:@(value_)];
}

- (int32_t)primitivePoValue {
	NSNumber *result = [self primitivePo];
	return [result intValue];
}

- (void)setPrimitivePoValue:(int32_t)value_ {
	[self setPrimitivePo:@(value_)];
}

@dynamic status;

- (int64_t)statusValue {
	NSNumber *result = [self status];
	return [result longLongValue];
}

- (void)setStatusValue:(int64_t)value_ {
	[self setStatus:@(value_)];
}

- (int64_t)primitiveStatusValue {
	NSNumber *result = [self primitiveStatus];
	return [result longLongValue];
}

- (void)setPrimitiveStatusValue:(int64_t)value_ {
	[self setPrimitiveStatus:@(value_)];
}

@dynamic type;

@dynamic weight;

- (int32_t)weightValue {
	NSNumber *result = [self weight];
	return [result intValue];
}

- (void)setWeightValue:(int32_t)value_ {
	[self setWeight:@(value_)];
}

- (int32_t)primitiveWeightValue {
	NSNumber *result = [self primitiveWeight];
	return [result intValue];
}

- (void)setPrimitiveWeightValue:(int32_t)value_ {
	[self setPrimitiveWeight:@(value_)];
}

@dynamic relationship;

@end

@implementation MTDeliveryDetailsAttributes 
+ (NSString *)mileage {
	return @"mileage";
}
+ (NSString *)mt {
	return @"mt";
}
+ (NSString *)orderId {
	return @"orderId";
}
+ (NSString *)po {
	return @"po";
}
+ (NSString *)status {
	return @"status";
}
+ (NSString *)type {
	return @"type";
}
+ (NSString *)weight {
	return @"weight";
}
@end

@implementation MTDeliveryDetailsRelationships 
+ (NSString *)relationship {
	return @"relationship";
}
@end

