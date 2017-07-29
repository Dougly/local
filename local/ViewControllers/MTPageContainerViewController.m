//
//  MTPageContainerViewController.m
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/30/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MTPageContainerViewController.h"
#import "MTDataModel.h"
#import "Local-Swift.h"
#import "MTPlace.h"
#import "MTPlaceDetails.h"
#import "MTPageContainerViewController.h"
#import "FilterListener.h"
#import "CustomButtonItem.h"

#define MAX_TITLE_SYMBOLS                 23

@interface MTPageContainerViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (nonatomic, strong) NSArray *places;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (nonatomic, strong) FilterListener *filterListener;
@end

@implementation MTPageContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    
    [self setupBackButton];
    [self setupShareButton];
    
    [self setupKeyWordsListener];
    [self getPlaces];
    [self setup];
}

- (void)setupBackButton {
    UIBarButtonItem *backButton = [[CustomButtonItem alloc] initAsBackButtonWithText:@"  BACK"
                                                                              target:self
                                                                            selector:@selector(back)];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)setupShareButton {
    UIBarButtonItem *shareButton = [[CustomButtonItem alloc] initAsShareButtonWithText:@"SHARE  "
                                                                              target:self
                                                                            selector:@selector(share)];
    self.navigationItem.rightBarButtonItem = shareButton;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)share {
    DetailVC *viewController = [self.pageViewController.viewControllers lastObject];
    MTPlaceDetails *placeDetails = viewController.placeDetails;
    
    NSArray *activityItems = [NSArray arrayWithObjects:placeDetails.name, placeDetails.website, nil];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)setupKeyWordsListener {
    __weak typeof(self)weakSelf = self;
    self.filterListener.onKeyWordUpdatedHandler = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
        weakSelf.filterListener = nil;
    };
}

- (void)getPlaces {
    NSMutableArray *placesArray = [[NSMutableArray alloc] initWithArray:[[MTDataModel sharedDatabaseStorage] getPlaces]];
    [placesArray removeObject:self.place];
    
    [placesArray insertObject:self.place atIndex:0];
    self.places = placesArray;
}

- (void)setup {
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    DetailVC *startViewController = [self viewControllerAtIndex:0];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    [self.pageViewController setViewControllers:@[startViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height + self.navigationController.navigationBar.frame.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((DetailVC*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((DetailVC*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.places count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (DetailVC *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.places count] == 0) || (index >= [self.places count])) {
        return nil;
    }
    
    DetailVC *detailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTDetailsViewController"];
    detailsViewController.place = self.places[index];
    detailsViewController.pageIndex = index;
    
    return detailsViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.places count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

#pragma mark - UIPageViewCOntroller delegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        DetailVC *currentController = (DetailVC *)self.pageViewController.viewControllers.firstObject;
        
        NSString *title = currentController.place.name;
        
        if (title.length > MAX_TITLE_SYMBOLS) {
            title = [NSString stringWithFormat:@"%@...", [title substringToIndex:MAX_TITLE_SYMBOLS]];
        }
        self.title = @"";
    }
}

#pragma mark - access overrider

- (FilterListener *)filterListener {
    if (!_filterListener) {
        _filterListener = [FilterListener new];
    }
    
    return _filterListener;
}

@end
