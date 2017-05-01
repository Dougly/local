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
                                             selector:@selector(newPlacesReceived)
                                                 name:nNEW_PLACES_RECEIVED
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationChanged)
                                                 name:nLOCATION_CHANGED
                                               object:nil];
    return self;
}

- (void)keywordsUpdated {
    if (self.onKeyWordUpdatedHandler)
        self.onKeyWordUpdatedHandler();
}

- (void)newPlacesReceived {
    if (self.onNewPlacesReceivedHandler)
        self.onNewPlacesReceivedHandler();
}

- (void)locationChanged {
    if (self.onLocationChangedHandler) {
        self.onLocationChangedHandler();
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
