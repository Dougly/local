//
//  FacebookFacade.h
//  Hiiper
//
//  Created by Steven Koposov on 6/8/16.
//  Copyright © 2016 Hiiper llc. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


typedef void (^FacebookRequestHandler)(id result, NSError *error);
typedef void (^SocialRequestHandlerCompletion)(id responseObject, NSError *error);
typedef void (^SocialRequestHandlerFailure)(id error);
typedef void (^SocialRequestHandlerProgressBlock)(NSInteger progressCount, NSInteger totalCount);

typedef void (^SimpleBlock)();
typedef void (^FallbackHandler)(NSString *url);

@interface FacebookFacade : NSObject

+ (instancetype)sharedInstance;

- (FBSDKAccessToken *)activeSession;
- (void)activateAppTrack;

- (BOOL)isSessionOpen;
- (BOOL)hasStateCreatedTokenLoaded;
- (void)closeAndClearCache:(BOOL)clear;
- (NSString *)sessionAccessToken;
- (void)startRequestForMeWithCompletionHandler:(FacebookRequestHandler)block;
- (void)startRequestForNativeSocialWithCompletionHandler:(SocialRequestHandlerCompletion)completion
                                                 failure:(SocialRequestHandlerFailure)failure;

/*!
 @abstract
 Method tries checks session state.
 If session is open and hasStateCreatedTokenLoaded just launch completion handler block
 otherwise it try to open session with openActiveSessionWithReadPermissions:@"email"
 and depending on result launch completion or failure blocks
 */
- (void)openSessionWithCompletionHandler:(SimpleBlock)block andFailureBlock:(SimpleBlock)failure;

/*!
 @abstract
 A helper method that is used to provide an implementation for
 [UIApplicationDelegate application:openURL:sourceApplication:annotation:]. It should be invoked during
 the Facebook Login flow and will update the session information based on the incoming URL.

 @param url The URL as passed to [UIApplicationDelegate application:openURL:sourceApplication:annotation:].
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary *)option;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

- (void)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)options;

- (NSString *)userAvatarURLString:(NSString *)fbuid;
//- (void)profileImageWithFBID:(NSString *)fbuid completion:(CompletionBlock)completionBlock;


@end

