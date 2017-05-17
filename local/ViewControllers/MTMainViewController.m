//
//  MTMainViewController.m
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/27/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MTMainViewController.h"
#import "CMTabbarView.h"
#import "MTSettings.h"
#import "AppStateListener.h"
#import "MTDataModel.h"
#import "FilterViewListener.h"
#import "MTFilterViewController.h"

#define FILTER_VIEW_HEIGHT              250

@interface MTMainViewController ()<CMTabbarViewDelegate, CMTabbarViewDatasouce>
@property (nonatomic, weak) IBOutlet UIView *placeHolderForTabbarView;
@property (nonatomic, weak) IBOutlet CMTabbarView *tabbarView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *leftMarginForBottomMenuConstraint;
@property (nonatomic) BOOL filterMenuVisisble;

@property (nonatomic, strong) AppStateListener *appStateListener;
@property (nonatomic, strong) FilterViewListener *filterViewListener;
@property (nonatomic) NSUInteger selectedNavigationIndex;

@property (nonatomic, weak) IBOutlet UIView *filterContainterView;
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
    
    self.filterViewListener.onFilterViewCloseHandler = ^(BOOL shoulRevertToPreviousIndex){
        [weakSelf hideFilterView:shoulRevertToPreviousIndex];
    };
}

- (void)_hideFilterView:(NSNotification *)notification {
    if (notification.userInfo[kRevertFilterViewToPreviousIndex]) {
        [self hideFilterView:true];
    }
    else {
        [self hideFilterView:false];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.filterContainterView.alpha = 0.0;
    [self adjustMenuConstraint];
}

- (void)setTabBarIndex {
    NSString *keyWords = [MTSettings sharedSettings].filterKeyWords;
    
    /*Default point to filter icon*/
    NSUInteger index = 3;
    if ([MEAL_TYPES containsObject:keyWords]) {
        index = [MEAL_TYPES indexOfObject:keyWords];
        self.selectedNavigationIndex = index;
    }
    self.tabbarView.defaultSelectedIndex = index;
    [self.tabbarView setTabIndex:index animated:false];
}

- (void)addTabbar {
    self.tabbarView.delegate = self;
    self.tabbarView.dataSource = self;
    [self addBorder];
}

- (void)addBorder {
    CALayer *upperBorder = [CALayer layer];
    upperBorder.backgroundColor = UIColorFromHex(0x939598).CGColor;
    upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0.5f);
    [self.placeHolderForTabbarView.layer addSublayer:upperBorder];
}

- (NSArray<NSString *> *)tabbarTitlesForTabbarView:(CMTabbarView *)tabbarView {
    return MEAL_TYPES;
}

#pragma mark - FilterView

- (void)showFilterView {
    [UIView animateWithDuration:0.4 animations:^{
        /* This looks ugly. navigation for filterview should be refactored*/
        MTFilterViewController *filterViewController = ((UINavigationController *)self.childViewControllers.lastObject).viewControllers.firstObject;
        [filterViewController.navigationController popViewControllerAnimated:NO];
        [filterViewController prepareForShow];
        self.filterContainterView.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.filterMenuVisisble = false;
        self.filterMenuVisisble = YES;
    }];
}

- (void)hideFilterView:(BOOL)shouldRevertToPreviousIndex {
    
    /* This looks ugly. navigation for filterview should be refactored*/
    /*MTFilterViewController *filterViewController = ((UINavigationController *)self.childViewControllers.lastObject).viewControllers.firstObject;
    [filterViewController disableSwipe];*/

    
    [UIView animateWithDuration:0.2 animations:^{
        self.filterContainterView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.filterMenuVisisble = false;
        
        //If the filterview was dismissed and nothing was selected in filter view before - then revert to previous index
        if (shouldRevertToPreviousIndex && [self nothingSelected]) {
            [self.tabbarView setTabIndex:self.selectedNavigationIndex animated:YES];
        }
    }];
}

- (BOOL)nothingSelected {
    NSUInteger index = -1;
    
    for (NSUInteger subfiltersIndex = MTFilterViewCellHelthy; subfiltersIndex < MTFilterViewCellPrice; subfiltersIndex++) {
        if (subfiltersIndex <= MTFilterViewCellHardStuff) {
            if ([FILTERS_KEY_WORDS[subfiltersIndex] isEqualToString:[MTSettings sharedSettings].filterKeyWords]) {
                index = subfiltersIndex;
                break;
            }
        }
        else {
            NSArray *subfilters = FILTERS_KEY_WORDS[subfiltersIndex];
            if ([subfilters containsObject:[MTSettings sharedSettings].filterKeyWords]) {
                index = subfiltersIndex;
                break;
            }
        }
    }
    
    return (index == -1) ? true : false;
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
        self.leftMarginForBottomMenuConstraint.constant = 32;
    }
    
    if (IS_IPHONE_6_PLUS) {
        self.leftMarginForBottomMenuConstraint.constant = 62;
    }
}


#pragma mark - access overrides

- (AppStateListener *)appStateListener {
    if (!_appStateListener) {
        _appStateListener = [AppStateListener new];
    }
    
    return _appStateListener;
}

- (FilterViewListener *)filterViewListener {
    if (!_filterViewListener) {
        _filterViewListener = [FilterViewListener new];
    }
    
    return _filterViewListener;
}

@end
