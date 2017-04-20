// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MTPreviousVehicle.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface MTPreviousVehicleID : NSManagedObjectID {}
@end

@interface _MTPreviousVehicle : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MTPreviousVehicleID *objectID;

@property (nonatomic, strong, nullable) NSString* trailerNumber;

@property (nonatomic, strong, nullable) NSString* truckNumber;

@end

@interface _MTPreviousVehicle (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSString*)primitiveTrailerNumber;
- (void)setPrimitiveTrailerNumber:(nullable NSString*)value;

- (nullable NSString*)primitiveTruckNumber;
- (void)setPrimitiveTruckNumber:(nullable NSString*)value;

@end

@interface MTPreviousVehicleAttributes: NSObject 
+ (NSString *)trailerNumber;
+ (NSString *)truckNumber;
@end

NS_ASSUME_NONNULL_END
