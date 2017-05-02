//
//  AppManager.m
//  Steven Koposov 
//
//  Created by Steven Koposov on 05/6/16.
//  Copyright (c) 2016 Steven Koposov. All rights reserved.
//

#import "MTAppManager.h"

@implementation MTAppManager

+ (instancetype)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^ {
        return [[self alloc] init];
    });
}

- (id)init {
    self = [super init];
    if (self) {
        [self load];
    }
    return self;
}

- (void)load {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.rootShopChainID    = [defaults objectForKey:@"rootShopChainID"];
    self.searchPath         = [defaults objectForKey:@"searchPath"];
    self.basketProductsCout = [defaults integerForKey:@"basketProductsCout"];
    self.basketProductsCout = [defaults integerForKey:@"marketsBasketCount"];
    
    self.cookies            = [defaults objectForKey:@"cookies"];
    self.userAuthToken      = [defaults objectForKey:@"userAuthToken"];
    self.activeUserID       = [defaults objectForKey:@"userID"];
    self.deviceToken        = [defaults objectForKey:@"deviceToken"];
    self.isLogin            = [defaults boolForKey:@"isLogin"];
    self.userName           = [defaults objectForKey:@"userName"];
    self.userEmail          = [defaults objectForKey:@"userEmail"];
    self.facebookID         = [defaults objectForKey:@"facebookID"];

    self.currentAppVersion      = [defaults objectForKey:@"currentAppVersion"];
    self.debugCacheResponseData = [defaults objectForKey:@"debugCacheResponseData"];
    self.searchHash             = [defaults objectForKey:@"searchHash"];
    self.debugCachedataItems    = [defaults objectForKey:@"debugCachedataItems"];
    self.xscIDs                 = [defaults objectForKey:@"xscIDs"];
    self.cardID                 = [defaults objectForKey:@"cardID"];
    self.specs                  = [defaults objectForKey:@"specs"];
    self.productsIDs            = [defaults objectForKey:@"productsIDs"];
    self.favoriteMarket         = [defaults objectForKey:@"favoriteMarket"];
    self.isIntroViewed          = [defaults boolForKey:@"isIntroViewed"];
    self.isCoachMarkViewed      = [defaults boolForKey:@"isCoachMarkViewed"];
    self.isContestPosted      = [defaults boolForKey:@"isContestPosted"];
    
    [defaults setValue:@(NO) forKey:@"_UIConstraintBasedLayoutLogUnsatisfiable"];
}

- (void)save {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setInteger:self.basketProductsCout forKey:@"basketProductsCout"];
    [defaults setInteger:self.marketsBasketCount forKey:@"marketsBasketCount"];
    
    [defaults setValue:self.rootShopChainID     forKey:@"rootShopChainID"];
    [defaults setValue:self.searchPath          forKey:@"searchPath"];
    [defaults setValue:self.cookies             forKey:@"cookies"];
    [defaults setValue:self.userAuthToken       forKey:@"userAuthToken"];
    [defaults setValue:self.activeUserID        forKey:@"userID"];
    [defaults setValue:self.deviceToken         forKey:@"deviceToken"];
    [defaults setValue:self.currentAppVersion   forKey:@"currentAppVersion"];
    [defaults setValue:self.userName            forKey:@"userName"];
    [defaults setValue:self.userName            forKey:@"userName"];
    [defaults setValue:self.facebookID          forKey:@"facebookID"];
    [defaults setValue:self.searchHash          forKey:@"searchHash"];
    [defaults setValue:self.debugCachedataItems forKey:@"debugCachedataItems"];
    [defaults setValue:self.xscIDs              forKey:@"xscIDs"];
    [defaults setValue:self.cardID              forKey:@"cardID"];
    [defaults setValue:self.specs               forKey:@"specs"];
    [defaults setValue:self.productsIDs         forKey:@"productsIDs"];
    [defaults setValue:self.favoriteMarket      forKey:@"favoriteMarket"];

    [defaults setBool:self.isIntroViewed        forKey:@"isIntroViewed"];
    [defaults setBool:self.isCoachMarkViewed    forKey:@"isCoachMarkViewed"];
    [defaults setBool:self.isContestPosted      forKey:@"isContestPosted"];
    [defaults setBool:self.isLogin              forKey:@"isLogin"];

    [defaults setValue:self.debugCacheResponseData forKey:@"debugCacheResponseData"];
    [defaults synchronize];
}

- (void)reset {
    self.rootShopChainID        = nil;
    self.searchPath             = nil;
    self.basketProductsCout     = 0;
    self.basketProductsCout     = 0;
    self.productsIDs            = nil;
    self.cardID                 = nil;
    self.xscIDs                 = nil;
    self.cookies                = nil;
    self.userAuthToken          = nil;
    self.activeUserID           = nil;
    self.activeUserID           = nil;
    self.isLogin                = nil;
    self.currentAppVersion      = nil;
    self.userName               = nil;
    self.userEmail              = nil;
    self.facebookID             = nil;
    self.debugCacheResponseData = nil;
    self.searchHash             = nil;
    self.debugCachedataItems    = nil;
    self.favoriteMarket         = nil;
//    self.isIntroViewed          = NO;
//    self.isCoachMarkViewed      = NO;
    [self save];
}


@end
