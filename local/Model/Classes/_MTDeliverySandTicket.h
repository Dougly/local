// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MTDeliverySandTicket.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class MTDelivery;

@interface MTDeliverySandTicketID : NSManagedObjectID {}
@end

@interface _MTDeliverySandTicket : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MTDeliverySandTicketID *objectID;

@property (nonatomic, strong, nullable) NSString* url;

@property (nonatomic, strong, nullable) MTDelivery *relationship;

@end

@interface _MTDeliverySandTicket (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(nullable NSString*)value;

- (MTDelivery*)primitiveRelationship;
- (void)setPrimitiveRelationship:(MTDelivery*)value;

@end

@interface MTDeliverySandTicketAttributes: NSObject 
+ (NSString *)url;
@end

@interface MTDeliverySandTicketRelationships: NSObject
+ (NSString *)relationship;
@end

NS_ASSUME_NONNULL_END
