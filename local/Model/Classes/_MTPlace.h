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
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MTPlaceID *objectID;

@property (nonatomic, strong, nullable) NSNumber* distance;

@property (atomic) float distanceValue;
- (float)distanceValue;
- (void)setDistanceValue:(float)value_;

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

- (NSNumber*)primitiveDistance;
- (void)setPrimitiveDistance:(NSNumber*)value;

- (float)primitiveDistanceValue;
- (void)setPrimitiveDistanceValue:(float)value_;

- (NSString*)primitiveFormattedAddress;
- (void)setPrimitiveFormattedAddress:(NSString*)value;

- (NSString*)primitiveIcon;
- (void)setPrimitiveIcon:(NSString*)value;

- (NSNumber*)primitiveIsOpenNow;
- (void)setPrimitiveIsOpenNow:(NSNumber*)value;

- (BOOL)primitiveIsOpenNowValue;
- (void)setPrimitiveIsOpenNowValue:(BOOL)value_;

- (NSNumber*)primitiveLat;
- (void)setPrimitiveLat:(NSNumber*)value;

- (float)primitiveLatValue;
- (void)setPrimitiveLatValue:(float)value_;

- (NSNumber*)primitiveLon;
- (void)setPrimitiveLon:(NSNumber*)value;

- (float)primitiveLonValue;
- (void)setPrimitiveLonValue:(float)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitivePlaceId;
- (void)setPrimitivePlaceId:(NSString*)value;

- (NSNumber*)primitivePricingLevel;
- (void)setPrimitivePricingLevel:(NSNumber*)value;

- (int16_t)primitivePricingLevelValue;
- (void)setPrimitivePricingLevelValue:(int16_t)value_;

- (NSNumber*)primitiveRating;
- (void)setPrimitiveRating:(NSNumber*)value;

- (float)primitiveRatingValue;
- (void)setPrimitiveRatingValue:(float)value_;

- (NSString*)primitiveReference;
- (void)setPrimitiveReference:(NSString*)value;

- (NSString*)primitiveScope;
- (void)setPrimitiveScope:(NSString*)value;

- (NSString*)primitiveTypes;
- (void)setPrimitiveTypes:(NSString*)value;

- (NSString*)primitiveUniqueId;
- (void)setPrimitiveUniqueId:(NSString*)value;

- (NSString*)primitiveVincinity;
- (void)setPrimitiveVincinity:(NSString*)value;

- (NSMutableSet<MTPhoto*>*)primitivePhotos;
- (void)setPrimitivePhotos:(NSMutableSet<MTPhoto*>*)value;

@end

@interface MTPlaceAttributes: NSObject 
+ (NSString *)distance;
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
