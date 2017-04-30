//
//  MTGooglePlacesManager.m
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/22/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MTYelpManager.h"
#import "MTGetYelpPlacesRequest.h"
#import "MTGetYelpPlacesResponse.h"
#import "MTYelpPlace.h"
#import "MTDataModel.h"
#import "MTGoogleQueryString.h"
#import "MTGoogleFilter.h"
#import "MTPlace.h"

@interface MTYelpManager()
@property (nonatomic, strong) MTGoogleQueryString *googleQuery;
@property (nonatomic, strong) MTGoogleFilter *googleFilter;

@property (nonatomic) YelpCompletion completion;
@end

@implementation MTYelpManager

+ (instancetype)sharedManager {
    static MTYelpManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (id)init {
    self = [super init];
    _googleQuery = [MTGoogleQueryString new];
    _googleFilter = [MTGoogleFilter new];
    return self;
}

- (void)getYelpPlaceMatchingGooglePlace:(MTPlace *)place completion:(YelpCompletion)completion {
    MTGetYelpPlacesRequest *request = [MTGetYelpPlacesRequest requestWithOwner:self];
    request.latitude = place.lat.floatValue;
    request.longitude = place.lon.floatValue;
    request.query = [place nameQuery];
    
    __weak typeof(self) weakSelf = self;
    request.completionBlock = ^(SDRequest *request, SDResult *response)
    {
        if ([response isSuccess]) {
            MTGetYelpPlacesResponse *yelpResponse = (MTGetYelpPlacesResponse *)response;
            MTYelpPlace *yelpPlace = [weakSelf getClosestPlaceOf:yelpResponse.yelpPlaces
                                                   toGooglePlace:place];
            
            completion(true, yelpPlace, nil);
        }
        else {
            completion(false, nil, [NSError errorWithDomain:kMapDomain
                                                            code:response.code
                                                        userInfo:@{@"message" : response.message}]);
        }
    };
    [request run];
}

- (MTYelpPlace *)getClosestPlaceOf:(NSArray *)yelpPlaces toGooglePlace:(MTPlace *)googlePlace {
    
    NSArray *googleNameWods = [googlePlace.name componentsSeparatedByString:@" "];
    if (googleNameWods.count > 0) {
      
    }
    else {
        googleNameWods = @[googlePlace.name];
    }
    
    MTYelpPlace *finalYelpPlace = nil;
    
    if (yelpPlaces.count > 1) {
        for (MTYelpPlace *yelpPlace in yelpPlaces) {
            NSMutableSet *googleSet = [NSMutableSet setWithArray:googleNameWods];
            NSArray *yelpPlaceWords = [yelpPlace.name componentsSeparatedByString:@" "];
            
            if (yelpPlaces.count > 0) {
                
            }
            else {
                yelpPlaceWords = @[yelpPlace.name];
            }
            
            NSMutableSet *yelpSet = [NSMutableSet setWithArray:yelpPlaceWords];
            [googleSet intersectSet:yelpSet];
            
            NSArray *matchingWords = [googleSet allObjects];
            if (matchingWords.count > 0) {
                finalYelpPlace = yelpPlace;
            }
        }
    }
    
    if (yelpPlaces.count == 1) {
        finalYelpPlace = yelpPlaces.firstObject;
    }
    
    if (yelpPlaces.count == 0) {
        return nil;
    }
    
    return finalYelpPlace;
}

@end
