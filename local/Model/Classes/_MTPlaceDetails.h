// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MTPlaceDetails.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class MTOpeningHourPeriod;
@class MTPhoto;
@class MTPlaceReview;
@class MTWeekdayText;

@interface MTPlaceDetailsID : NSManagedObjectID {}
@end

@interface _MTPlaceDetails : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MTPlaceDetailsID *objectID;

@property (nonatomic, strong, nullable) NSString* adminLevel2;

@property (nonatomic, strong, nullable) NSString* formattedAddress;

@property (nonatomic, strong, nullable) NSString* internationalPhone;

@property (nonatomic, strong, nullable) NSNumber* isOpenNow;

@property (atomic) BOOL isOpenNowValue;
- (BOOL)isOpenNowValue;
- (void)setIsOpenNowValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSNumber* lat;

@property (atomic) float latValue;
- (float)latValue;
- (void)setLatValue:(float)value_;

@property (nonatomic, strong, nullable) NSString* localPhone;

@property (nonatomic, strong, nullable) NSNumber* lon;

@property (atomic) float lonValue;
- (float)lonValue;
- (void)setLonValue:(float)value_;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSString* neighbourhood;

@property (nonatomic, strong, nullable) NSNumber* rating;

@property (atomic) float ratingValue;
- (float)ratingValue;
- (void)setRatingValue:(float)value_;

@property (nonatomic, strong, nullable) NSString* streetName;

@property (nonatomic, strong, nullable) NSString* streetNumber;

@property (nonatomic, strong, nullable) NSString* sublocality;

@property (nonatomic, strong, nullable) NSString* vincinity;

@property (nonatomic, strong, nullable) NSString* website;

@property (nonatomic, strong, nullable) NSSet<MTOpeningHourPeriod*> *openingHoursPeriods;
- (nullable NSMutableSet<MTOpeningHourPeriod*>*)openingHoursPeriodsSet;

@property (nonatomic, strong, nullable) NSSet<MTPhoto*> *photos;
- (nullable NSMutableSet<MTPhoto*>*)photosSet;

@property (nonatomic, strong, nullable) NSSet<MTPlaceReview*> *reviews;
- (nullable NSMutableSet<MTPlaceReview*>*)reviewsSet;

@property (nonatomic, strong, nullable) NSSet<MTWeekdayText*> *weekdayTexts;
- (nullable NSMutableSet<MTWeekdayText*>*)weekdayTextsSet;

@end

@interface _MTPlaceDetails (OpeningHoursPeriodsCoreDataGeneratedAccessors)
- (void)addOpeningHoursPeriods:(NSSet<MTOpeningHourPeriod*>*)value_;
- (void)removeOpeningHoursPeriods:(NSSet<MTOpeningHourPeriod*>*)value_;
- (void)addOpeningHoursPeriodsObject:(MTOpeningHourPeriod*)value_;
- (void)removeOpeningHoursPeriodsObject:(MTOpeningHourPeriod*)value_;

@end

@interface _MTPlaceDetails (PhotosCoreDataGeneratedAccessors)
- (void)addPhotos:(NSSet<MTPhoto*>*)value_;
- (void)removePhotos:(NSSet<MTPhoto*>*)value_;
- (void)addPhotosObject:(MTPhoto*)value_;
- (void)removePhotosObject:(MTPhoto*)value_;

@end

@interface _MTPlaceDetails (ReviewsCoreDataGeneratedAccessors)
- (void)addReviews:(NSSet<MTPlaceReview*>*)value_;
- (void)removeReviews:(NSSet<MTPlaceReview*>*)value_;
- (void)addReviewsObject:(MTPlaceReview*)value_;
- (void)removeReviewsObject:(MTPlaceReview*)value_;

@end

@interface _MTPlaceDetails (WeekdayTextsCoreDataGeneratedAccessors)
- (void)addWeekdayTexts:(NSSet<MTWeekdayText*>*)value_;
- (void)removeWeekdayTexts:(NSSet<MTWeekdayText*>*)value_;
- (void)addWeekdayTextsObject:(MTWeekdayText*)value_;
- (void)removeWeekdayTextsObject:(MTWeekdayText*)value_;

