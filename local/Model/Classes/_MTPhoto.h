// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MTPhoto.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class MTPlace;
@class MTPlaceDetails;

@interface MTPhotoID : NSManagedObjectID {}
@end

@interface _MTPhoto : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MTPhotoID *objectID;

@property (nonatomic, strong, nullable) NSNumber* height;

@property (atomic) int32_t heightValue;
- (int32_t)heightValue;
- (void)setHeightValue:(int32_t)value_;

@property (nonatomic, strong, nullable) NSString* htmlAttributes;

@property (nonatomic, strong, nullable) NSString* reference;

@property (nonatomic, strong, nullable) NSNumber* width;

@property (atomic) int32_t widthValue;
- (int32_t)widthValue;
- (void)setWidthValue:(int32_t)value_;

@property (nonatomic, strong, nullable) MTPlace *place;

@property (nonatomic, strong, nullable) MTPlaceDetails *placeDetails;

@end

@interface _MTPhoto (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSNumber*)primitiveHeight;
- (void)setPrimitiveHeight:(nullable NSNumber*)value;

- (int32_t)primitiveHeightValue;
- (void)setPrimitiveHeightValue:(int32_t)value_;

- (nullable NSString*)primitiveHtmlAttributes;
- (void)setPrimitiveHtmlAttributes:(nullable NSString*)value;

- (nullable NSString*)primitiveReference;
- (void)setPrimitiveReference:(nullable NSString*)value;

- (nullable NSNumber*)primitiveWidth;
- (void)setPrimitiveWidth:(nullable NSNumber*)value;

- (int32_t)primitiveWidthValue;
- (void)setPrimitiveWidthValue:(int32_t)value_;

- (MTPlace*)primitivePlace;
- (void)setPrimitivePlace:(MTPlace*)value;

- (MTPlaceDetails*)primitivePlaceDetails;
- (void)setPrimitivePlaceDetails:(MTPlaceDetails*)value;

@end

@interface MTPhotoAttributes: NSObject 
+ (NSString *)height;
+ (NSString *)htmlAttributes;
+ (NSString *)reference;
+ (NSString *)width;
@end

@interface MTPhotoRelationships: NSObject
+ (NSString *)place;
+ (NSString *)placeDetails;
@end

NS_ASSUME_NONNULL_END
