//
//  KeyWordsListener.m
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/30/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "FilterViewListener.h"

@implementation FilterViewListener

- (id)init {
    self = [super init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideFilterView:)
                                                 name:nHIDE_FILTER_VIEW_NOTIFICATION
                                               object:nil];
    
    return self;
}

- (void)hideFilterView:(NSNotification *)notification {
    BOOL shouldRevert = false;
    
    if (notification.userInfo[kRevertFilterViewToPreviousIndex]) {
        shouldRevert = true;
    }
    
    if (self.onFilterViewCloseHandler)
        self.onFilterViewCloseHandler(shouldRevert);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
