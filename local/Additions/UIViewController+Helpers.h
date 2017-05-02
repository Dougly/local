//
//  UIViewController+Helpers.h
//  Steven Koposov 
//
//  Created by Steven Koposov on 05/6/16.
//  Copyright (c) 2016 Steven Koposov . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
typedef void(^CallBack)();

@interface UIViewController (Helpers)<UIViewControllerTransitioningDelegate>

#pragma mark - Initialization
+ (instancetype)viewControllerFromStoryboardName:(NSString *)storyboardName
                                  withIdentifier:(NSString *)viewControllerIdentifier;
+ (instancetype)fromStoryboardWithIdentifier:(NSString *)identifier;

- (void)setupTransparentNavigationBarWithTitle:(NSString *)title image:(UIImage *)image alpha:(CGFloat)alpha;
- (UIImage *)imageForStatusBar:(CGFloat)alpha;

- (void)popBack;
- (void)setupBackButton;
- (void)setupCloseButton;
- (void)setupCloseRightButton;
- (void)setupBackButtonWithFlip;
- (void)setupStyleNavigationBar;
- (void)setupCloseLeftGreenButton;
- (void)setupStyleNavigationBarModal;
- (void)closeCurrentScreen:(id)sender;
- (void)setupBackButtonWithTitle:(NSString *)title;
- (void)setupSearchButtonWithSelector:(SEL)method;
- (void)closeCurrentScreenComplition:(CallBack)completion;
- (void)setupCloseButtonWithImage:(UIImage *)image isRightPosition:(BOOL)isRigh;
+ (void)presentUniqueViewController:(UIViewController *)viewControllerToPresent
                           animated:(BOOL)flag
                         completion:(void (^)(void))completion;

+ (instancetype)topViewController;
+ (instancetype)topViewController:(UIViewController *)rootViewController;
- (void)addControllerToView:(UIView *)view controller:(UIViewController *)content;

@end
