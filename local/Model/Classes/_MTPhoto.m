// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MTPhoto.m instead.

#import "_MTPhoto.h"

@implementation MTPhotoID
@end

@implementation _MTPhoto

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MTPhoto" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MTPhoto";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MTPhoto" inManagedObjectContext:moc_];
}

- (MTPhotoID*)objectID {
	return (MTPhotoID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"heightValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"height"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"widthValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"width"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic height;

- (int32_t)heightValue {
	NSNumber *result = [self height];
	return [result intValue];
}

- (void)setHeightValue:(int32_t)value_ {
	[self setHeight:@(value_)];
}

- (int32_t)primitiveHeightValue {
	NSNumber *result = [self primitiveHeight];
	return [result intValue];
}

- (void)setPrimitiveHeightValue:(int32_t)value_ {
	[self setPrimitiveHeight:@(value_)];
}

@dynamic htmlAttributes;

@dynamic reference;

@dynamic width;

- (int32_t)widthValue {
	NSNumber *result = [self width];
	return [result intValue];
}

- (void)setWidthValue:(int32_t)value_ {
	[self setWidth:@(value_)];
}

- (int32_t)primitiveWidthValue {
	NSNumber *result = [self primitiveWidth];
	return [result intValue];
}

- (void)setPrimitiveWidthValue:(int32_t)value_ {
	[self setPrimitiveWidth:@(value_)];
}

@dynamic place;

- (NSMutableSet<MTPlace*>*)placeSet {
	[self willAccessValueForKey:@"place"];

	NSMutableSet<MTPlace*> *result = (NSMutableSet<MTPlace*>*)[self mutableSetValueForKey:@"place"];

	[self didAccessValueForKey:@"place"];
	return result;
}

@end

@implementation MTPhotoAttributes 
+ (NSString *)height {
	return @"height";
}
+ (NSString *)htmlAttributes {
	return @"htmlAttributes";
}
+ (NSString *)reference {
	return @"reference";
}
+ (NSString *)width {
	return @"width";
}
@end

@implementation MTPhotoRelationships 
+ (NSString *)place {
	return @"place";
}
@end

