//
//  FacebookFacade.m
//  Hiiper
//
//  Created by Steven Koposov on 6/8/16.
//  Copyright © 2016 Hiiper llc. All rights reserved.
//

#import "FacebookFacade.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>


static NSString * const kFacebookToken          = @"facebookToken";
static NSString * const kFacebookKey            = @"1424924484468736";
static NSString * const kFacebookAppIdKey       = @"ACFacebookAppIdKey";
static NSString * const kFacebookAudienceKey    = @"ACFacebookAudienceKey";
static NSString * const kFacebookPermissionsKey = @"ACFacebookPermissionsKey";
static NSString * const kFacebookParameters     = @"id,name,link,first_name,last_name, picture.type(large),email";

@interface FacebookFacade ()

- (BOOL)isSocialAvailable;
- (void)handleAuthError:(NSError *)error;
- (void)showMessage:(NSString *)text withTitle:(NSString *)title;

@property (strong, nonatomic) NSString *objectID;

@end

@implementation FacebookFacade

+ (instancetype)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^ {
        [self profileSettings];
        return [[self alloc] init];
    });
}

+ (void)profileSettings {
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
}

#pragma mark - Facebook Session

- (FBSDKAccessToken *)activeSession {
    return [FBSDKAccessToken currentAccessToken];
}

- (BOOL)isSessionOpen {
    return [self activeSession]?YES:NO;
}

- (void)activateAppTrack {
    [FBSDKAppEvents activateApp];
}

- (BOOL)hasStateCreatedTokenLoaded {
    return ([[self activeSession] tokenString].length > 0);
}

- (void)closeAndClearCache:(BOOL)clear {
    FBSDKLoginManager *logMeOut = [[FBSDKLoginManager alloc] init];
    [logMeOut logOut];
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [FBSDKProfile setCurrentProfile:nil];
}

- (NSString *)sessionAccessToken {
    return [[self activeSession] tokenString];
}

#pragma mark - Facebook User Profile

- (FBSDKProfile *)facebookProfile {
    return [FBSDKProfile currentProfile];
}

#pragma mark - Facebook Application Profile

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                       annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
            ];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
   return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                   openURL:url
                                         sourceApplication:sourceApplication
                                                annotation:annotation];
}

- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)options {
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:options];
}

#pragma mark - Facebook User Permissions

- (void)startRequestForMeWithCompletionHandler:(FacebookRequestHandler)block {
     [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": kFacebookParameters}] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (error) {
             [self handleAuthError:error];
         }         
         BLOCK_SAFE_RUN(block, result, error);
     }];
}

- (void)openSessionWithCompletionHandler:(SimpleBlock)block
                         andFailureBlock:(SimpleBlock)failure {
    if ([self hasStateCreatedTokenLoaded] && [self isSessionOpen]) {
        BLOCK_SAFE_RUN(block);
    } else {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        login.loginBehavior = FBSDKLoginBehaviorNative;
        [login logInWithReadPermissions:@[@"public_profile", @"email"]
                     fromViewController:nil
                                handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                    if (error) {
                                        NSLog(@"Process error");
                                        BLOCK_SAFE_RUN(failure);
                                        [self handleAuthError:error];
                                    } else if (result.isCancelled) {
                                        BLOCK_SAFE_RUN(failure);
                                        NSLog(@"Cancelled");
                                    } else {
                                        NSLog(@"Logged in");
                                        BLOCK_SAFE_RUN(block);
                                    }
                                }];
    }
}

- (NSString *)userAvatarURLString:(NSString *)fbuid {
    return [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", fbuid];
}

#pragma mark - utility methods

- (void)handleAuthError:(NSError *)error {
//    NSString *message = error.userInfo[FBSDKErrorLocalizedDescriptionKey];
//    NSString *title = error.userInfo[FBSDKErrorLocalizedTitleKey];
//    [self showMessage:title withTitle:message];
}

- (void)showMessage:(NSString *)text withTitle:(NSString *)title {
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)startRequestForNativeSocialWithCompletionHandler:(SocialRequestHandlerCompletion)completion
                                                 failure:(SocialRequestHandlerFailure)failure {
    if ([self isSocialAvailable]) {
        ACAccountStore *account = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
        NSDictionary *options = @{kFacebookAppIdKey         : kFacebookKey,
                                  kFacebookPermissionsKey   : @[@"public_stream", @"email", @"user_friends"],
                                  kFacebookAudienceKey      : ACFacebookAudienceEveryone};
        [account requestAccessToAccountsWithType:accountType options:options
                                      completion:^(BOOL granted, NSError *error)
         {
             if (granted == YES) {
                 NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
                 if ([arrayOfAccounts count] > 0) {
                     ACAccount *facebookAccount = [arrayOfAccounts objectAtIndex:0];
                     NSURL *URL = [NSURL URLWithString:@"https://graph.facebook.com/me"];
                     SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                                             requestMethod:SLRequestMethodGET
                                                                       URL:URL
                                                                parameters:nil];
                     [request setAccount:facebookAccount]; // Authentication - Requires user context
                     [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError* error) {
                         // parse the response or handle the error
                         if (!error) {
                             NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:responseData
                                                                                      options:NSJSONReadingMutableLeaves
                                                                                        error:&error];
                             if (userInfo[@"error"] != nil) {
                                 [account renewCredentialsForAccount:facebookAccount
                                                          completion:^(ACAccountCredentialRenewResult renewResult, NSError *error)
                                  {
                                      if(!error) {
                                          switch (renewResult) {
                                              case ACAccountCredentialRenewResultRenewed:
                                                  NSLog(@"Good to go");
                                                  break;

                                              case ACAccountCredentialRenewResultRejected:
                                                  NSLog(@"User declined permission");
                                                  break;

                                              case ACAccountCredentialRenewResultFailed:
                                                  NSLog(@"non-user-initiated cancel, you may attempt to retry");
                                                  break;

                                              default:
                                                  break;
                                          }

                                      } else {
                                          //handle error
                                          NSLog(@"error from renew credentials: %@",error);
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                  message:error.localizedDescription
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"OK"
                                                                                        otherButtonTitles:nil];
                                              [alertView show];
                                          });
                                      }
                                  }];
                             } else {
                                 NSMutableDictionary *facebookUserInfo = [userInfo mutableCopy];
                                 [facebookUserInfo setObject:[[facebookAccount credential] oauthToken]
                                                      forKey:kFacebookToken];
                                 BLOCK_SAFE_RUN(completion, facebookUserInfo ,error);
                             }
                         } else {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                     message:error.localizedDescription
                                                                                    delegate:nil
                                                                           cancelButtonTitle:@"OK"
                                                                           otherButtonTitles:nil];
                                 [alertView show];
                             });
                         }
                     }];
                 } else {
                     BLOCK_SAFE_RUN(failure, error);
                 }
             } else {
                 BLOCK_SAFE_RUN(failure, error);
             }
         }];
    } else {
        BLOCK_SAFE_RUN(failure, 0);
    }
}

#pragma mark - Accessor overrides

- (BOOL)isSocialAvailable {
    return NSClassFromString(@"SLComposeViewController") != nil;
}
@end
