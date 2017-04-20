// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MTPreviousVehicle.m instead.

#import "_MTPreviousVehicle.h"

@implementation MTPreviousVehicleID
@end

@implementation _MTPreviousVehicle

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MTPreviousVehicle" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MTPreviousVehicle";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MTPreviousVehicle" inManagedObjectContext:moc_];
}

- (MTPreviousVehicleID*)objectID {
	return (MTPreviousVehicleID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic trailerNumber;

@dynamic truckNumber;

@end

@implementation MTPreviousVehicleAttributes 
+ (NSString *)trailerNumber {
	return @"trailerNumber";
}
+ (NSString *)truckNumber {
	return @"truckNumber";
}
@end

