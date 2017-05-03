//
//  MTLoginViewController.m
//  TotsAmour
//
//  Created by Steven on 09/02/17.
//  Copyright (c) 2015 Steven. All rights reserved.
//

#import "MTLoginViewController.h"
#import "MTMainViewController.h"
#import "FacebookFacade.h"
#import "MDButton.h"
#import "MTInstagramViewController.h"

static NSString * const kFacebookToken = @"facebookToken";
static NSString * const kFirstName     = @"first_name";
static NSString * const kLastName      = @"last_name";
static NSString * const kGender        = @"gender";
static NSString * const kEmail         = @"email";
static NSString * const kId            = @"id";

@interface MTLoginViewController ()<InstagramAuthDelegate>
@property (nonatomic, weak) IBOutlet MDButton *facebookButton;
@property (nonatomic, strong) FacebookFacade *facebookFacade;
@property (strong, nonatomic) MTAppManager   *appManager;

@property (nonatomic, strong) NSString *facebookEmail;
@property (nonatomic, strong) NSString *facebookID;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *name;
- (IBAction)loginButtonClicked:(id)sender;
- (IBAction)loginWithFacebook:(id)sender;
@end

@implementation MTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.facebookButton.mdButtonType    = MDButtonTypeFlat;
    self.facebookButton.backgroundColor = kColorFacebook;
    [self setupStyleNavigationBarModal];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    [self.facebookButton setSelected:NO];
    
    [self checkIfSignedIn];
}

- (void)checkIfSignedIn {
    if ([MTAppManager sharedInstance].userAuthToken) {
        [self showMainScreen];
    }
}

- (void)showMainScreen {
    MTMainViewController *mainViewController =
    [MTMainViewController viewControllerFromStoryboardName:MTStoryboard.mainIphone
                                                withIdentifier:CLASS_IDENTIFIER(MTMainViewController)];
    [self.navigationController pushViewController:mainViewController animated:YES];
}

- (void)showMainScreen:(BOOL)isAnimated {    
    MTMainViewController *mainView =
    [MTMainViewController viewControllerFromStoryboardName:MTStoryboard.mainIphone
                                              withIdentifier:CLASS_IDENTIFIER(MTMainViewController)];
    [self.navigationController pushViewController:mainView animated:isAnimated];
}

- (IBAction)loginWithFacebook:(id)sender {
        //[self.downloadProgressHud show:YES];
    [self.facebookFacade openSessionWithCompletionHandler:^{
        [self signUpWithFacebook];
    } andFailureBlock:^{
        //[self.downloadProgressHud hide:YES];
        [self.facebookFacade closeAndClearCache:YES];
    }];
}

- (IBAction)loginWithInstagram:(id)sender {
    MTInstagramViewController *instagramViewController =
    [MTInstagramViewController viewControllerFromStoryboardName:MTStoryboard.mainIphone
                                            withIdentifier:CLASS_IDENTIFIER(MTInstagramViewController)];
    instagramViewController.delegate = self;
    [self presentViewController:instagramViewController
                       animated:YES
                     completion:NULL];
}

- (void)signUpWithFacebook {
    if ([self.facebookFacade isSessionOpen]) {
        [self.facebookFacade startRequestForMeWithCompletionHandler:^(id result, NSError *error) {
            NSString *facebookToken = [self.facebookFacade sessionAccessToken];
            self.facebookID    = result[kId];
            self.facebookEmail = result[kEmail];
            self.firstName     = result[kFirstName];
            self.lastName      = result[kLastName];
            self.name          = [NSString stringWithFormat:@"%@ %@",self.firstName, self.lastName];
            
            self.appManager.userAuthToken = facebookToken;
            self.appManager.userName      = self.name;
            self.appManager.userEmail     = self.facebookEmail;
            self.appManager.facebookID    = self.facebookID;
            [[MTAppManager sharedInstance] save];
            if (self.appManager.userAuthToken) {
                [self showMainScreen];
            }
        }];
    } else {
    }
}

#pragma mark - instagram delegate

- (void)onAuthenticated:(NSString *)authToken {
    [self dismissViewControllerAnimated:YES completion:^{
        self.appManager.userAuthToken = authToken;
        [self showMainScreen];
    }];
}

#pragma mark - access overrides

- (FacebookFacade *)facebookFacade {
    if (!_facebookFacade) {
        _facebookFacade = [FacebookFacade sharedInstance];
    }
    return _facebookFacade;
}

- (MTAppManager *)appManager {
    if (!_appManager) {
        _appManager = [MTAppManager sharedInstance];
    }
    return _appManager;
}

@end
