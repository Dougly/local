//
//  MTDataModel.h
//  rent
//
//  Created by Nick Savula on 6/4/15.
//  Copyright (c) 2015 Maliwan Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

// NOTE: to update models:  mogenerator -m MTDataModel.xcdatamodel/ -O ../Classes/ --template-var arc=YES

@class MTUser;
@class MTPlaceDetails;
@class MTYelpPlace;
@class MTYelpUser;

@interface MTDataModel : NSObject

+ (MTDataModel *)sharedDatabaseStorage;
- (void)clearPlaces;

- (MTYelpUser *)parseYelpUser:(NSData *)data;
- (MTYelpUser *)getYelpUser;

- (NSArray *)parseYelpPlaces:(NSData *)data;
- (MTPlaceDetails *)parsePlaceDetails:(NSData *)data;
- (NSArray *)parsePlaces:(NSData *)data;
- (NSString *)parseNewPageToken:(NSData *)data;
- (NSArray *)getPlaces;
- (MTPlaceDetails *)getPlaceDetialsForId:(NSString *)placeId;

- (NSArray *)fetchObjectsForEntityName:(NSString *)newEntityName
                         withPredicate:(NSPredicate *)predicate;
@end
