//
//  AppManager.h
//  Steven Koposov 
//
//  Created by Steven Koposov on 05/6/16.
//  Copyright (c) 2016 Steven Koposov . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTAppManager : NSObject

#pragma mark -  Class Methods

+ (instancetype)sharedInstance;

#pragma mark -  Instantce Public Methods

- (void)load;
- (void)save;
- (void)reset;

#pragma mark - Common Properties

@property (nonatomic, strong) NSString *currentAppVersion;
@property (nonatomic, strong) NSString *activeUserID;
@property (nonatomic, strong) NSString *userAuthToken;
@property (nonatomic, strong) NSString *cookies;
@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong) NSString *searchHash;
@property (nonatomic, strong) NSNumber *cardID;

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *facebookID;
@property (nonatomic, strong) NSString *potentialUserEmail;

@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, assign) BOOL isIntroViewed;
@property (nonatomic, assign) BOOL isCoachMarkViewed;
@property (nonatomic, assign) BOOL isContestPosted;

@property (nonatomic, strong) NSString  *rootShopChainID;
@property (nonatomic, strong) NSString  *searchPath;
@property (nonatomic, assign) NSInteger basketProductsCout;
@property (nonatomic, assign) NSInteger marketsBasketCount;

@property (nonatomic, strong) NSString *favoriteMarket;
@property (nonatomic, strong) NSArray  *productsIDs;
@property (nonatomic, strong) NSArray  *xscIDs;
@property (nonatomic, strong) NSArray  *specs;


@property (nonatomic, strong) NSDictionary *debugCacheResponseData;
@property (nonatomic, strong) NSArray      *debugCachedataItems;
@property (nonatomic, assign) BOOL         isCache;

@end
