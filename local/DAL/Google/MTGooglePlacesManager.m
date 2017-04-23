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

@interface MTGooglePlacesManager()
@property(nonatomic, strong) QTree* qTree;
@property (nonatomic) GooglePlaceCompletion completion;
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

- (void)query:(CLLocationCoordinate2D)coordinate radius:(NSUInteger)radius completion:(GooglePlaceCompletion)completion{
    self.completion = completion;
    
    [[MTDataModel sharedDatabaseStorage] clearPlaces];
    [self query:coordinate radius:radius pageToken:nil];
    [self query:coordinate radius:radius + 500 pageToken:nil];
}

- (void)query:(CLLocationCoordinate2D)coordinate radius:(NSUInteger)radius pageToken:(NSString *)pageToken {
    MTGetPlacesRequest *request = [MTGetPlacesRequest requestWithOwner:self];
    request.latitude = coordinate.latitude;
    request.longitude = coordinate.longitude;
    request.pageToken = pageToken;
    request.radius = radius;
    
    __weak typeof (self) weakSelf = self;
    request.completionBlock = ^(SDRequest *request, SDResult *response)
    {
        if ([response isSuccess]) {
            MTGetPlacesResponse *googleResponse = (MTGetPlacesResponse *)response;
            
            if (googleResponse.places) {
                [weakSelf addTreeNodes:googleResponse.places];
                
                /*Fetch new page. 1.5 secs is required cause newPagetoken becomes available after some delay*/
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf query:coordinate radius:radius pageToken:googleResponse.pageToken];
                });
                
                self.completion(true, googleResponse.places, nil);
            }
        }
        else {
            self.completion(false, nil, [NSError errorWithDomain:kMapDomain
                                                            code:response.code
                                                        userInfo:@{@"message" : response.message}]);
        }
    };
    
    [request run];
}

- (void)addTreeNodes:(NSArray *)googlePlaces {
    for (MTPlace *place in googlePlaces) {
        [self.qTree insertObject:place];
    }
}

#pragma mark - access overrides

- (QTree *)qTree {
    if (!_qTree) {
        _qTree = [[QTree alloc] init];
    }
    
    return _qTree;
}

@end
