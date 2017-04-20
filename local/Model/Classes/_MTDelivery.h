// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MTDelivery.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class MTDeliveryDestination;
@class MTDeliveryDetails;
@class MTDeliveryOrigin;
@class MTDeliverySandTicket;

@interface MTDeliveryID : NSManagedObjectID {}
@end

@interface _MTDelivery : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MTDeliveryID *objectID;

@property (nonatomic, strong, nullable) NSDate* expectedDeliveryTime;

@property (nonatomic, strong, nullable) NSDate* pickupTime;

@property (nonatomic, strong, nullable) MTDeliveryDestination *destination;

@property (nonatomic, strong, nullable) MTDeliveryDetails *details;

@property (nonatomic, strong, nullable) MTDeliveryOrigin *origin;

@property (nonatomic, strong, nullable) NSSet<MTDeliverySandTicket*> *sandTickets;
- (nullable NSMutableSet<MTDeliverySandTicket*>*)sandTicketsSet;

@end

@interface _MTDelivery (SandTicketsCoreDataGeneratedAccessors)
- (void)addSandTickets:(NSSet<MTDeliverySandTicket*>*)value_;
- (void)removeSandTickets:(NSSet<MTDeliverySandTicket*>*)value_;
- (void)addSandTicketsObject:(MTDeliverySandTicket*)value_;
- (void)removeSandTicketsObject:(MTDeliverySandTicket*)value_;

@end

@interface _MTDelivery (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSDate*)primitiveExpectedDeliveryTime;
- (void)setPrimitiveExpectedDeliveryTime:(nullable NSDate*)value;

- (nullable NSDate*)primitivePickupTime;
- (void)setPrimitivePickupTime:(nullable NSDate*)value;

- (MTDeliveryDestination*)primitiveDestination;
- (void)setPrimitiveDestination:(MTDeliveryDestination*)value;

- (MTDeliveryDetails*)primitiveDetails;
- (void)setPrimitiveDetails:(MTDeliveryDetails*)value;

- (MTDeliveryOrigin*)primitiveOrigin;
- (void)setPrimitiveOrigin:(MTDeliveryOrigin*)value;

- (NSMutableSet<MTDeliverySandTicket*>*)primitiveSandTickets;
- (void)setPrimitiveSandTickets:(NSMutableSet<MTDeliverySandTicket*>*)value;

@end

@interface MTDeliveryAttributes: NSObject 
+ (NSString *)expectedDeliveryTime;
+ (NSString *)pickupTime;
@end

@interface MTDeliveryRelationships: NSObject
+ (NSString *)destination;
+ (NSString *)details;
+ (NSString *)origin;
+ (NSString *)sandTickets;
@end

NS_ASSUME_NONNULL_END