@end

@interface _MTPlaceDetails (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSString*)primitiveAdminLevel2;
- (void)setPrimitiveAdminLevel2:(nullable NSString*)value;

- (nullable NSString*)primitiveFormattedAddress;
- (void)setPrimitiveFormattedAddress:(nullable NSString*)value;

- (nullable NSString*)primitiveInternationalPhone;
- (void)setPrimitiveInternationalPhone:(nullable NSString*)value;

- (nullable NSNumber*)primitiveIsOpenNow;
- (void)setPrimitiveIsOpenNow:(nullable NSNumber*)value;

- (BOOL)primitiveIsOpenNowValue;
- (void)setPrimitiveIsOpenNowValue:(BOOL)value_;

- (nullable NSNumber*)primitiveLat;
- (void)setPrimitiveLat:(nullable NSNumber*)value;

- (float)primitiveLatValue;
- (void)setPrimitiveLatValue:(float)value_;

- (nullable NSString*)primitiveLocalPhone;
- (void)setPrimitiveLocalPhone:(nullable NSString*)value;

- (nullable NSNumber*)primitiveLon;
- (void)setPrimitiveLon:(nullable NSNumber*)value;

- (float)primitiveLonValue;
- (void)setPrimitiveLonValue:(float)value_;

- (nullable NSString*)primitiveName;
- (void)setPrimitiveName:(nullable NSString*)value;

- (nullable NSString*)primitiveNeighbourhood;
- (void)setPrimitiveNeighbourhood:(nullable NSString*)value;

- (nullable NSNumber*)primitiveRating;
- (void)setPrimitiveRating:(nullable NSNumber*)value;

- (float)primitiveRatingValue;
- (void)setPrimitiveRatingValue:(float)value_;

- (nullable NSString*)primitiveStreetName;
- (void)setPrimitiveStreetName:(nullable NSString*)value;

- (nullable NSString*)primitiveStreetNumber;
- (void)setPrimitiveStreetNumber:(nullable NSString*)value;

- (nullable NSString*)primitiveSublocality;
- (void)setPrimitiveSublocality:(nullable NSString*)value;

- (nullable NSString*)primitiveVincinity;
- (void)setPrimitiveVincinity:(nullable NSString*)value;

- (nullable NSString*)primitiveWebsite;
- (void)setPrimitiveWebsite:(nullable NSString*)value;

- (NSMutableSet<MTOpeningHourPeriod*>*)primitiveOpeningHoursPeriods;
- (void)setPrimitiveOpeningHoursPeriods:(NSMutableSet<MTOpeningHourPeriod*>*)value;

- (NSMutableSet<MTPhoto*>*)primitivePhotos;
- (void)setPrimitivePhotos:(NSMutableSet<MTPhoto*>*)value;

- (NSMutableSet<MTPlaceReview*>*)primitiveReviews;
- (void)setPrimitiveReviews:(NSMutableSet<MTPlaceReview*>*)value;

- (NSMutableSet<MTWeekdayText*>*)primitiveWeekdayTexts;
- (void)setPrimitiveWeekdayTexts:(NSMutableSet<MTWeekdayText*>*)value;

@end

@interface MTPlaceDetailsAttributes: NSObject 
+ (NSString *)adminLevel2;
+ (NSString *)formattedAddress;
+ (NSString *)internationalPhone;
+ (NSString *)isOpenNow;
+ (NSString *)lat;
+ (NSString *)localPhone;
+ (NSString *)lon;
+ (NSString *)name;
+ (NSString *)neighbourhood;
+ (NSString *)rating;
+ (NSString *)streetName;
+ (NSString *)streetNumber;
+ (NSString *)sublocality;
+ (NSString *)vincinity;
+ (NSString *)website;
@end

@interface MTPlaceDetailsRelationships: NSObject
+ (NSString *)openingHoursPeriods;
+ (NSString *)photos;
+ (NSString *)reviews;
+ (NSString *)weekdayTexts;
@end

NS_ASSUME_NONNULL_END
