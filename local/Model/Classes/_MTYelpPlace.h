// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MTYelpPlace.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface MTYelpPlaceID : NSManagedObjectID {}
@end

@interface _MTYelpPlace : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MTYelpPlaceID *objectID;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSNumber* rating;

@property (atomic) float ratingValue;
- (float)ratingValue;
- (void)setRatingValue:(float)value_;

@end

@interface _MTYelpPlace (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSString*)primitiveName;
- (void)setPrimitiveName:(nullable NSString*)value;

- (nullable NSNumber*)primitiveRating;
- (void)setPrimitiveRating:(nullable NSNumber*)value;

- (float)primitiveRatingValue;
- (void)setPrimitiveRatingValue:(float)value_;

@end

@interface MTYelpPlaceAttributes: NSObject 
+ (NSString *)name;
+ (NSString *)rating;
@end

NS_ASSUME_NONNULL_END
