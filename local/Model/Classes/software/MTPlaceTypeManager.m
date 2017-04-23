//
//  MTSoftware.m
//  Proz
//
//  Created by RostyslavStepanyak on 1/22/16.
//  Copyright © 2016 Tilf AB. All rights reserved.
//

#import "MTPlaceTypeManager.h"
#import "MTPlaceType.h"

@interface MTPlaceTypeManager()
@property (nonatomic, strong) NSMutableArray *placeTypes;
@end

@implementation MTPlaceTypeManager

- (id)init {
    self = [super init];
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"placeTypes" ofType:@"json"];
    NSError *error;
    NSString *jsonString = [NSString stringWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:&error];
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *softwareIds = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions
                                                          error:&error];
    /*Create the array if not yet created*/
    if(!_placeTypes) {
        _placeTypes = [[NSMutableArray alloc] init];
    }

    for(NSDictionary *softwareId in softwareIds) {
        /*Parse the software object*/
        MTPlaceType *placeType = [[MTPlaceType alloc] init];
        placeType.name = softwareId[@"place_name"];
        placeType.placeTypeId = (int)[softwareId[@"place_id"] integerValue];
        
        /*Add the software object*/
        [_placeTypes addObject:placeType];
    }
    return self;
}

/*Find the software object with the id*/
- (MTPlaceType *)getPlaceTypeById:(int)placeTypeId {
    for(MTPlaceType *placeType in self.placeTypes) {
        if(placeType.placeTypeId == placeTypeId) {
            return placeType;
        }
    }
    
    return nil;
}

/*Get all the softwares names*/
- (NSMutableArray *)allPlaceTypes {
    NSMutableArray *names = [[NSMutableArray alloc] init];
    
    for(MTPlaceType *placeType in self.placeTypes) {
        [names addObject:placeType.name];
    }
    
    return names;
}

- (NSString *)idsByElementNames:(NSArray *)names {
    NSArray* placeTypes = [self.placeTypes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name IN %@", names]];

    NSMutableArray *onlyIds = [[NSMutableArray alloc] init];
    for(MTPlaceType *placeType in placeTypes) {
        [onlyIds addObject: [NSString stringWithFormat:@"%d", placeType.placeTypeId]];
    }
    
    return [onlyIds componentsJoinedByString:@","];
}

@end
