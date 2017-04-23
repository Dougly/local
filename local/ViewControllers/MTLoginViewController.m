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
}

@end
