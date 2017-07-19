//
//  UIViewController+Helpers.m
//  Steven Koposov 
//
//  Created by Steven Koposov on 05/6/16.
//  Copyright (c) 2016 Steven Koposov . All rights reserved.
//

#import "UINavigationBar+MTTransparent.h"
#import "UIViewController+Helpers.h"

static CGFloat const kINSSearchBarInset = 11.0;
static CGFloat const kINSSearchBarImageSize = 22.0;

#define MARGIN_BETWEEN_NAVIGATION_BAR_LABEL_AND_IMAGE 8
#define NAVIGATION_BAR_TITLE_IMAGE_WIDTH              30
#define LEFT_OR_RIGHT_NAVIGATION_ITEM_WIDTH           55

@implementation UIViewController (Helpers)

#pragma mark - Initialization

+ (instancetype)viewControllerFromStoryboardName:(NSString *)storyboardName
                                  withIdentifier:(NSString *)viewControllerIdentifier {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:viewControllerIdentifier];
}

+ (instancetype)fromStoryboardWithIdentifier:(NSString *)identifier {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:MAIN_STORYBOARD_IPHONE
                                                         bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:identifier];
}

- (UIImage *)imageForStatusBar:(CGFloat) alpha {
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, 40);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, size.width, size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, [self imageWithColor:[UIColor grayColor]].CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)setupTransparentNavigationBarWithTitle:(NSString *)titleText
                                         image:(UIImage *)image
                                         alpha:(CGFloat)alpha {
    int navItems = 0;
    if(self.navigationItem.leftBarButtonItem != nil)
        navItems++;
    if(self.navigationItem.rightBarButtonItem != nil)
        navItems++;
    
    int margin = 0;
    
    if(navItems == 1)
        margin = 20;
    
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width
                                                              - navItems * LEFT_OR_RIGHT_NAVIGATION_ITEM_WIDTH,
                                                              NAVIGATION_BAR_TITLE_IMAGE_WIDTH)];
    UIFont *font = [UIFont fontWithName:@"AvenirNext-Medium" size:25.0f];
    
    //Get the width of the title label
    CGRect labelRect = [titleText
                        boundingRectWithSize:CGSizeMake(99999, 30)
                        options:NSStringDrawingUsesLineFragmentOrigin
                        attributes:@{
                                     NSFontAttributeName : font
                                     }
                        context:nil];

    //Get the width of the image displayed on the navigation bar
    int imageWith = 0;
    if(image)
        imageWith = NAVIGATION_BAR_TITLE_IMAGE_WIDTH + MARGIN_BETWEEN_NAVIGATION_BAR_LABEL_AND_IMAGE;
    
    UILabel *title = [[UILabel alloc] initWithFrame: CGRectMake(((myView.frame.size.width)
                                                                 - (labelRect.size.width+imageWith + margin))
                                                                / 2, 0, labelRect.size.width, 30)];
    
    title.textAlignment = NSTextAlignmentLeft;
    title.text = titleText;
    [title setTextColor:[UIColor whiteColor]];
    [title setFont:font];
    
    [title setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *myImageView = [[UIImageView alloc] initWithImage:image];
    
    myImageView.frame = CGRectMake(title.frame.origin.x + title.frame.size.width
                                   + MARGIN_BETWEEN_NAVIGATION_BAR_LABEL_AND_IMAGE,
                                   - 4,
                                   NAVIGATION_BAR_TITLE_IMAGE_WIDTH, NAVIGATION_BAR_TITLE_IMAGE_WIDTH);
    
    [myView addSubview:title];
    [myView setBackgroundColor:[UIColor clearColor]];
    [myView addSubview:myImageView];
    self.navigationItem.titleView = myView;
    
    
    [self.navigationController.navigationBar setBackgroundImage:[self imageForStatusBar:alpha]
                                                  forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)setupBackButton {
    UIButton *back = [self createBackButton];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [self createBackButtonStyle];
}

- (UIButton *)createBackButton {
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(-20, 20, 44, 44)];
    //    [backButton setBackgroundColor:[UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.370]];
    backButton.tintColor = kColorGreenControl;
    UIImage *backImage   = [UIImage imageNamed:@"arrow-back-green"];
    [backButton setImage:backImage  forState:UIControlStateNormal];
    UIEdgeInsets dateImageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [backButton setImageEdgeInsets:dateImageEdgeInsets];
    
    [backButton addTarget:self
                   action:@selector(popBack)
         forControlEvents:UIControlEventTouchUpInside];
    
    return backButton;
}

- (void)createBackButtonStyle {
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UINavigationBar class]]]
     setBackgroundVerticalPositionAdjustment:-3 forBarMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UINavigationBar class]]]
     setBackButtonBackgroundVerticalPositionAdjustment:-3 forBarMetrics:UIBarMetricsDefault];

    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIToolbar class]]]
     setBackgroundVerticalPositionAdjustment:3 forBarMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIToolbar class]]]
     setBackButtonBackgroundVerticalPositionAdjustment:3 forBarMetrics:UIBarMetricsDefault];
}

