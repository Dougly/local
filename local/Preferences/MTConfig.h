//
//  TRConfig.h
//  Steven Koposov 
//
//  Created by Steven Koposov  on 05/6/16.
//  Copyright (c) 2015 Steven Koposov . All rights reserved.
//


#import "MTConstants.h"
#import "MTAppManager.h"
#import "MTStoryboardFlow.h"
#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import "UINavigationController+Transition.h"
#import <UserNotifications/UserNotifications.h>

#define XCODE_COLORS_ESCAPE @"\033["

#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color

#define LogError(frmt, ...)     NSLog((XCODE_COLORS_ESCAPE @"fg206,77,130;"     frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogSuccess(frmt, ...)   NSLog((XCODE_COLORS_ESCAPE @"fg252,139,29;"     frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogInfo(frmt, ...)      NSLog((XCODE_COLORS_ESCAPE @"fg102,204,255;"    frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogWarning(frmt, ...)   NSLog((XCODE_COLORS_ESCAPE @"fg254,223,132;"    frmt XCODE_COLORS_RESET), ##__VA_ARGS__)

/* STORYBOARD IDENTIFIER */
//-------------------------------------------------------------------------------------
#define MAIN_STORYBOARD_IPHONE @"Main"
#define MAIN_STORYBOARD_IPAD @"Main-iPad"

#define CLASS_IDENTIFIER(className) [[className class] description]
#define VIEW_CONTROLLER(className) [className viewControllerFromStoryboardName:MAIN_STORYBOARD_IPHONE withIdentifier:CLASS_IDENTIFIER(className)]
//-------------------------------------------------------------------------------------

/* DEBUG LOGS */
//-------------------------------------------------------------------------------------
//#ifdef DEBUG  // RLO - Uncommented NSLog in order to show the DLog print stmts in the console
//// But this resulted in  many errors.  So I made my own RLog print stmt and added it where I wanted more visibility
//#   define DLog(fmt, ...) //NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
//#   define RLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
//#else
//#   define RLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
//#   define DLog(...)
//#endif

// ALog always displays output regardless of the DEBUG setting
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define DDLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#define jsonValue(jsonRepresentation) ((id)jsonRepresentation != [NSNull null]) ? jsonRepresentation : nil
#define jsonValueNullString(jsonRepresentation) ((id)jsonRepresentation != [NSNull null] && (id)jsonRepresentation != nil) ? jsonRepresentation : [NSNull null]

#define stringOrEmpty(A)  ({ __typeof__(A) __a = (A); __a ? __a : @""; })
#define stringOrDash(A)  ({ __typeof__(A) __a = (A); __a ? __a : @"-"; })

#define stringOrEmptyJson(jsonRepresentation) stringOrEmpty(jsonValue(jsonRepresentation))

#define LOCALIZED_STRING(stringKey) NSLocalizedString(stringKey, nil)

/* BLOCK MAIN QUEUE*/
#define BLOCK_ASYNC_RUN_MAIN_QUEUE(methods) dispatch_async(dispatch_get_main_queue(), ^{methods})

/* SHARED INSTANCE BLOCK */
//-------------------------------------------------------------------------------------
#define BLOCK_SAFE_RUN(block, ...) block ? block(__VA_ARGS__) : nil

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject;
//-------------------------------------------------------------------------------------

// check device orientation
#define dDeviceOrientation [[UIDevice currentDevice] orientation]
#define Is_Portrait  UIDeviceOrientationIsPortrait(dDeviceOrientation)
#define Is_Landscape UIDeviceOrientationIsLandscape(dDeviceOrientation)
#define Is_FaceUp    dDeviceOrientation == UIDeviceOrientationFaceUp   ? YES : NO
#define Is_FaceDown  dDeviceOrientation == UIDeviceOrientationFaceDown ? YES : NO

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_IPHONE_4 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 480.0f)
#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))
#define IS_IPHONE_6_PLUS ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 736)

#define IS_IPHONE_6 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 667)

#define ASSET_BY_SCREEN_HEIGHT(regular, longScreen) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? regular : longScreen)

//-------------------------------------------------------------------------------------------------
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
//    #define IS_IOS7 SYSTEM_VERSION_EQUAL_TO(@"7.0")
#define IS_IOS7 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
#define IS_IOS8 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1)

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


#define IS_SUCCESSFUL_HTTP_STATUS(r) (((r) / 100) == 2)

#ifdef __IPHONE_8_0
// suppress these errors until we are ready to handle them
#pragma message "Ignoring designated initializer warnings"
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
#else
// temporarily define an empty NS_DESIGNATED_INITIALIZER so we can use now,
// will be ready for iOS8 SDK
#define NS_DESIGNATED_INITIALIZER
#endif
