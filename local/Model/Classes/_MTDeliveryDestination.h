// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MTDeliveryDestination.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class MTDelivery;

@interface MTDeliveryDestinationID : NSManagedObjectID {}
@end

@interface _MTDeliveryDestination : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MTDeliveryDestinationID *objectID;

@property (nonatomic, strong, nullable) NSString* address;

@property (nonatomic, strong, nullable) NSString* city;

@property (nonatomic, strong, nullable) NSNumber* contactNumber;

@property (atomic) int64_t contactNumberValue;
- (int64_t)contactNumberValue;
- (void)setContactNumberValue:(int64_t)value_;

@property (nonatomic, strong, nullable) NSNumber* latitude;

@property (atomic) double latitudeValue;
- (double)latitudeValue;
- (void)setLatitudeValue:(double)value_;

@property (nonatomic, strong, nullable) NSNumber* longitude;

@property (atomic) double longitudeValue;
- (double)longitudeValue;
- (void)setLongitudeValue:(double)value_;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSString* specialInstruction;

@property (nonatomic, strong, nullable) MTDelivery *relationship;

@end

@interface _MTDeliveryDestination (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSString*)primitiveAddress;
- (void)setPrimitiveAddress:(nullable NSString*)value;

- (nullable NSString*)primitiveCity;
- (void)setPrimitiveCity:(nullable NSString*)value;

- (nullable NSNumber*)primitiveContactNumber;
- (void)setPrimitiveContactNumber:(nullable NSNumber*)value;

- (int64_t)primitiveContactNumberValue;
- (void)setPrimitiveContactNumberValue:(int64_t)value_;

- (nullable NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(nullable NSNumber*)value;

- (double)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(double)value_;

- (nullable NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(nullable NSNumber*)value;

- (double)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(double)value_;

- (nullable NSString*)primitiveName;
- (void)setPrimitiveName:(nullable NSString*)value;

- (nullable NSString*)primitiveSpecialInstruction;
- (void)setPrimitiveSpecialInstruction:(nullable NSString*)value;

- (MTDelivery*)primitiveRelationship;
- (void)setPrimitiveRelationship:(MTDelivery*)value;

@end

@interface MTDeliveryDestinationAttributes: NSObject 
+ (NSString *)address;
+ (NSString *)city;
+ (NSString *)contactNumber;
+ (NSString *)latitude;
+ (NSString *)longitude;
+ (NSString *)name;
+ (NSString *)specialInstruction;
@end

@interface MTDeliveryDestinationRelationships: NSObject
+ (NSString *)relationship;
@end

NS_ASSUME_NONNULL_END
