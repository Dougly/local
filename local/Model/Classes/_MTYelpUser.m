// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MTYelpUser.m instead.

#import "_MTYelpUser.h"

@implementation MTYelpUserID
@end

@implementation _MTYelpUser

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MTYelpUser" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MTYelpUser";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MTYelpUser" inManagedObjectContext:moc_];
}

- (MTYelpUserID*)objectID {
	return (MTYelpUserID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic bearer;

@end

@implementation MTYelpUserAttributes 
+ (NSString *)bearer {
	return @"bearer";
}
@end

