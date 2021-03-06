//
//  MTDataModel.m
//  rent
//
//  Created by Nick Savula on 6/4/15.
//  Copyright (c) 2015 Maliwan Technology. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "MTDataModel.h"

#import "NSObject+PNCast.h"
#import "MTUser.h"
#import "MTPlace.h"
#import "MTPhoto.h"
#import "MTPlaceDetails.h"
#import "MTWeekdayText.h"
#import "MTOpeningHourPeriod.h"
#import "MTPlaceReview.h"
#import "MTYelpPlace.h"
#import "MTGoogleFilter.h"
#import "MTYelpUser.h"

@interface MTDataModel ()

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) MTGoogleFilter *googleFilter;
@end

@implementation MTDataModel

@synthesize managedObjectContext = managedObjectContext_;
@synthesize managedObjectModel = managedObjectModel_;
@synthesize persistentStoreCoordinator = persistentStoreCoordinator_;

- (void)dealloc
{
    [self resetCoreData];
}

#pragma mark - Core Data

- (NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext_ == nil)
    {
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        
        if (coordinator != nil)
        {
            managedObjectContext_ = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
        }
    }
    
    return managedObjectContext_;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel_ == nil)
    {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MTDataModel" withExtension:@"momd"];
        managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    return managedObjectModel_;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (persistentStoreCoordinator_ == nil)
    {
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"maliwanData.sqlite"];
        
        NSError *error = nil;
        persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        
        if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
        {
            // WORKAROUND: just removing old storage for convenience of development
            // TODO: simple development make merging of old database with new schema, when model becomes versioned
            NSLog(@"Error opening persistent store %@:%@", storeURL, error);
            switch ([error code])
            {
                case NSPersistentStoreIncompatibleSchemaError:
                case NSPersistentStoreIncompatibleVersionHashError:
                    
                    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
                    [persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
                    
                    error = nil;
                    NSLog(@"Trying to recover by removing old storage..");
                    
                    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
                    if (!error && [persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
                    {
                        NSLog(@"OK. New persistant storage was created.");
                        return persistentStoreCoordinator_;
                    };
                    
                    break;
            }
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    return persistentStoreCoordinator_;
}

- (void)resetCoreData
{
    managedObjectContext_ = nil;
    managedObjectModel_ = nil;
    persistentStoreCoordinator_ = nil;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

// Convenience method to fetch the array of objects for a given Entity
// name in the context, optionally limiting by a predicate or by a predicate
// made from a format NSString and variable arguments.
//
- (NSArray *)fetchObjectsForEntityName:(NSString *)newEntityName
                       withPredicate:(NSPredicate *)predicate
{
    NSArray *results = [NSArray array];
    
    NSEntityDescription *entity = [[self.managedObjectModel entitiesByName] objectForKey:newEntityName];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    [request setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES]]];
    
    if(predicate) {
        [request setPredicate:predicate];
    }

    NSError *error = nil;
    results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error != nil)
    {
        [NSException raise:NSGenericException format:@"%@", [error description]];
    }
    
    return results;
}

- (NSManagedObject *)emptyNode:(Class)className
{
    if ([className respondsToSelector:@selector(entityName)])
    {
        NSEntityDescription *description = [self.managedObjectModel entitiesByName][[(id)className entityName]];
        
        return [[className alloc] initWithEntity:description
                  insertIntoManagedObjectContext:self.managedObjectContext];
    }
    
    return nil;
}

#pragma mark - public

+ (MTDataModel *)sharedDatabaseStorage
{
    static MTDataModel *sharedInstance = nil;
    static dispatch_once_t pred;
    
    if (!sharedInstance)
    {
        dispatch_once(&pred, ^{
            sharedInstance = [MTDataModel alloc];
            sharedInstance = [sharedInstance init];
        });
    }
    
    return sharedInstance;
}

#pragma mark - fetch requests
- (MTYelpUser *)getYelpUser {
    NSFetchRequest *allPlaces = [[NSFetchRequest alloc] init];
    [allPlaces setEntity:[NSEntityDescription entityForName:@"MTYelpUser"
                                     inManagedObjectContext:self.managedObjectContext]];
    
    NSError *error = nil;
    NSArray *places = [self.managedObjectContext executeFetchRequest:allPlaces
                                                               error:&error];
    
    return [places firstObject];
}

- (NSArray *)getPlaces {
    NSFetchRequest *allPlaces = [[NSFetchRequest alloc] init];
    [allPlaces setEntity:[NSEntityDescription entityForName:@"MTPlace"
                                   inManagedObjectContext:self.managedObjectContext]];
    
    NSError *error = nil;
    NSArray *places = [self.managedObjectContext executeFetchRequest:allPlaces
                                                             error:&error];
    
    return [places copy];
}

- (MTPlaceDetails *)getPlaceDetialsForId:(NSString *)placeId {
    NSFetchRequest *allPlacesFetchRequest = [[NSFetchRequest alloc] init];
    [allPlacesFetchRequest setEntity:[NSEntityDescription entityForName:@"MTPlaceDetails"
                                     inManagedObjectContext:self.managedObjectContext]];
    
    NSError *error = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"placeId == %@", placeId];
    [allPlacesFetchRequest setPredicate:predicate];
    
    NSArray *placeDetails = [self.managedObjectContext executeFetchRequest:allPlacesFetchRequest
                                                               error:&error];
    
    
    if (placeDetails.count > 0) {
        return placeDetails.firstObject;
    }
    
    return nil;
}

- (void)clearPlaces {
    [self removeAllEntities:@"MTPlace"];
}

#pragma mark - parse utils

- (MTYelpUser *)parseYelpUser:(NSData *)data {
    [self removeAllEntities:@"MTYelpUser"];
    MTYelpUser *yelpUser = nil;
    
    if(data != nil) {
        NSError *error = nil;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if (!error && [jsonDict isKindOfClass:NSDictionary.class]) {
            
            if(jsonDict != nil) {
                yelpUser = (MTYelpUser *)[self emptyNode:MTYelpUser.class];
                [yelpUser parseNode:jsonDict];
            }
        }
        [self saveContext];
    }
    
    return yelpUser;
}

- (NSArray *)parsePlaces:(NSData *)data {
    NSMutableArray *places = nil;
    if(data != nil) {
        NSError *error = nil;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if (!error && [jsonDict isKindOfClass:NSDictionary.class]) {
            MTPlace *place = nil;
            
            if(jsonDict != nil) {
                NSArray *list = [jsonDict objectForKey:@"results"];
                
                if (list){
                    NSArray *alreadyStoredPlaceIds = [self getAlreadyStoredPlaces:list];
                    if (alreadyStoredPlaceIds.count < list.count) {
                        
                        places = [[NSMutableArray alloc] init];
                        for (NSDictionary *placeDict in list){
                            
                            BOOL conformsToFilter = [self.googleFilter doesConform:placeDict];
                            
                            if (conformsToFilter && ![alreadyStoredPlaceIds containsObject:placeDict[@"id"]]) {
                                place = (MTPlace *)[self emptyNode:MTPlace.class];
                                [place parseNode:placeDict];
                                
                                NSArray *photoDictionaries = placeDict[@"photos"];
                                for (NSDictionary *photoDictionary in photoDictionaries) {
                                    MTPhoto *photo = (MTPhoto *)[self emptyNode:MTPhoto.class];
                                    [photo parseNode:photoDictionary];
                                    [place addPhotosObject:photo];
                                }
                                
                                [places addObject:place];
                            }
                        }
                    }
                }
            }
            
            [self saveContext];
        }
    }
    
    return [places copy];
}

- (NSArray *)parseYelpPlaces:(NSData *)data {
    [self removeAllEntities:@"MTYelpPlace"];
    MTYelpPlace *yelpPlace = nil;
    NSMutableArray *yelpPlaces = nil;
    
    if(data != nil) {
        NSError *error = nil;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if (!error && [jsonDict isKindOfClass:NSDictionary.class]) {
            
            NSArray *businesses = jsonDict[@"businesses"];
            
            if (businesses.count > 0) {
                yelpPlaces = [NSMutableArray new];
                for (NSDictionary *business in businesses) {
                    yelpPlace = (MTYelpPlace *)[self emptyNode:MTYelpPlace.class];
                    [yelpPlace parseNode:business];
                    
                    [yelpPlaces addObject:yelpPlace];
                }
            }
            
        }
    }
    
    return yelpPlaces;
}

- (MTPlaceDetails *)parsePlaceDetails:(NSData *)data {
    MTPlaceDetails *placeDetails = nil;
    if(data != nil) {
        NSError *error = nil;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if (!error && [jsonDict isKindOfClass:NSDictionary.class]) {
            NSDictionary *result = jsonDict[@"result"];
            
            placeDetails = (MTPlaceDetails *)[self emptyNode:MTPlaceDetails.class];
            [placeDetails parseNode:result];
            
            NSArray *photoDictionaries = result[@"photos"];
            for (NSDictionary *photoDictionary in photoDictionaries) {
                MTPhoto *photo = (MTPhoto *)[self emptyNode:MTPhoto.class];
                [photo parseNode:photoDictionary];
                [placeDetails addPhotosObject:photo];
            }
            
            NSArray *openingHoursDictionaries = result[@"opening_hours"][@"periods"];
            
            for (NSDictionary *openingHoursDict in openingHoursDictionaries) {
                MTOpeningHourPeriod *period = (MTOpeningHourPeriod *)[self emptyNode:MTOpeningHourPeriod.class];
                [period parseNode:openingHoursDict];
                [placeDetails addOpeningHoursPeriodsObject:period];
            }
            
            NSArray *reviewDictionaries = result[@"reviews"];
            for (NSDictionary *reviewDictionary in reviewDictionaries) {
                MTPlaceReview *review = (MTPlaceReview *)[self emptyNode:MTPlaceReview.class];
                [review parseNode:reviewDictionary];
                [placeDetails addReviewsObject:review];
            }
            
            NSArray *weekDayDictionaries = result[@"weekday_text"];
            NSUInteger day = 0;
            for (NSString *weekDayText in weekDayDictionaries) {
                MTWeekdayText *weekdayText = (MTWeekdayText *)[self emptyNode:MTWeekdayText.class];
                [weekdayText parseNode:weekDayText day:day];
                [placeDetails addWeekdayTextsObject:weekdayText];
                day++;
            }
            
            [self saveContext];
        }
    }
    
    return placeDetails;
}

- (NSArray *)getAlreadyStoredPlaces:(NSArray *)places {
    NSMutableArray *placeIds = [[NSMutableArray alloc] init];
    if (places) {
        for (NSDictionary *place in places) {
            [placeIds addObject:place[@"id"]];
        }
    }
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    fetch.entity = [NSEntityDescription entityForName:@"MTPlace" inManagedObjectContext:self.managedObjectContext];
    fetch.predicate = [NSPredicate predicateWithFormat:@"uniqueId IN %@", placeIds];
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    
    NSMutableArray *alreadyStoredPlaceIds = [[NSMutableArray alloc] init];

    for (MTPlace *place in array) {
        [alreadyStoredPlaceIds addObject:place.uniqueId];
    }
    
    return alreadyStoredPlaceIds;
}

- (NSString *)parseNewPageToken:(NSData *)data {
    NSString *newPageToken = nil;
    if(data != nil) {
        NSError *error = nil;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if (!error && [jsonDict isKindOfClass:NSDictionary.class]) {
            if (jsonDict) {
                newPageToken = jsonDict[@"next_page_token"];
            }
        }
    }
    
    return newPageToken;
}

#pragma mark - removing objects

- (void)removeAllEntities:(NSString *)entity {
    NSFetchRequest *allProducts = [[NSFetchRequest alloc] init];
    [allProducts setEntity:[NSEntityDescription entityForName:entity inManagedObjectContext:self.managedObjectContext]];
    [allProducts setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error = nil;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:allProducts error:&error];
    //error handling goes here
    for (NSManagedObject *object in objects) {
        [self.managedObjectContext deleteObject:object];
    }
    [self saveContext];
}

- (void)removeToken {
    [self removeAllEntities:@"MTUser"];
}

#pragma mark - save

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - access overrides

- (MTGoogleFilter *)googleFilter {
    if (!_googleFilter) {
        _googleFilter = [MTGoogleFilter new];
    }
    
    return _googleFilter;
}

@end
