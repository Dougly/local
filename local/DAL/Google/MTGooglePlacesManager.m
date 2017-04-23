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
    
    
    /*NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%lf,%lf&types=cafe|restaurant|pub&key=%@&radius=6000&sensor=false", coordinate.latitude, coordinate.longitude, kGoogleMapAPIKey];
    
    if (pageToken) {
        NSString *tokenPart = [NSString stringWithFormat:@"&pagetoken=%@", pageToken];
        urlString = [urlString stringByAppendingString:tokenPart];
    }
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    __weak typeof(self) weakSelf = self;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (!connectionError) {
            [weakSelf parse:data
                 coordinate:coordinate];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadAnnotations];
        });
    }];*/
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

/*
- (void)parse:(NSData *)data coordinate:(CLLocationCoordinate2D)coordinate{
    if (data) {
        
        NSError *errorJson=nil;
        NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJson];
        
        BOOL isPackContainingNewObjects = YES;
        NSArray *list = [responseDict objectForKey:@"results"];
        if (list){
            
            NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:list.count];
            for (NSDictionary *dict in list){
                
                DummyAnnotation* object = [DummyAnnotation new];
                object.uniqueId = [dict objectForKey:@"id"];
                NSArray *photoArray = [dict objectForKey:@"photos"];
                if (photoArray.count > 0){
                    object.imageUrl = [[photoArray firstObject] objectForKey:@"photo_reference"];
                }
                
                NSDictionary *locationDict = [dict objectForKey:@"geometry"];
                
                double latitude = [[[locationDict objectForKey:@"location"] objectForKey:@"lat"] doubleValue];
                double longitude = [[[locationDict objectForKey:@"location"] objectForKey:@"lng"] doubleValue];
                
                
                object.title = [dict objectForKey:@"name"];
                object.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
                
                
            }
        }
        
        NSString *token = responseDict[@"next_page_token"];
        if (token && isPackContainingNewObjects)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self query:token
                 coordinate:coordinate];
            });
    }
}*/

#pragma mark - access overrides

- (QTree *)qTree {
    if (!_qTree) {
        _qTree = [[QTree alloc] init];
    }
    
    return _qTree;
}

@end
