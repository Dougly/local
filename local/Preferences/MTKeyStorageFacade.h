//
//  MTKeyStorageFacade.h
//  Hiiper
//
//  Created by Steven Koposov on 05/6/16.
//  Copyright © 2016 Hiiper LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTKeyStorageFacade : NSObject

@property (nonatomic, strong, readonly) NSString *userName;
@property (nonatomic, strong, readonly) NSString *password;
@property (nonatomic, strong, readonly) NSString *userID;

+ (instancetype)sharedKeyStorage;


- (void)setupCredentialStorageForAccessibility;

- (NSArray *)mt_allAccounts;
- (NSArray *)mt_accountsForService:(NSString *)serviceName;

- (NSString *)mt_passwordForService:(NSString *)serviceName
                            account:(NSString *)account
                              error:(NSError *)error;

- (BOOL)mt_deletePasswordForService:(NSString *)serviceName
                            account:(NSString *)account;

- (void)mt_setAccessibilityType:(CFTypeRef)accessibilityType;
- (BOOL)mt_setPassword:(NSString *)password
            forService:(NSString *)serviceName
               account:(NSString *)account
                 error:(NSError *)error;
@end
