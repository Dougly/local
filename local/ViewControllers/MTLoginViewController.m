//
//  LRLoginViewController.m
//  TotsAmour
//
//  Created by TotsAmour on 20/04/15.
//  Copyright (c) 2015 TotsAmour. All rights reserved.
//

#import "MTLoginViewController.h"
#import "MTMainViewController.h"

@interface MTLoginViewController ()
- (IBAction)loginButtonClicked:(id)sender;
@end

@implementation MTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)showMainScreen:(BOOL)isAnimated {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MTMainViewController *mainViewController = [main instantiateViewControllerWithIdentifier:@"MTMainViewController"];
    [self.navigationController pushViewController:mainViewController animated:isAnimated];
}

- (IBAction)loginButtonClicked:(id)sender {
    [self showMainScreen:YES];
}

@end
