// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MTWeekdayText.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class MTPlaceDetails;

@interface MTWeekdayTextID : NSManagedObjectID {}
@end

@interface _MTWeekdayText : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MTWeekdayTextID *objectID;

@property (nonatomic, strong, nullable) NSNumber* day;

@property (atomic) int16_t dayValue;
- (int16_t)dayValue;
- (void)setDayValue:(int16_t)value_;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) MTPlaceDetails *parentDetails;

@end

@interface _MTWeekdayText (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSNumber*)primitiveDay;
- (void)setPrimitiveDay:(nullable NSNumber*)value;

- (int16_t)primitiveDayValue;
- (void)setPrimitiveDayValue:(int16_t)value_;

- (nullable NSString*)primitiveName;
- (void)setPrimitiveName:(nullable NSString*)value;

- (MTPlaceDetails*)primitiveParentDetails;
- (void)setPrimitiveParentDetails:(MTPlaceDetails*)value;

@end

@interface MTWeekdayTextAttributes: NSObject 
+ (NSString *)day;
+ (NSString *)name;
@end

@interface MTWeekdayTextRelationships: NSObject
+ (NSString *)parentDetails;
@end

NS_ASSUME_NONNULL_END
