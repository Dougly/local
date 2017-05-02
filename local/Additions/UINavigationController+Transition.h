//
//  UINavigationController+Transition.h
//  UINavigationController
//
//  Created by Steven Koposov on 05/6/16.
//
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Transition)

- (void)pushViewControllerByCrossDissolving:(UIViewController *)viewController;
- (void)popViewControllerByCrossDissolving;
- (void)popToViewControllerByCrossDissolving:(UIViewController *)viewController;
- (void)pushViewControllerByFlippingFromRight:(UIViewController *)destinationViewController;
- (UIViewController *)popViewControllerByFlippingFromLeft;

- (void)pushViewControllerBySlideFromBottom:(UIViewController *)destinationViewController;
- (void)popToViewControllerBySlideToBottom:(UIViewController *)destinationViewController;
- (void)popViewControllerBySlideToBottom;

- (void)presentViewControllerByCrossDissolving:(UIViewController *)viewController;
@end
