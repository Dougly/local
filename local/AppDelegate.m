//  AppDelegate.m
//  joueclub
//
//  Created by Nick Savula on 7/28/15.
//  Copyright (c) 2015 Tilf AB. All rights reserved.
//

#import "AppDelegate.h"
#import "Local-swift.h"
#import "MTSettings.h"
#import "FacebookFacade.h"
#import "MTLoginViewController.h"
#import "MTMainViewController.h"
#import "Countly.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation NSURLRequest(DataController)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}
@end

static PanelsViewController *rootController;

@interface AppDelegate ()
@property (nonatomic, strong) FacebookFacade *facebook;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self.facebook application:application didFinishLaunchingWithOptions:launchOptions];
    [self setupCrashlytics];
    [self setupNavigationColors];
    [self setupCountly];
    return YES;
}

- (void)setupCrashlytics {
    [Fabric with:@[[Crashlytics class]]];
}

- (void)setupCountly {
    CountlyConfig* config = CountlyConfig.new;
    config.deviceID = CLYIDFV;
    
    config.appKey = COUNTLY_APP_ID;
    config.host = @"https://try.count.ly";
    
    [Countly.sharedInstance startWithConfig:config];
}

- (void)setupNavigationColors {
    [UINavigationBar appearance].translucent = NO;
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : kLocalColor}];
    [[UINavigationBar appearance] setTintColor:kLocalColor];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: kLocalColor,
                                                            NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:18.0f]
                                                            }];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[MTSettings sharedSettings] overwriteKeyWordsAccordingToDayTime];
    [[NSNotificationCenter defaultCenter] postNotificationName:nFOREGROUND object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:nKEYWORDS_CHANGED object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self.facebook activateAppTrack];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self.facebook closeAndClearCache:YES];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if (!url) { return NO; }
    DLog(@"application handleOpenURL: %@",url);
    BOOL handled = [self.facebook application:application
                                      openURL:url
                                      options:options];
    
    return handled;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if (!url) { return NO; }
    DLog(@"application handleOpenURL: %@",url);
    BOOL handled = [self.facebook application:application
                                      openURL:url
                            sourceApplication:sourceApplication
                                   annotation:annotation];
    
    return handled;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    DLog(@"application handleOpenURL: %@",url);
    return YES;
}


+ (AppDelegate *)sharedApplication {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark -
#pragma mark Accessors

- (FacebookFacade *)facebook {
    if (!_facebook) {
        _facebook = [FacebookFacade sharedInstance];
    }
    return _facebook;
}


@end
