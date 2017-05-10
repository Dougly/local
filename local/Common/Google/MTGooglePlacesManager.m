//
//  MTGooglePlacesManager.m
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/22/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MTGooglePlacesManager.h"
#import "MTGetPlacesRequest.h"
#import "MTGetPlacesResponse.h"
#import "MTPlace.h"
#import "MTDataModel.h"
#import "MTGoogleFilter.h"
#import "MTGoogleQueryString.h"
#import "MTGoogleTypesString.h"
#import "MTLocationManager.h"

@interface MTGooglePlacesManager()
@property (nonatomic, strong) MTGoogleQueryString *googleQuery;
@property (nonatomic, strong) MTGoogleTypesString *googleTypes;
@property (nonatomic, strong) MTGoogleFilter *googleFilter;

@property (nonatomic, strong) NSMutableArray *requests;
@property (nonatomic, strong) NSMutableArray *pendingPageTokens;
@property(nonatomic, strong) QTree* qTree;
@property (nonatomic) GooglePlaceCompletion completion;

@property (nonatomic, strong) NSMutableArray *aggregatedPlaces;
@property (nonatomic) NSUInteger currentPendingIndex;
@end

@implementation MTGooglePlacesManager

+ (instancetype)sharedManager {
    static MTGooglePlacesManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (id)init {
    self = [super init];
    _googleQuery = [MTGoogleQueryString new];
    _googleTypes = [MTGoogleTypesString new];
    _googleFilter = [MTGoogleFilter new];
    return self;
}

- (void)query:(CLLocationCoordinate2D)coordinate radius:(NSUInteger)radius completion:(GooglePlaceCompletion)completion{
    self.completion = completion;
    self.aggregatedPlaces = [NSMutableArray new];
    self.currentPendingIndex = 0;
    
    [MTLocationManager sharedManager].lastUsedLocation = coordinate;
    
    self.qTree = [QTree new];
    [[MTDataModel sharedDatabaseStorage] clearPlaces];
    [self cancelPendingRequests];
    
    //NSString *majorType = [self.googleTypes stringTypes];
    
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [self query:coordinate radius:radius type:@"cafe" pageToken:nil innerCompletion:^(BOOL success, NSArray *places, NSError *error) {
        [self.aggregatedPlaces removeObjectsInArray:places];
        [self.aggregatedPlaces addObjectsFromArray:places];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self query:coordinate radius:radius type:@"restaurant" pageToken:nil innerCompletion:^(BOOL success, NSArray *places, NSError *error) {
        [self.aggregatedPlaces removeObjectsInArray:places];
        [self.aggregatedPlaces addObjectsFromArray:places];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self query:coordinate radius:radius type:@"bar" pageToken:nil innerCompletion:^(BOOL success, NSArray *places, NSError *error) {
        [self.aggregatedPlaces removeObjectsInArray:places];
        [self.aggregatedPlaces addObjectsFromArray:places];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self query:coordinate radius:radius type:@"meal_takeaway" pageToken:nil innerCompletion:^(BOOL success, NSArray *places, NSError *error) {
        [self.aggregatedPlaces removeObjectsInArray:places];
        [self.aggregatedPlaces addObjectsFromArray:places];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.completion(true, self.aggregatedPlaces, nil);
            
            NSDictionary *finalPackDictionary = nil;
            if (self.pendingPageTokens.count == 0) {
                finalPackDictionary = @{kNEW_PLACES_FINAL_PACK : @(YES)};
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:nNEW_PLACES_RECEIVED object:nil userInfo:finalPackDictionary];
            
        });
    });
}

- (void)query:(CLLocationCoordinate2D)coordinate radius:(NSUInteger)radius type:(NSString *)type pageToken:(NSString *)pageToken innerCompletion:(GooglePlaceCompletion)innerCompletion{
    MTGetPlacesRequest *request = [MTGetPlacesRequest requestWithOwner:self];
    request.latitude = coordinate.latitude;
    request.longitude = coordinate.longitude;
    request.pageToken = pageToken;
    request.query = [[self.googleQuery stringQuery] stringByAppendingString:@""];
    request.types = type;
    request.radius = radius;
    
    __weak typeof (self) weakSelf = self;
    request.completionBlock = ^(SDRequest *request, SDResult *response)
    {
        [self.requests removeObject:request];
        
        if ([response isSuccess]) {
            MTGetPlacesResponse *googleResponse = (MTGetPlacesResponse *)response;
            
                // add token to mark that there're some pending requests
                if (googleResponse.pageToken) {
                    [self.pendingPageTokens addObject:googleResponse.pageToken];
                }
            
                //add cluster tree nodes
                [weakSelf addTreeNodes:googleResponse.places];
            
                //if inner completion is valid, it means it's the first request to google API (not the subsequent request with pagination otken)
                if (innerCompletion) {
                    innerCompletion(true, googleResponse.places, nil);
                }
                else {
                    //it's the subsequent request with pagination token
                    self.currentPendingIndex++;
                    [self.aggregatedPlaces addObjectsFromArray:googleResponse.places];
                    if (self.currentPendingIndex == self.pendingPageTokens.count) {
                        self.completion(true, self.aggregatedPlaces, nil);
                        [[NSNotificationCenter defaultCenter] postNotificationName:nNEW_PLACES_RECEIVED object:nil userInfo:@{kNEW_PLACES_FINAL_PACK : @(YES)}];
                    }
                }
                
                /*Fetch new page. 1.5 secs is required cause newPagetoken becomes available after some delay*/
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    /*in case it's cancelled, pendingPagetoken will not contain the token*/
                    if ([self.pendingPageTokens containsObject:googleResponse.pageToken])
                        [weakSelf query:coordinate radius:radius type:type pageToken:googleResponse.pageToken innerCompletion:NULL];
                });

        }
        else {
            self.completion(false, nil, [NSError errorWithDomain:kMapDomain
                                                            code:response.code
                                                        userInfo:@{@"message" : response.message}]);
        }
    };
    [self.requests addObject:request];
    [request run];
}

- (void)addTreeNodes:(NSArray *)googlePlaces {
    for (MTPlace *place in googlePlaces) {
        [self.qTree insertObject:place];
    }
}
- (void)cancelPendingRequests {
    for (SDRequest *request in self.requests) {
        [request cancel];
    }
    
    [self.pendingPageTokens removeAllObjects];
}

#pragma mark - access overrides

- (QTree *)qTree {
    if (!_qTree) {
        _qTree = [[QTree alloc] init];
    }
    
    return _qTree;
}

- (NSMutableArray *)requests {
    if (!_requests) {
        _requests = [[NSMutableArray alloc] init];
    }
    
    return _requests;
}

- (NSMutableArray *)pendingPageTokens {
    if (!_pendingPageTokens) {
        _pendingPageTokens = [[NSMutableArray alloc] init];
    }
    
    return _pendingPageTokens;
}

@end
