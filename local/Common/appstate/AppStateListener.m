//
//  KeyWordsListener.m
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/30/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "AppStateListener.h"

@implementation AppStateListener

- (id)init {
    self = [super init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appToForeground)
                                                 name:nFOREGROUND
                                               object:nil];
    
    return self;
}

- (void)appToForeground {
    if (self.onForegroundHandler)
        self.onForegroundHandler();
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
