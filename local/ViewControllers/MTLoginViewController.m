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
@property (nonatomic, weak) IBOutlet UIButton *guestButton;
@property (nonatomic, weak) IBOutlet MDButton *facebookButton;
@property (nonatomic, weak) IBOutlet MDButton *instagramButton;
@property (nonatomic, strong) FacebookFacade *facebookFacade;
@property (strong, nonatomic) MTAppManager   *appManager;

@property (nonatomic, strong) NSString *facebookEmail;
@property (nonatomic, strong) NSString *facebookID;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *name;
- (IBAction)loginWithFacebook:(id)sender;
@end

@implementation MTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.facebookButton.mdButtonType    = MDButtonTypeFlat;
    self.instagramButton.mdButtonType   = MDButtonTypeFlat;
    self.facebookButton.backgroundColor = kColorFacebook;
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateButtonVisibility];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    [self.facebookButton setSelected:NO];
    
    [self checkIfSignedIn];
}

- (void)updateButtonVisibility {
    NSString *dateToHide = @"24 May 2017";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MM yyyy"];
    
    NSDate *date = [formatter dateFromString:dateToHide];
    
    if ([date timeIntervalSinceNow] < 0.0) {
        self.guestButton.hidden = YES;
    }
}

- (void)checkIfSignedIn {
    if ([MTAppManager sharedInstance].userAuthToken) {
        [self showMainScreen];
    }
}

- (void)showMainScreen {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MTMainViewController *mainViewController = [main instantiateViewControllerWithIdentifier:@"MTMainViewController"];
    [self.navigationController pushViewController:mainViewController animated:YES];
}

- (void)showMainScreen:(BOOL)isAnimated {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    MTMainViewController *mainView = [main instantiateViewControllerWithIdentifier:@"MTMainViewController"];
    [self.navigationController pushViewController:mainView animated:isAnimated];
}

- (IBAction)loginWithFacebook:(id)sender {
    
    [self.facebookFacade openSessionWithCompletionHandler:^{
        [self signUpWithFacebook];
    } andFailureBlock:^{
        [self.facebookFacade closeAndClearCache:YES];
    }];
}

- (IBAction)loginWithInstagram:(id)sender {

    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    MTInstagramViewController *instagramViewController = [main instantiateViewControllerWithIdentifier:@"MTInstagramViewController"];
    instagramViewController.delegate = self;
    [self presentViewController:instagramViewController
                       animated:YES
                     completion:NULL];
}

- (IBAction)loginAsGuest:(id)sender {
    [self showMainScreen:YES];
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
