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

static NSString * const kFacebookToken = @"facebookToken";
static NSString * const kFirstName     = @"first_name";
static NSString * const kLastName      = @"last_name";
static NSString * const kGender        = @"gender";
static NSString * const kEmail         = @"email";
static NSString * const kId            = @"id";

@interface MTLoginViewController ()
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
}

- (void)showMainScreen:(BOOL)isAnimated {    
    MTMainViewController *mainView =
    [MTMainViewController viewControllerFromStoryboardName:MTStoryboard.mainIphone
                                              withIdentifier:CLASS_IDENTIFIER(MTMainViewController)];
    [self.navigationController pushViewController:mainView animated:isAnimated];

}

- (IBAction)loginButtonClicked:(id)sender {
    [self accessToMainScreen];
}

- (IBAction)loginWithFacebook:(id)sender {
//    [self.downloadProgressHud show:YES];
    [self.facebookFacade openSessionWithCompletionHandler:^{
        [self signUpWithFacebook];
    } andFailureBlock:^{
        //    [self.downloadProgressHud hide:YES];
        [self.facebookFacade closeAndClearCache:YES];
    }];
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
                [self accessToMainScreen];
            }
        }];
    } else {
//        [self.downloadProgressHud hide:YES];
    }
}

- (void)accessToMainScreen {
    [self.presentingViewController dismissViewControllerAnimated:NO completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            MTMainViewController *mainView =
            [MTMainViewController viewControllerFromStoryboardName:MTStoryboard.mainIphone
                                                    withIdentifier:CLASS_IDENTIFIER(MTMainViewController)];
            [AppDelegate sharedApplication].window.rootViewController = mainView;
            [[AppDelegate sharedApplication].window makeKeyAndVisible];
        });
    }];
}

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
