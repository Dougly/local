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
#import "AppStateListener.h"
#import "MTDataModel.h"

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

@property (nonatomic, strong) AppStateListener *appStateListener;
@property (nonatomic) NSUInteger selectedNavigationIndex;
@end

@implementation MTMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTabbar];
    [self setTabBarIndex];
    
    //We should change tab bar index based on the keywords
    __weak typeof(self) weakSelf = self;
    self.appStateListener.onForegroundHandler = ^{
        [weakSelf setTabBarIndex];
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self adjustMenuConstraint];
}

- (void)setTabBarIndex {
    NSString *keyWords = [MTSettings sharedSettings].filterKeyWords;
    
    /*Defaul point to filter icon*/
    NSUInteger index = 3;
    if ([MEAL_TYPES containsObject:keyWords]) {
        index = [MEAL_TYPES indexOfObject:keyWords];
    }
    self.tabbarView.defaultSelectedIndex = index;
    [self.tabbarView setTabIndex:index animated:false];
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

- (void)hideFilterView:(BOOL)shouldRevertToPreviousIndex {
    
    [UIView animateWithDuration:0.4 animations:^{
        self.filterView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, FILTER_VIEW_HEIGHT);
    } completion:^(BOOL finished) {
        [self.filterView removeFromSuperview];
        self.filterMenuVisisble = false;
        
        //If the filterview was dismissed and nothing was selected in filter view before - then revert to previous index
        if (shouldRevertToPreviousIndex && ![FILTERS_KEY_WORDS containsObject:[MTSettings sharedSettings].filterKeyWords]) {
            [self.tabbarView setTabIndex:self.selectedNavigationIndex animated:YES];
        }
    }];
}

#pragma mark - CMTabbarViewDelegate

- (void)tabbarView:(CMTabbarView *)tabbarView didSelectedAtIndex:(NSInteger)index {
    if (index == MTMainMenuFilter) {
        if (self.filterMenuVisisble) {
            [self hideFilterView:true];
        }
        else {
            [self showFilterView];
        }
    }
    else {
        self.selectedNavigationIndex = index;
        
        [MTSettings sharedSettings].filterKeyWords = MEAL_TYPES[index];
        [self hideFilterView:false];
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


#pragma mark - access overrides

- (AppStateListener *)appStateListener {
    if (!_appStateListener) {
        _appStateListener = [AppStateListener new];
    }
    
    return _appStateListener;
}

@end
