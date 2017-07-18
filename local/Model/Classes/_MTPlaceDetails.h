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
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
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

@property (nonatomic, strong, nullable) NSString* placeId;

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

- (NSString*)primitiveAdminLevel2;
- (void)setPrimitiveAdminLevel2:(NSString*)value;

- (NSString*)primitiveFormattedAddress;
- (void)setPrimitiveFormattedAddress:(NSString*)value;

- (NSString*)primitiveInternationalPhone;
- (void)setPrimitiveInternationalPhone:(NSString*)value;

- (NSNumber*)primitiveIsOpenNow;
- (void)setPrimitiveIsOpenNow:(NSNumber*)value;

- (BOOL)primitiveIsOpenNowValue;
- (void)setPrimitiveIsOpenNowValue:(BOOL)value_;

- (NSNumber*)primitiveLat;
- (void)setPrimitiveLat:(NSNumber*)value;

- (float)primitiveLatValue;
- (void)setPrimitiveLatValue:(float)value_;

- (NSString*)primitiveLocalPhone;
- (void)setPrimitiveLocalPhone:(NSString*)value;

- (NSNumber*)primitiveLon;
- (void)setPrimitiveLon:(NSNumber*)value;

- (float)primitiveLonValue;
- (void)setPrimitiveLonValue:(float)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitiveNeighbourhood;
- (void)setPrimitiveNeighbourhood:(NSString*)value;

- (NSString*)primitivePlaceId;
- (void)setPrimitivePlaceId:(NSString*)value;

- (NSNumber*)primitiveRating;
- (void)setPrimitiveRating:(NSNumber*)value;

- (float)primitiveRatingValue;
- (void)setPrimitiveRatingValue:(float)value_;

- (NSString*)primitiveStreetName;
- (void)setPrimitiveStreetName:(NSString*)value;

- (NSString*)primitiveStreetNumber;
- (void)setPrimitiveStreetNumber:(NSString*)value;

- (NSString*)primitiveSublocality;
- (void)setPrimitiveSublocality:(NSString*)value;

- (NSString*)primitiveVincinity;
- (void)setPrimitiveVincinity:(NSString*)value;

- (NSString*)primitiveWebsite;
- (void)setPrimitiveWebsite:(NSString*)value;

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
+ (NSString *)placeId;
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
