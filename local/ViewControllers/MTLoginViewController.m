//
//  LRLoginViewController.m
//  TotsAmour
//
//  Created by TotsAmour on 20/04/15.
//  Copyright (c) 2015 TotsAmour. All rights reserved.
//

#import "MTLoginViewController.h"
#import "PanelsViewController.h"
#import "AppDelegate.h"
#import "MTDataModel.h"

@interface MTLoginViewController ()
- (IBAction)loginButtonClicked:(id)sender;
@end

@implementation MTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)showMainScreen:(BOOL)isAnimated {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PanelsViewController *sidebarController = [main instantiateViewControllerWithIdentifier:@"PanelsViewController"];
    [self.navigationController pushViewController:sidebarController animated:isAnimated];
    [AppDelegate setRootController:sidebarController];
}

- (IBAction)loginButtonClicked:(id)sender {
    [self showMainScreen:YES];
    
    /*MTLoginRequest *request = [MTLoginRequest requestWithOwner:self];
    
    request.email = [self.loginEmailField.attributedText string];
    request.password = [self.loginPassField.attributedText string];
    request.deviceId = [SDKeyStorage UUID];
    request.deviceType = [NSString stringWithFormat:@"%@ %@",[[UIDevice currentDevice] model] ,[UIDevice currentDevice].systemVersion];
    request.lat = @"40.78234";
    request.lon = @"-73.935242";
    
    [[MTProgressHUD sharedHUD] showOnView:self.view
                               percentage:false];
    __weak typeof (self) weakSelf = self;
    request.completionBlock = ^(SDRequest *request, SDResult *response)
    {
        if ([response isSuccess]) {
            [weakSelf getPreviousVehicle];
        }
        else {
            [[MTProgressHUD sharedHUD] dismiss];
            NSString *message = (response.message) ? response.message : sServerNotAccessible;
            [MTAlertBuilder showAlertIn:self
                                message:message
                               delegate:nil];
        }
    };
    
    [request run];*/
}

@end
