//
//  MTDataModel.h
//  rent
//
//  Created by Nick Savula on 6/4/15.
//  Copyright (c) 2015 Maliwan Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

// NOTE: to update models:  mogenerator -m MTDataModel.xcdatamodel/ -O ../Classes/ --template-var arc=YES

@class JCProduct;
@class JCPostsItem;
@class MTUser;
@class MTPreviousVehicle;
@class MTDelivery;
@class MTLog;
@class MTProfile;

@interface MTDataModel : NSObject

+ (MTDataModel *)sharedDatabaseStorage;

- (void)saveContext;

- (NSString *)parseLogin:(NSData *)data;
- (MTPreviousVehicle *)parsePreviousVehicle:(NSData *)data;
- (MTDelivery *)parseDeliveryDetails:(NSData *)data;
- (NSArray *)parseLogs:(NSData *)data;
- (MTProfile *)parseProfile:(NSData *)data;

- (NSArray *)getPastLogs;
- (MTLog *)getPresentLog;
- (NSString *)getAccessToken;
- (MTDelivery *)getDeliveryDetails;
- (MTProfile *)getProfile;

- (NSArray *)fetchObjectsForEntityName:(NSString *)newEntityName
                         withPredicate:(NSPredicate *)predicate;
- (void)removeToken;
@end
