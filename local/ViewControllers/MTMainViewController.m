//
//  MTMainViewController.m
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/27/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MTMainViewController.h"
#import "CMTabbarView.h"

@interface MTMainViewController ()<CMTabbarViewDelegate, CMTabbarViewDatasouce>
@property (nonatomic, weak) IBOutlet UIView *placeHolderForTabbarView;
@property (nonatomic, weak) IBOutlet CMTabbarView *tabbarView;
@end

@implementation MTMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTabbar];
}

- (void)addTabbar {
    self.tabbarView.delegate = self;
    self.tabbarView.dataSource = self;
}

- (NSArray<NSString *> *)tabbarTitlesForTabbarView:(CMTabbarView *)tabbarView {
    return @[@"BREAKFAST", @"LUNCH", @"DINNER"];
}

@end
