// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MTOpeningHourPeriod.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class MTPlaceDetails;

@interface MTOpeningHourPeriodID : NSManagedObjectID {}
@end

@interface _MTOpeningHourPeriod : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MTOpeningHourPeriodID *objectID;

@property (nonatomic, strong, nullable) NSNumber* closeDay;

@property (atomic) int16_t closeDayValue;
- (int16_t)closeDayValue;
- (void)setCloseDayValue:(int16_t)value_;

@property (nonatomic, strong, nullable) NSString* closeTime;

@property (nonatomic, strong, nullable) NSNumber* openDay;

@property (atomic) int16_t openDayValue;
- (int16_t)openDayValue;
- (void)setOpenDayValue:(int16_t)value_;

@property (nonatomic, strong, nullable) NSString* openTime;

@property (nonatomic, strong, nullable) NSNumber* periodNumber;

@property (atomic) int16_t periodNumberValue;
- (int16_t)periodNumberValue;
- (void)setPeriodNumberValue:(int16_t)value_;

@property (nonatomic, strong, nullable) MTPlaceDetails *parentDetails;

@end

@interface _MTOpeningHourPeriod (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveCloseDay;
- (void)setPrimitiveCloseDay:(NSNumber*)value;

- (int16_t)primitiveCloseDayValue;
- (void)setPrimitiveCloseDayValue:(int16_t)value_;

- (NSString*)primitiveCloseTime;
- (void)setPrimitiveCloseTime:(NSString*)value;

- (NSNumber*)primitiveOpenDay;
- (void)setPrimitiveOpenDay:(NSNumber*)value;

- (int16_t)primitiveOpenDayValue;
- (void)setPrimitiveOpenDayValue:(int16_t)value_;

- (NSString*)primitiveOpenTime;
- (void)setPrimitiveOpenTime:(NSString*)value;

- (NSNumber*)primitivePeriodNumber;
- (void)setPrimitivePeriodNumber:(NSNumber*)value;

- (int16_t)primitivePeriodNumberValue;
- (void)setPrimitivePeriodNumberValue:(int16_t)value_;

- (MTPlaceDetails*)primitiveParentDetails;
- (void)setPrimitiveParentDetails:(MTPlaceDetails*)value;

@end

@interface MTOpeningHourPeriodAttributes: NSObject 
+ (NSString *)closeDay;
+ (NSString *)closeTime;
+ (NSString *)openDay;
+ (NSString *)openTime;
+ (NSString *)periodNumber;
@end

@interface MTOpeningHourPeriodRelationships: NSObject
+ (NSString *)parentDetails;
@end

NS_ASSUME_NONNULL_END
