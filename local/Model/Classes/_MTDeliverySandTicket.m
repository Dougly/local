// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MTDeliverySandTicket.m instead.

#import "_MTDeliverySandTicket.h"

@implementation MTDeliverySandTicketID
@end

@implementation _MTDeliverySandTicket

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MTDeliverySandTicket" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MTDeliverySandTicket";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MTDeliverySandTicket" inManagedObjectContext:moc_];
}

- (MTDeliverySandTicketID*)objectID {
	return (MTDeliverySandTicketID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic url;

@dynamic relationship;

@end

@implementation MTDeliverySandTicketAttributes 
+ (NSString *)url {
	return @"url";
}
@end

@implementation MTDeliverySandTicketRelationships 
+ (NSString *)relationship {
	return @"relationship";
}
@end

