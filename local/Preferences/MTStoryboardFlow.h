//
//  MTStoryboardFlow.h
//  Hiiper
//
//  Created by Steven on 31/03/17.
//  Copyright © 2017 Hiiper llc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const struct MTStoryboardIdentify {
    __unsafe_unretained NSString *mainIphone;
    __unsafe_unretained NSString *mainIpad;
    __unsafe_unretained NSString *loginFlow; 
    __unsafe_unretained NSString *unknown;
} MTStoryboard;

@interface MTStoryboardFlow : NSObject
@property (nonatomic, assign) struct MTStoryboardIdentify storyboard;
@end
