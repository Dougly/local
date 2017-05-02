//
//  UINavigationController+Transition.m
//  UINavigationController
//
//  Created by Steven Koposov on 05/6/16.
//
//

#import "UINavigationController+Transition.h"
#import "CALayer+Animations.h"

@implementation UINavigationController (Transition)

#pragma mark - Custom Push/Pop Transitions

- (void)pushViewControllerByCrossDissolving:(UIViewController *)viewController
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.view.layer addAnimation:transition forKey:nil];

    [self pushViewController:viewController animated:NO];
}

- (void)presentViewControllerByCrossDissolving:(UIViewController *)viewController
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.view.layer addAnimation:transition forKey:nil];
    UINavigationController *navController = [[[self splitViewController ] viewControllers] lastObject];
    UIViewController *controllerToPresentFrom = IS_IPHONE ? self : [[navController childViewControllers] lastObject];
    [controllerToPresentFrom presentViewController:viewController
                                          animated:NO
                                        completion:nil];
}

- (void)popViewControllerByCrossDissolving
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.view.layer addAnimation:transition forKey:nil];
    [self popViewControllerAnimated:NO];
}

- (void)popToViewControllerByCrossDissolving:(UIViewController *)viewController
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.view.layer addAnimation:transition forKey:nil];
    [self popToViewController:viewController animated:NO];
}

- (void)pushViewControllerByFlippingFromRight:(UIViewController *)destinationViewController
{
    UIViewController *currentViewController = self.viewControllers.lastObject;

    [UIView transitionFromView:currentViewController.view
                        toView:destinationViewController.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    completion:^(BOOL finished) {
                        [self pushViewController:destinationViewController animated:NO];
                    }];
}

- (UIViewController *)popViewControllerByFlippingFromLeft
{
    UIViewController *viewControllerBeingPopped = self.viewControllers.lastObject;
    UIViewController *viewControllerBeingPresented = self.viewControllers[self.viewControllers.count - 2];

    [UIView transitionFromView:viewControllerBeingPopped.view
                        toView:viewControllerBeingPresented.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:^(BOOL finished) {
                        [self popToViewController:viewControllerBeingPresented animated:NO];
                    }];
    return viewControllerBeingPopped;
}

- (void)pushViewControllerBySlideFromBottom:(UIViewController *)destinationViewController {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    [self.view.layer addAnimation:transition forKey:nil];

    [self pushViewController:destinationViewController animated:NO];
}

- (void)popToViewControllerBySlideToBottom:(UIViewController *)destinationViewController {
    [self.view.layer addSlideToBottomAnimation];
    [self popToViewController:destinationViewController animated:NO];
}

- (void)popViewControllerBySlideToBottom {
    [self.view.layer addSlideToBottomAnimation];
    [self popViewControllerAnimated:NO];
}

@end
