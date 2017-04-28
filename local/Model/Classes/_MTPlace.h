// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MTPlace.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class MTPhoto;

@interface MTPlaceID : NSManagedObjectID {}
@end

@interface _MTPlace : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MTPlaceID *objectID;

@property (nonatomic, strong, nullable) NSString* formattedAddress;

@property (nonatomic, strong, nullable) NSString* icon;

@property (nonatomic, strong, nullable) NSNumber* isOpenNow;

@property (atomic) BOOL isOpenNowValue;
- (BOOL)isOpenNowValue;
- (void)setIsOpenNowValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSNumber* lat;

@property (atomic) float latValue;
- (float)latValue;
- (void)setLatValue:(float)value_;

@property (nonatomic, strong, nullable) NSNumber* lon;

@property (atomic) float lonValue;
- (float)lonValue;
- (void)setLonValue:(float)value_;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSString* placeId;

@property (nonatomic, strong, nullable) NSNumber* pricingLevel;

@property (atomic) int16_t pricingLevelValue;
- (int16_t)pricingLevelValue;
- (void)setPricingLevelValue:(int16_t)value_;

@property (nonatomic, strong, nullable) NSNumber* rating;

@property (atomic) float ratingValue;
- (float)ratingValue;
- (void)setRatingValue:(float)value_;

@property (nonatomic, strong, nullable) NSString* reference;

@property (nonatomic, strong, nullable) NSString* scope;

@property (nonatomic, strong, nullable) NSString* types;

@property (nonatomic, strong, nullable) NSString* uniqueId;

@property (nonatomic, strong, nullable) NSString* vincinity;

@property (nonatomic, strong, nullable) NSSet<MTPhoto*> *photos;
- (nullable NSMutableSet<MTPhoto*>*)photosSet;

@end

@interface _MTPlace (PhotosCoreDataGeneratedAccessors)
- (void)addPhotos:(NSSet<MTPhoto*>*)value_;
- (void)removePhotos:(NSSet<MTPhoto*>*)value_;
- (void)addPhotosObject:(MTPhoto*)value_;
- (void)removePhotosObject:(MTPhoto*)value_;

@end

@interface _MTPlace (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSString*)primitiveFormattedAddress;
- (void)setPrimitiveFormattedAddress:(nullable NSString*)value;

- (nullable NSString*)primitiveIcon;
- (void)setPrimitiveIcon:(nullable NSString*)value;

- (nullable NSNumber*)primitiveIsOpenNow;
- (void)setPrimitiveIsOpenNow:(nullable NSNumber*)value;

- (BOOL)primitiveIsOpenNowValue;
- (void)setPrimitiveIsOpenNowValue:(BOOL)value_;

- (nullable NSNumber*)primitiveLat;
- (void)setPrimitiveLat:(nullable NSNumber*)value;

- (float)primitiveLatValue;
- (void)setPrimitiveLatValue:(float)value_;

- (nullable NSNumber*)primitiveLon;
- (void)setPrimitiveLon:(nullable NSNumber*)value;

- (float)primitiveLonValue;
- (void)setPrimitiveLonValue:(float)value_;

- (nullable NSString*)primitiveName;
- (void)setPrimitiveName:(nullable NSString*)value;

- (nullable NSString*)primitivePlaceId;
- (void)setPrimitivePlaceId:(nullable NSString*)value;

- (nullable NSNumber*)primitivePricingLevel;
- (void)setPrimitivePricingLevel:(nullable NSNumber*)value;

- (int16_t)primitivePricingLevelValue;
- (void)setPrimitivePricingLevelValue:(int16_t)value_;

- (nullable NSNumber*)primitiveRating;
- (void)setPrimitiveRating:(nullable NSNumber*)value;

- (float)primitiveRatingValue;
- (void)setPrimitiveRatingValue:(float)value_;

- (nullable NSString*)primitiveReference;
- (void)setPrimitiveReference:(nullable NSString*)value;

- (nullable NSString*)primitiveScope;
- (void)setPrimitiveScope:(nullable NSString*)value;

- (nullable NSString*)primitiveTypes;
- (void)setPrimitiveTypes:(nullable NSString*)value;

- (nullable NSString*)primitiveUniqueId;
- (void)setPrimitiveUniqueId:(nullable NSString*)value;

- (nullable NSString*)primitiveVincinity;
- (void)setPrimitiveVincinity:(nullable NSString*)value;

- (NSMutableSet<MTPhoto*>*)primitivePhotos;
- (void)setPrimitivePhotos:(NSMutableSet<MTPhoto*>*)value;

@end

@interface MTPlaceAttributes: NSObject 
+ (NSString *)formattedAddress;
+ (NSString *)icon;
+ (NSString *)isOpenNow;
+ (NSString *)lat;
+ (NSString *)lon;
+ (NSString *)name;
+ (NSString *)placeId;
+ (NSString *)pricingLevel;
+ (NSString *)rating;
+ (NSString *)reference;
+ (NSString *)scope;
+ (NSString *)types;
+ (NSString *)uniqueId;
+ (NSString *)vincinity;
@end

@interface MTPlaceRelationships: NSObject
+ (NSString *)photos;
@end

NS_ASSUME_NONNULL_END
