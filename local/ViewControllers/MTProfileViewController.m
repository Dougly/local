//
//  MTProfileViewController.m
//  Automatize
//
//  Created by Rostyslav.Stepanyak on 3/19/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MTProfileViewController.h"
#import "AppDelegate.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"

@interface MTProfileViewController ()
@end

@implementation MTProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sidePanelController.minimumMovePercentage = 40;
}

/*
- (void)setupLogoutButton {
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];
    
    self.navigationItem.rightBarButtonItems=@[logoutButton];
}
*/
@end