- (void)setupCloseButton {
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"white-close-btn"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(closeCurrentScreen:)];
    closeButton.imageInsets = UIEdgeInsetsMake(12, -10, 10, 30);
    self.navigationItem.leftBarButtonItem = closeButton;
}

- (void)setupCloseLeftGreenButton {
    self.navigationItem.leftBarButtonItem =
    [self customRightButtonWithImageName:@"close-green"
                                selector:@selector(closeCurrentScreen:)];
}

- (void)setupCloseButtonWithImage:(UIImage *)image isRightPosition:(BOOL)isRight {
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:image
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(closeCurrentScreen:)];
    if (isRight) {
        self.navigationItem.rightBarButtonItem = closeButton;
    } else
        self.navigationItem.leftBarButtonItem = closeButton;
}

- (void)setupCloseRightButton {
    self.navigationItem.rightBarButtonItem =
    [self customRightButtonWithImageName:@"close-green"
                                selector:@selector(closeCurrentScreen:)];
}

- (void)setupSearchButtonWithSelector:(SEL)method {
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]
                                        initWithImage:[UIImage imageNamed:@"ios-search-strong"]
                                        style:UIBarButtonItemStylePlain
                                        target:self
                                        action:method];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void)popBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupStyleNavigationBar {
    UIColor *navColor = kColorTextGray;
    [self.navigationController.navigationBar mt_setBackgroundColor:[UIColor clearColor]];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName:navColor,
                              NSFontAttributeName:FONT_SOURCE_SANS_PRO_REGULAR(20)}];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, 0)
                                                         forBarMetrics:UIBarMetricsDefault];
    

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}

- (void)setupStyleNavigationBarModal {
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, 0)
                                                         forBarMetrics:UIBarMetricsDefault];

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.306 green:0.549 blue:0.839 alpha:1.000];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}

- (void)setupBackButtonWithTitle:(NSString *)title {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
}

- (void)setupBackButtonWithFlip {
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 50, 30)];
    UIImage *backImage   = [UIImage imageNamed:@"flight"];
    [backButton setImage:backImage forState:UIControlStateNormal];

    UIEdgeInsets dateImageEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 0);
    [backButton setImageEdgeInsets:dateImageEdgeInsets];

    [backButton addTarget:self
                   action:@selector(flipController)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)flipController {
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.titleView = [[UIView alloc] init];
    [self.navigationController popViewControllerByFlippingFromLeft];
}

- (void)closeCurrentScreen:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)closeCurrentScreenComplition:(CallBack)completion {
    [self dismissViewControllerAnimated:YES completion:^{
        BLOCK_SAFE_RUN(completion);
    }];
}

+ (void)presentUniqueViewController:(UIViewController *)viewControllerToPresent
                           animated:(BOOL)flag
                         completion:(void (^)(void))completion {
    UIViewController *currentTopController = [UIViewController topViewController];
    UIViewController *topPresentedViewController = viewControllerToPresent;
    
    if ([topPresentedViewController isMemberOfClass:[UINavigationController class]]) {
        topPresentedViewController = ((UINavigationController *)topPresentedViewController).topViewController;
    }
    
    if ([currentTopController isMemberOfClass:[topPresentedViewController class]]) {
        [currentTopController dismissViewControllerAnimated:NO completion:^{
                UIViewController *newTopController = [UIViewController topViewController];
                [newTopController presentViewController:viewControllerToPresent animated:NO completion:completion];
        }];
    } else {
        [currentTopController presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
}


+ (instancetype)topViewController {
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (instancetype)topViewController:(UIViewController *)rootViewController {
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }

    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }

    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}

- (UIBarButtonItem *)customRightButtonWithImageName:(NSString *)name selector:(SEL)selector {
    UIButton *buttonRight =
    [[UIButton alloc]  initWithFrame:
     CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) - kINSSearchBarInset - kINSSearchBarImageSize,
                (CGRectGetHeight([UIScreen mainScreen].bounds) - kINSSearchBarImageSize) / 2,
                kINSSearchBarImageSize,
                kINSSearchBarImageSize)];
    
    buttonRight.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    UIImage *backImage   = [UIImage imageNamed:name];
    [buttonRight setImage:backImage forState:UIControlStateNormal];
    
    [buttonRight addTarget:self
                    action:selector
          forControlEvents:UIControlEventTouchUpInside];
    
  return [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
}

- (void)addControllerToView:(UIView *)view controller:(UIViewController *)content {
    [self addChildViewController:content];
    content.view.frame = view.bounds;
    [view addSubview:content.view];
    [content didMoveToParentViewController:self];
}

@end
