//
//  RootViewController.m
//  arthome
//
//  Created by Steven on 13/10/14.
//  Copyright (c) 2014 Umbrella. All rights reserved.
//

#import "PanelsViewController.h"

#import "MTMenuViewController.h"


@interface PanelsViewController ()

@end

@implementation PanelsViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.isShadow = YES;
}

- (void)setPanels {
    self.isShadow = self.isPanelShadow;
    self.leftPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"MTMenuViewController"];
    UIViewController *dispatchViewContorller = [self.storyboard    instantiateViewControllerWithIdentifier:@"MTDispatchViewController"];
    dispatchViewContorller.title = @"Dispatch";
    self.centerPanel = [[UINavigationController alloc] initWithRootViewController:dispatchViewContorller];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setCentralPanelControllerWithIdentifier:(NSString *)identifier {
    @autoreleasepool {
        self.centerPanel = [[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:identifier]];
    }
}

- (void)setCentralPanelControllerViewController:(UIViewController *)viewController {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.centerPanel = navController;
}

@end
