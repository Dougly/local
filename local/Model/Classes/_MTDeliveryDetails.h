// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MTDeliveryDetails.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class MTDelivery;

@interface MTDeliveryDetailsID : NSManagedObjectID {}
@end

@interface _MTDeliveryDetails : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MTDeliveryDetailsID *objectID;

@property (nonatomic, strong, nullable) NSNumber* mileage;

@property (atomic) int32_t mileageValue;
- (int32_t)mileageValue;
- (void)setMileageValue:(int32_t)value_;

@property (nonatomic, strong, nullable) NSNumber* mt;

@property (atomic) int32_t mtValue;
- (int32_t)mtValue;
- (void)setMtValue:(int32_t)value_;

@property (nonatomic, strong, nullable) NSNumber* orderId;

@property (atomic) int64_t orderIdValue;
- (int64_t)orderIdValue;
- (void)setOrderIdValue:(int64_t)value_;

@property (nonatomic, strong, nullable) NSNumber* po;

@property (atomic) int32_t poValue;
- (int32_t)poValue;
- (void)setPoValue:(int32_t)value_;

@property (nonatomic, strong, nullable) NSNumber* status;

@property (atomic) int64_t statusValue;
- (int64_t)statusValue;
- (void)setStatusValue:(int64_t)value_;

@property (nonatomic, strong, nullable) NSString* type;

@property (nonatomic, strong, nullable) NSNumber* weight;

@property (atomic) int32_t weightValue;
- (int32_t)weightValue;
- (void)setWeightValue:(int32_t)value_;

@property (nonatomic, strong, nullable) MTDelivery *relationship;

@end

@interface _MTDeliveryDetails (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSNumber*)primitiveMileage;
- (void)setPrimitiveMileage:(nullable NSNumber*)value;

- (int32_t)primitiveMileageValue;
- (void)setPrimitiveMileageValue:(int32_t)value_;

- (nullable NSNumber*)primitiveMt;
- (void)setPrimitiveMt:(nullable NSNumber*)value;

- (int32_t)primitiveMtValue;
- (void)setPrimitiveMtValue:(int32_t)value_;

- (nullable NSNumber*)primitiveOrderId;
- (void)setPrimitiveOrderId:(nullable NSNumber*)value;

- (int64_t)primitiveOrderIdValue;
- (void)setPrimitiveOrderIdValue:(int64_t)value_;

- (nullable NSNumber*)primitivePo;
- (void)setPrimitivePo:(nullable NSNumber*)value;

- (int32_t)primitivePoValue;
- (void)setPrimitivePoValue:(int32_t)value_;

- (nullable NSNumber*)primitiveStatus;
- (void)setPrimitiveStatus:(nullable NSNumber*)value;

- (int64_t)primitiveStatusValue;
- (void)setPrimitiveStatusValue:(int64_t)value_;

- (nullable NSNumber*)primitiveWeight;
- (void)setPrimitiveWeight:(nullable NSNumber*)value;

- (int32_t)primitiveWeightValue;
- (void)setPrimitiveWeightValue:(int32_t)value_;

- (MTDelivery*)primitiveRelationship;
- (void)setPrimitiveRelationship:(MTDelivery*)value;

@end

@interface MTDeliveryDetailsAttributes: NSObject 
+ (NSString *)mileage;
+ (NSString *)mt;
+ (NSString *)orderId;
+ (NSString *)po;
+ (NSString *)status;
+ (NSString *)type;
+ (NSString *)weight;
@end

@interface MTDeliveryDetailsRelationships: NSObject
+ (NSString *)relationship;
@end

NS_ASSUME_NONNULL_END
