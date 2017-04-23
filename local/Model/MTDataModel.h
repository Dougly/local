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


@interface MTDataModel : NSObject

+ (MTDataModel *)sharedDatabaseStorage;

- (NSArray *)parsePlaces:(NSDictionary *)dictionary;
- (NSArray *)getPlaces;

- (NSArray *)fetchObjectsForEntityName:(NSString *)newEntityName
                         withPredicate:(NSPredicate *)predicate;
@end
