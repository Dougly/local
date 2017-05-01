//
//  KeyWordsListener.h
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/30/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^onKeywordUpdated)();

@interface KeyWordsListener : NSObject
@property (nonatomic, strong) onKeywordUpdated onKeyWordUpdatedHandler;
@end
