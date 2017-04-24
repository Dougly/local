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

@interface MTDataModel : NSObject

+ (MTDataModel *)sharedDatabaseStorage;
- (void)clearPlaces;

- (MTPlaceDetails *)parsePlaceDetails:(NSData *)data;
- (NSArray *)parsePlaces:(NSData *)data;
- (NSString *)parseNewPageToken:(NSData *)data;
- (NSArray *)getPlaces;

- (NSArray *)fetchObjectsForEntityName:(NSString *)newEntityName
                         withPredicate:(NSPredicate *)predicate;
@end
