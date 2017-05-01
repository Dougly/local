//
//  KeyWordsListener.h
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/30/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^onKeywordUpdated)();
typedef void (^onNewPlacesReceived)();
typedef void (^onLocationChanged)();

@interface FilterListener : NSObject
@property (nonatomic, strong) onKeywordUpdated onKeyWordUpdatedHandler;
@property (nonatomic, strong) onNewPlacesReceived onNewPlacesReceivedHandler;
@property (nonatomic, strong) onLocationChanged onLocationChangedHandler;
@end
