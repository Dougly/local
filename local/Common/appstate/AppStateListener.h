//
//  KeyWordsListener.h
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/30/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^onForeground)();

@interface AppStateListener : NSObject
@property (nonatomic, strong) onForeground onForegroundHandler;
@end
