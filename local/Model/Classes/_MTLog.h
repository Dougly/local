// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MTLog.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface MTLogID : NSManagedObjectID {}
@end

@interface _MTLog : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MTLogID *objectID;

@property (nonatomic, strong, nullable) NSNumber* isPresent;

@property (atomic) BOOL isPresentValue;
- (BOOL)isPresentValue;
- (void)setIsPresentValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSNumber* jobId;

@property (atomic) int64_t jobIdValue;
- (int64_t)jobIdValue;
- (void)setJobIdValue:(int64_t)value_;

@property (nonatomic, strong, nullable) NSDate* loadArrivalDate;

@property (nonatomic, strong, nullable) NSString* loadingSiteAddress;

@property (nonatomic, strong, nullable) NSNumber* loadingSiteLatitude;

@property (atomic) double loadingSiteLatitudeValue;
- (double)loadingSiteLatitudeValue;
- (void)setLoadingSiteLatitudeValue:(double)value_;

@property (nonatomic, strong, nullable) NSNumber* loadingSiteLongitude;

@property (atomic) double loadingSiteLongitudeValue;
- (double)loadingSiteLongitudeValue;
- (void)setLoadingSiteLongitudeValue:(double)value_;

@property (nonatomic, strong, nullable) NSString* loadingSiteName;

@property (nonatomic, strong, nullable) NSNumber* orderId;

@property (atomic) int64_t orderIdValue;
- (int64_t)orderIdValue;
- (void)setOrderIdValue:(int64_t)value_;

@property (nonatomic, strong, nullable) NSNumber* sandTicketNumber;

@property (atomic) int64_t sandTicketNumberValue;
- (int64_t)sandTicketNumberValue;
- (void)setSandTicketNumberValue:(int64_t)value_;

@property (nonatomic, strong, nullable) NSNumber* status;

@property (atomic) int32_t statusValue;
- (int32_t)statusValue;
- (void)setStatusValue:(int32_t)value_;

@property (nonatomic, strong, nullable) NSDate* wellDepartDate;

@property (nonatomic, strong, nullable) NSString* wellSiteAddress;

@property (nonatomic, strong, nullable) NSNumber* wellSiteLatitude;

@property (atomic) double wellSiteLatitudeValue;
- (double)wellSiteLatitudeValue;
- (void)setWellSiteLatitudeValue:(double)value_;

@property (nonatomic, strong, nullable) NSNumber* wellSiteLongitude;

@property (atomic) double wellSiteLongitudeValue;
- (double)wellSiteLongitudeValue;
- (void)setWellSiteLongitudeValue:(double)value_;

@property (nonatomic, strong, nullable) NSString* wellSiteName;

@end

@interface _MTLog (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSNumber*)primitiveIsPresent;
- (void)setPrimitiveIsPresent:(nullable NSNumber*)value;

- (BOOL)primitiveIsPresentValue;
- (void)setPrimitiveIsPresentValue:(BOOL)value_;

- (nullable NSNumber*)primitiveJobId;
- (void)setPrimitiveJobId:(nullable NSNumber*)value;

- (int64_t)primitiveJobIdValue;
- (void)setPrimitiveJobIdValue:(int64_t)value_;

- (nullable NSDate*)primitiveLoadArrivalDate;
- (void)setPrimitiveLoadArrivalDate:(nullable NSDate*)value;

- (nullable NSString*)primitiveLoadingSiteAddress;
- (void)setPrimitiveLoadingSiteAddress:(nullable NSString*)value;

- (nullable NSNumber*)primitiveLoadingSiteLatitude;
- (void)setPrimitiveLoadingSiteLatitude:(nullable NSNumber*)value;

- (double)primitiveLoadingSiteLatitudeValue;
- (void)setPrimitiveLoadingSiteLatitudeValue:(double)value_;

- (nullable NSNumber*)primitiveLoadingSiteLongitude;
- (void)setPrimitiveLoadingSiteLongitude:(nullable NSNumber*)value;

- (double)primitiveLoadingSiteLongitudeValue;
- (void)setPrimitiveLoadingSiteLongitudeValue:(double)value_;

- (nullable NSString*)primitiveLoadingSiteName;
- (void)setPrimitiveLoadingSiteName:(nullable NSString*)value;

- (nullable NSNumber*)primitiveOrderId;
- (void)setPrimitiveOrderId:(nullable NSNumber*)value;

- (int64_t)primitiveOrderIdValue;
- (void)setPrimitiveOrderIdValue:(int64_t)value_;

- (nullable NSNumber*)primitiveSandTicketNumber;
- (void)setPrimitiveSandTicketNumber:(nullable NSNumber*)value;

- (int64_t)primitiveSandTicketNumberValue;
- (void)setPrimitiveSandTicketNumberValue:(int64_t)value_;

- (nullable NSNumber*)primitiveStatus;
- (void)setPrimitiveStatus:(nullable NSNumber*)value;

- (int32_t)primitiveStatusValue;
- (void)setPrimitiveStatusValue:(int32_t)value_;

- (nullable NSDate*)primitiveWellDepartDate;
- (void)setPrimitiveWellDepartDate:(nullable NSDate*)value;

- (nullable NSString*)primitiveWellSiteAddress;
- (void)setPrimitiveWellSiteAddress:(nullable NSString*)value;

- (nullable NSNumber*)primitiveWellSiteLatitude;
- (void)setPrimitiveWellSiteLatitude:(nullable NSNumber*)value;

- (double)primitiveWellSiteLatitudeValue;
- (void)setPrimitiveWellSiteLatitudeValue:(double)value_;

- (nullable NSNumber*)primitiveWellSiteLongitude;
- (void)setPrimitiveWellSiteLongitude:(nullable NSNumber*)value;

- (double)primitiveWellSiteLongitudeValue;
- (void)setPrimitiveWellSiteLongitudeValue:(double)value_;

- (nullable NSString*)primitiveWellSiteName;
- (void)setPrimitiveWellSiteName:(nullable NSString*)value;

@end

@interface MTLogAttributes: NSObject 
+ (NSString *)isPresent;
+ (NSString *)jobId;
+ (NSString *)loadArrivalDate;
+ (NSString *)loadingSiteAddress;
+ (NSString *)loadingSiteLatitude;
+ (NSString *)loadingSiteLongitude;
+ (NSString *)loadingSiteName;
+ (NSString *)orderId;
+ (NSString *)sandTicketNumber;
+ (NSString *)status;
+ (NSString *)wellDepartDate;
+ (NSString *)wellSiteAddress;
+ (NSString *)wellSiteLatitude;
+ (NSString *)wellSiteLongitude;
+ (NSString *)wellSiteName;
@end

NS_ASSUME_NONNULL_END
