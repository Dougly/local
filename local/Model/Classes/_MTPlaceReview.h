// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MTPlaceReview.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class MTPlaceDetails;

@interface MTPlaceReviewID : NSManagedObjectID {}
@end

@interface _MTPlaceReview : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MTPlaceReviewID *objectID;

@property (nonatomic, strong, nullable) NSString* authorAvatarUrl;

@property (nonatomic, strong, nullable) NSString* authorName;

@property (nonatomic, strong, nullable) NSString* language;

@property (nonatomic, strong, nullable) NSNumber* rating;

@property (atomic) float ratingValue;
- (float)ratingValue;
- (void)setRatingValue:(float)value_;

@property (nonatomic, strong, nullable) NSString* relativeTimeDescription;

@property (nonatomic, strong, nullable) NSString* text;

@property (nonatomic, strong, nullable) NSNumber* time;

@property (atomic) int64_t timeValue;
- (int64_t)timeValue;
- (void)setTimeValue:(int64_t)value_;

@property (nonatomic, strong, nullable) NSString* type;

@property (nonatomic, strong, nullable) MTPlaceDetails *parentDetails;

@end

@interface _MTPlaceReview (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSString*)primitiveAuthorAvatarUrl;
- (void)setPrimitiveAuthorAvatarUrl:(nullable NSString*)value;

- (nullable NSString*)primitiveAuthorName;
- (void)setPrimitiveAuthorName:(nullable NSString*)value;

- (nullable NSString*)primitiveLanguage;
- (void)setPrimitiveLanguage:(nullable NSString*)value;

- (nullable NSNumber*)primitiveRating;
- (void)setPrimitiveRating:(nullable NSNumber*)value;

- (float)primitiveRatingValue;
- (void)setPrimitiveRatingValue:(float)value_;

- (nullable NSString*)primitiveRelativeTimeDescription;
- (void)setPrimitiveRelativeTimeDescription:(nullable NSString*)value;

- (nullable NSString*)primitiveText;
- (void)setPrimitiveText:(nullable NSString*)value;

- (nullable NSNumber*)primitiveTime;
- (void)setPrimitiveTime:(nullable NSNumber*)value;

- (int64_t)primitiveTimeValue;
- (void)setPrimitiveTimeValue:(int64_t)value_;

- (MTPlaceDetails*)primitiveParentDetails;
- (void)setPrimitiveParentDetails:(MTPlaceDetails*)value;

@end

@interface MTPlaceReviewAttributes: NSObject 
+ (NSString *)authorAvatarUrl;
+ (NSString *)authorName;
+ (NSString *)language;
+ (NSString *)rating;
+ (NSString *)relativeTimeDescription;
+ (NSString *)text;
+ (NSString *)time;
+ (NSString *)type;
@end

@interface MTPlaceReviewRelationships: NSObject
+ (NSString *)parentDetails;
@end

NS_ASSUME_NONNULL_END
