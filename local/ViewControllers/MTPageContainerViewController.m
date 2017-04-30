//
//  MTPageContainerViewController.m
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/30/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MTPageContainerViewController.h"
#import "MTDataModel.h"
#import "MTDetailsViewController.h"
#import "MTPlace.h"

@interface MTPageContainerViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (nonatomic, strong) NSArray *places;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@end

@implementation MTPageContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self getPlaces];
    [self setup];
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
    
    MTDetailsViewController *startViewController = [self viewControllerAtIndex:0];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    [self.pageViewController setViewControllers:@[startViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((MTDetailsViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((MTDetailsViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.places count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (MTDetailsViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.places count] == 0) || (index >= [self.places count])) {
        return nil;
    }
    
    MTDetailsViewController *detailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTDetailsViewController"];
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
        MTDetailsViewController *currentController = (MTDetailsViewController *)self.pageViewController.viewControllers.firstObject;
        
        self.title = currentController.place.name;
    }
}

@end