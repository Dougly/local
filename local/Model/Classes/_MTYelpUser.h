// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MTYelpUser.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface MTYelpUserID : NSManagedObjectID {}
@end

@interface _MTYelpUser : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MTYelpUserID *objectID;

@property (nonatomic, strong, nullable) NSString* bearer;

@end

@interface _MTYelpUser (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveBearer;
- (void)setPrimitiveBearer:(NSString*)value;

@end

@interface MTYelpUserAttributes: NSObject 
+ (NSString *)bearer;
@end

NS_ASSUME_NONNULL_END
