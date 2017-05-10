//
//  KeyWordsListener.h
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/30/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^onFilterViewClose)(BOOL shouldRevertToPreviousIndex);

@interface FilterViewListener : NSObject
@property (nonatomic, strong) onFilterViewClose onFilterViewCloseHandler;
@end
