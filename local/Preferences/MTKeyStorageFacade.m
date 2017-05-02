//
//  MTKeyStorageFacade.m
//  Hiiper
//
//  Created by Steven Koposov on 05/6/16.
//  Copyright © 2016 Hiiper LLC. All rights reserved.
//

#import "MTKeyStorageFacade.h"
#import "SSKeychainQuery.h"
#import "NSData+Base64.h"
#import "SSKeychain.h"

#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

#if TARGET_IPHONE_SIMULATOR 
#define ACCOUNT_UUID @"IPHONE_SIMULATOR-STATIC-UUID-STRING"
#else
#define ACCOUNT_UUID [[[UIDevice currentDevice] identifierForVendor] UUIDString]
#endif

static NSString * const kServiceKey = @"com.Hiiper.Hiiper";
static NSString * const kAccount    = @"Hiiper";

@interface MTKeyStorageFacade ()

@property (nonatomic, strong, readwrite) NSString *userName;
@property (nonatomic, strong, readwrite) NSString *password;
@property (nonatomic, strong, readwrite) NSString *userID;

@end

@implementation MTKeyStorageFacade

+ (instancetype)sharedKeyStorage {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^ {
        return [[self alloc] init];
    });
}

- (void)setupCredentialStorageForAccessibility {
    [self mt_setAccessibilityType:kSecAttrAccessibleWhenUnlocked];
//    NSLog(@"ACCOUNT_UUID : %@", ACCOUNT_UUID);

//    [self mt_deleteAllAcconts];

    NSString *userUDID = [self userWithServiceKey:kServiceKey];
    if (!(userUDID.length > 0)) {
        [self setUser:[self md5HexDigest:ACCOUNT_UUID] withServiceKey:kServiceKey];
    }
    
    self.userName = [self userWithServiceKey:kServiceKey];
    self.password = [self md5HexDigest:kServiceKey] ;

//    LogInfo(@"ACCOUNT_UUID: %@", self.userName);
//    LogInfo(@"md5HexDigest: %@", self.password);

//    NSArray *accounts = [self mt_allAccounts];
//    LogInfo(@"\n**** Key Storage Facade Account: ****\n-- ACCOUNT_UUID: %@\n-- md5HexDigest: %@\n-- Account: %@",
//            self.userName,
//            self.password,
//            accounts);
}

- (NSArray *)mt_allAccounts {
    return [SSKeychain allAccounts];
}

- (void)mt_deleteAllAcconts {
    for (NSDictionary *account in [self mt_allAccounts]) {
        [self mt_deleteAllAccontsForService:account[@"svce"]];
    }
}

- (void)mt_deleteAllAccontsForService:(NSString *)serviceKey {
    SSKeychainQuery *query = [[SSKeychainQuery alloc] init];
    query.service = serviceKey;
    [query deleteItemForService:nil];
//    NSLog(@"%@",[self mt_accountsForService:serviceKey]);
}

- (NSArray *)mt_accountsForService:(NSString *)serviceName {
    return [SSKeychain accountsForService:serviceName];
}

- (NSString *)mt_passwordForService:(NSString *)serviceName
                            account:(NSString *)account
                              error:(NSError *)error {
    return [SSKeychain passwordForService:serviceName
                                  account:account
                                    error:&error];
}

- (BOOL)mt_deletePasswordForService:(NSString *)serviceName
                            account:(NSString *)account {
    return [SSKeychain deletePasswordForService:serviceName
                                        account:account];
}

- (void)mt_setAccessibilityType:(CFTypeRef)accessibilityType {
    return [SSKeychain setAccessibilityType:accessibilityType];
}

- (BOOL)mt_setPassword:(NSString *)password
            forService:(NSString *)serviceName
               account:(NSString *)account
                 error:(NSError *)error {
    return [SSKeychain setPassword:password
                        forService:serviceName
                           account:account
                             error:&error];
}

- (NSString *)hashWithKey:(NSString *)key {
    NSData *data = [key dataUsingEncoding:NSUnicodeStringEncoding];
    unsigned char hash[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(((const char *)[data bytes]) + 2, (CC_LONG)data.length - 2, hash);
    NSData *hashData = [NSData dataWithBytes:hash length:CC_SHA256_DIGEST_LENGTH];
    return [hashData base64EncodedString];
}

NSData *hmacForKeyAndData(NSString *key, NSString *data) {
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    return [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
}

- (NSString *)md5HexDigest:(NSString *)input {
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (uint32_t)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for (int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

- (void)setUser:(NSString *)userUDID withServiceKey:(NSString *)serviceKey {
    NSMutableDictionary *keys = [self basicDictionary:serviceKey];
    SecItemDelete((__bridge CFDictionaryRef)keys);
    NSData *passwordData = [userUDID dataUsingEncoding:NSUTF8StringEncoding];
    [keys setObject:passwordData forKey:(__bridge id)kSecValueData];
    SecItemAdd((__bridge CFDictionaryRef) keys, nil);
}

- (NSString *)userWithServiceKey:(NSString *)serviceKey {
    NSMutableDictionary *search = [self basicDictionary:serviceKey];
    [search setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [search setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    CFDataRef result = NULL;
    SecItemCopyMatching((__bridge CFDictionaryRef) search, ( CFTypeRef*) &result);
    NSData* passDat=(__bridge_transfer NSData*) result;
    NSString *output = [[NSString alloc] initWithData:passDat encoding:NSUTF8StringEncoding];
    //    CFRelease((__bridge CFTypeRef)(passDat));

    return output;
}

- (NSMutableDictionary *)basicDictionary:(NSString *)username {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    NSData *encodedUsername = [username dataUsingEncoding:NSUTF8StringEncoding];
    [dict setObject:encodedUsername forKey:(__bridge id)kSecAttrGeneric];
    [dict setObject:encodedUsername forKey:(__bridge id)kSecAttrAccount];
    [dict setObject:(__bridge id)kSecAttrAccessibleWhenUnlocked forKey:(__bridge id)kSecAttrAccessible];

    return dict;
}
@end
