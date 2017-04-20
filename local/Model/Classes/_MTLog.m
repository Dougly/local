// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MTLog.m instead.

#import "_MTLog.h"

@implementation MTLogID
@end

@implementation _MTLog

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MTLog" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MTLog";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MTLog" inManagedObjectContext:moc_];
}

- (MTLogID*)objectID {
	return (MTLogID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"isPresentValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isPresent"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"jobIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"jobId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"loadingSiteLatitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"loadingSiteLatitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"loadingSiteLongitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"loadingSiteLongitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"orderIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"orderId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"sandTicketNumberValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"sandTicketNumber"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"statusValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"status"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"wellSiteLatitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"wellSiteLatitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"wellSiteLongitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"wellSiteLongitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic isPresent;

- (BOOL)isPresentValue {
	NSNumber *result = [self isPresent];
	return [result boolValue];
}

- (void)setIsPresentValue:(BOOL)value_ {
	[self setIsPresent:@(value_)];
}

- (BOOL)primitiveIsPresentValue {
	NSNumber *result = [self primitiveIsPresent];
	return [result boolValue];
}

- (void)setPrimitiveIsPresentValue:(BOOL)value_ {
	[self setPrimitiveIsPresent:@(value_)];
}

@dynamic jobId;

- (int64_t)jobIdValue {
	NSNumber *result = [self jobId];
	return [result longLongValue];
}

- (void)setJobIdValue:(int64_t)value_ {
	[self setJobId:@(value_)];
}

- (int64_t)primitiveJobIdValue {
	NSNumber *result = [self primitiveJobId];
	return [result longLongValue];
}

- (void)setPrimitiveJobIdValue:(int64_t)value_ {
	[self setPrimitiveJobId:@(value_)];
}

@dynamic loadArrivalDate;

@dynamic loadingSiteAddress;

@dynamic loadingSiteLatitude;

- (double)loadingSiteLatitudeValue {
	NSNumber *result = [self loadingSiteLatitude];
	return [result doubleValue];
}

- (void)setLoadingSiteLatitudeValue:(double)value_ {
	[self setLoadingSiteLatitude:@(value_)];
}

- (double)primitiveLoadingSiteLatitudeValue {
	NSNumber *result = [self primitiveLoadingSiteLatitude];
	return [result doubleValue];
}

- (void)setPrimitiveLoadingSiteLatitudeValue:(double)value_ {
	[self setPrimitiveLoadingSiteLatitude:@(value_)];
}

@dynamic loadingSiteLongitude;

- (double)loadingSiteLongitudeValue {
	NSNumber *result = [self loadingSiteLongitude];
	return [result doubleValue];
}

- (void)setLoadingSiteLongitudeValue:(double)value_ {
	[self setLoadingSiteLongitude:@(value_)];
}

- (double)primitiveLoadingSiteLongitudeValue {
	NSNumber *result = [self primitiveLoadingSiteLongitude];
	return [result doubleValue];
}

- (void)setPrimitiveLoadingSiteLongitudeValue:(double)value_ {
	[self setPrimitiveLoadingSiteLongitude:@(value_)];
}

@dynamic loadingSiteName;

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

@dynamic sandTicketNumber;

- (int64_t)sandTicketNumberValue {
	NSNumber *result = [self sandTicketNumber];
	return [result longLongValue];
}

- (void)setSandTicketNumberValue:(int64_t)value_ {
	[self setSandTicketNumber:@(value_)];
}

- (int64_t)primitiveSandTicketNumberValue {
	NSNumber *result = [self primitiveSandTicketNumber];
	return [result longLongValue];
}

- (void)setPrimitiveSandTicketNumberValue:(int64_t)value_ {
	[self setPrimitiveSandTicketNumber:@(value_)];
}

@dynamic status;

- (int32_t)statusValue {
	NSNumber *result = [self status];
	return [result intValue];
}

- (void)setStatusValue:(int32_t)value_ {
	[self setStatus:@(value_)];
}

- (int32_t)primitiveStatusValue {
	NSNumber *result = [self primitiveStatus];
	return [result intValue];
}

- (void)setPrimitiveStatusValue:(int32_t)value_ {
	[self setPrimitiveStatus:@(value_)];
}

@dynamic wellDepartDate;

@dynamic wellSiteAddress;

@dynamic wellSiteLatitude;

- (double)wellSiteLatitudeValue {
	NSNumber *result = [self wellSiteLatitude];
	return [result doubleValue];
}

- (void)setWellSiteLatitudeValue:(double)value_ {
	[self setWellSiteLatitude:@(value_)];
}

- (double)primitiveWellSiteLatitudeValue {
	NSNumber *result = [self primitiveWellSiteLatitude];
	return [result doubleValue];
}

- (void)setPrimitiveWellSiteLatitudeValue:(double)value_ {
	[self setPrimitiveWellSiteLatitude:@(value_)];
}

@dynamic wellSiteLongitude;

- (double)wellSiteLongitudeValue {
	NSNumber *result = [self wellSiteLongitude];
	return [result doubleValue];
}

- (void)setWellSiteLongitudeValue:(double)value_ {
	[self setWellSiteLongitude:@(value_)];
}

- (double)primitiveWellSiteLongitudeValue {
	NSNumber *result = [self primitiveWellSiteLongitude];
	return [result doubleValue];
}

- (void)setPrimitiveWellSiteLongitudeValue:(double)value_ {
	[self setPrimitiveWellSiteLongitude:@(value_)];
}

@dynamic wellSiteName;

@end

@implementation MTLogAttributes 
+ (NSString *)isPresent {
	return @"isPresent";
}
+ (NSString *)jobId {
	return @"jobId";
}
+ (NSString *)loadArrivalDate {
	return @"loadArrivalDate";
}
+ (NSString *)loadingSiteAddress {
	return @"loadingSiteAddress";
}
+ (NSString *)loadingSiteLatitude {
	return @"loadingSiteLatitude";
}
+ (NSString *)loadingSiteLongitude {
	return @"loadingSiteLongitude";
}
+ (NSString *)loadingSiteName {
	return @"loadingSiteName";
}
+ (NSString *)orderId {
	return @"orderId";
}
+ (NSString *)sandTicketNumber {
	return @"sandTicketNumber";
}
+ (NSString *)status {
	return @"status";
}
+ (NSString *)wellDepartDate {
	return @"wellDepartDate";
}
+ (NSString *)wellSiteAddress {
	return @"wellSiteAddress";
}
+ (NSString *)wellSiteLatitude {
	return @"wellSiteLatitude";
}
+ (NSString *)wellSiteLongitude {
	return @"wellSiteLongitude";
}
+ (NSString *)wellSiteName {
	return @"wellSiteName";
}
@end

