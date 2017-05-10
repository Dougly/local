//
//  KeyWordsListener.m
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/30/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "FilterListener.h"

@implementation FilterListener

- (id)init {
    self = [super init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keywordsUpdated)
                                                 name:nKEYWORDS_CHANGED
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newPlacesReceived:)
                                                 name:nNEW_PLACES_RECEIVED
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationChanged)
                                                 name:nLOCATION_CHANGED
                                               object:nil];
    return self;
}

- (void)keywordsUpdated {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.onKeyWordUpdatedHandler)
            self.onKeyWordUpdatedHandler();
    });
}

- (void)newPlacesReceived:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL isFinalPackOfPlaces = [self doesNotificationContainFinalPackOfPlaces:notification];
        if (self.onNewPlacesReceivedHandler) {
            self.onNewPlacesReceivedHandler(isFinalPackOfPlaces);
        }
    });
}

- (void)locationChanged {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.onLocationChangedHandler) {
            self.onLocationChangedHandler();
        }
    });
}

- (BOOL)doesNotificationContainFinalPackOfPlaces:(NSNotification *)notification {
    if (notification.userInfo[kNEW_PLACES_FINAL_PACK]) {
        return true;
    }
    
    return false;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
