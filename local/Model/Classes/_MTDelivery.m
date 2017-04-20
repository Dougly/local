// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MTDelivery.m instead.

#import "_MTDelivery.h"

@implementation MTDeliveryID
@end

@implementation _MTDelivery

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MTDelivery" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MTDelivery";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MTDelivery" inManagedObjectContext:moc_];
}

- (MTDeliveryID*)objectID {
	return (MTDeliveryID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic expectedDeliveryTime;

@dynamic pickupTime;

@dynamic destination;

@dynamic details;

@dynamic origin;

@dynamic sandTickets;

- (NSMutableSet<MTDeliverySandTicket*>*)sandTicketsSet {
	[self willAccessValueForKey:@"sandTickets"];

	NSMutableSet<MTDeliverySandTicket*> *result = (NSMutableSet<MTDeliverySandTicket*>*)[self mutableSetValueForKey:@"sandTickets"];

	[self didAccessValueForKey:@"sandTickets"];
	return result;
}

@end

@implementation MTDeliveryAttributes 
+ (NSString *)expectedDeliveryTime {
	return @"expectedDeliveryTime";
}
+ (NSString *)pickupTime {
	return @"pickupTime";
}
@end

@implementation MTDeliveryRelationships 
+ (NSString *)destination {
	return @"destination";
}
+ (NSString *)details {
	return @"details";
}
+ (NSString *)origin {
	return @"origin";
}
+ (NSString *)sandTickets {
	return @"sandTickets";
}
@end

