// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MTProfile.m instead.

#import "_MTProfile.h"

@implementation MTProfileID
@end

@implementation _MTProfile

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MTProfile" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MTProfile";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MTProfile" inManagedObjectContext:moc_];
}

- (MTProfileID*)objectID {
	return (MTProfileID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic carrierName;

@dynamic certificates;

@dynamic contactNumber;

@dynamic email;

@dynamic licenseUrl;

@dynamic name;

@dynamic profilePhoto;

@dynamic trailerNumer;

@dynamic truckNumber;

@end

@implementation MTProfileAttributes 
+ (NSString *)carrierName {
	return @"carrierName";
}
+ (NSString *)certificates {
	return @"certificates";
}
+ (NSString *)contactNumber {
	return @"contactNumber";
}
+ (NSString *)email {
	return @"email";
}
+ (NSString *)licenseUrl {
	return @"licenseUrl";
}
+ (NSString *)name {
	return @"name";
}
+ (NSString *)profilePhoto {
	return @"profilePhoto";
}
+ (NSString *)trailerNumer {
	return @"trailerNumer";
}
+ (NSString *)truckNumber {
	return @"truckNumber";
}
@end

