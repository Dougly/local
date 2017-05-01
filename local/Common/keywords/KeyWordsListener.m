//
//  KeyWordsListener.m
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/30/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "KeyWordsListener.h"

@implementation KeyWordsListener

- (id)init {
    self = [super init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keywordsUpdated)
                                                 name:nKEYWORDS_CHANGED
                                               object:nil];
    return self;
}

- (void)keywordsUpdated {
    self.onKeyWordUpdatedHandler();
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
