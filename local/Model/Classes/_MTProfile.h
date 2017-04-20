// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MTProfile.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface MTProfileID : NSManagedObjectID {}
@end

@interface _MTProfile : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MTProfileID *objectID;

@property (nonatomic, strong, nullable) NSString* carrierName;

@property (nonatomic, strong, nullable) NSString* certificates;

@property (nonatomic, strong, nullable) NSString* contactNumber;

@property (nonatomic, strong, nullable) NSString* email;

@property (nonatomic, strong, nullable) NSString* licenseUrl;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSString* profilePhoto;

@property (nonatomic, strong, nullable) NSString* trailerNumer;

@property (nonatomic, strong, nullable) NSString* truckNumber;

@end

@interface _MTProfile (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSString*)primitiveCarrierName;
- (void)setPrimitiveCarrierName:(nullable NSString*)value;

- (nullable NSString*)primitiveCertificates;
- (void)setPrimitiveCertificates:(nullable NSString*)value;

- (nullable NSString*)primitiveContactNumber;
- (void)setPrimitiveContactNumber:(nullable NSString*)value;

- (nullable NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(nullable NSString*)value;

- (nullable NSString*)primitiveLicenseUrl;
- (void)setPrimitiveLicenseUrl:(nullable NSString*)value;

- (nullable NSString*)primitiveName;
- (void)setPrimitiveName:(nullable NSString*)value;

- (nullable NSString*)primitiveProfilePhoto;
- (void)setPrimitiveProfilePhoto:(nullable NSString*)value;

- (nullable NSString*)primitiveTrailerNumer;
- (void)setPrimitiveTrailerNumer:(nullable NSString*)value;

- (nullable NSString*)primitiveTruckNumber;
- (void)setPrimitiveTruckNumber:(nullable NSString*)value;

@end

@interface MTProfileAttributes: NSObject 
+ (NSString *)carrierName;
+ (NSString *)certificates;
+ (NSString *)contactNumber;
+ (NSString *)email;
+ (NSString *)licenseUrl;
+ (NSString *)name;
+ (NSString *)profilePhoto;
+ (NSString *)trailerNumer;
+ (NSString *)truckNumber;
@end

NS_ASSUME_NONNULL_END
