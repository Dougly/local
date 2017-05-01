//
//  MTMainViewController.m
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/27/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MTMainViewController.h"
#import "CMTabbarView.h"
#import "FilterView.h"
#import "MTSettings.h"

#define FILTER_VIEW_HEIGHT              150

typedef NS_ENUM(NSInteger, MTMainMenuIndex) {
    MTMainMenuBreakfast = 0,
    MTMainMenuLunch,
    MTMainMenuDinner,
    MTMainMenuFilter
};

@interface MTMainViewController ()<CMTabbarViewDelegate, CMTabbarViewDatasouce, FilterViewDelegate>
@property (nonatomic, weak) IBOutlet UIView *placeHolderForTabbarView;
@property (nonatomic, weak) IBOutlet CMTabbarView *tabbarView;
@property (nonatomic, strong) IBOutlet FilterView *filterView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *leftMarginForBottomMenuConstraint;
@property (nonatomic) BOOL filterMenuVisisble;
@end

@implementation MTMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTabbar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self adjustMenuConstraint];
}

- (void)addTabbar {
    self.tabbarView.delegate = self;
    self.tabbarView.dataSource = self;
}

- (NSArray<NSString *> *)tabbarTitlesForTabbarView:(CMTabbarView *)tabbarView {
    return MEAL_TYPES;
}

#pragma mark - FilterView

- (void)showFilterView {
    self.filterView = [[[NSBundle mainBundle] loadNibNamed:@"FilterView" owner:self options:nil] objectAtIndex:0];
    self.filterView.delegate = self;
    self.filterView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:self.filterView];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.filterView.frame = CGRectMake(0, self.view.bounds.size.height - FILTER_VIEW_HEIGHT - BOTTOM_NAVIGATION_BAR_HEIGHT, self.view.bounds.size.width, FILTER_VIEW_HEIGHT);
        self.filterMenuVisisble = true;
    }];
}

- (void)hideFilterView {
    [UIView animateWithDuration:0.4 animations:^{
        self.filterView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, FILTER_VIEW_HEIGHT);
    } completion:^(BOOL finished) {
        [self.filterView removeFromSuperview];
        self.filterMenuVisisble = false;
    }];
}

#pragma mark - CMTabbarViewDelegate

- (void)tabbarView:(CMTabbarView *)tabbarView didSelectedAtIndex:(NSInteger)index {
    if (index == MTMainMenuFilter) {
        self.filterMenuVisisble ?  [self hideFilterView] : [self showFilterView];
    }
    else {
        [MTSettings sharedSettings].filterKeyWords = MEAL_TYPES[index];
        [self hideFilterView];
    }
}

#pragma mark - bottom menu constraints

- (void)adjustMenuConstraint {
    if (IS_IPHONE_6) {
        
    }
    
    if (IS_IPHONE_5) {
        self.leftMarginForBottomMenuConstraint.constant = 15;
    }
    
    if (IS_IPHONE_6_PLUS) {
        self.leftMarginForBottomMenuConstraint.constant = 45;
    }
}

@end
