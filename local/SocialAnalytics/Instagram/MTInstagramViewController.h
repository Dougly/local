//
//  LoginViewController.h
//  InstagramUnsignedAuthentication
//
//  Created by user on 11/13/14.
//  Copyright (c) 2014 Neuron. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InstagramAuthDelegate <NSObject>
- (void)onAuthenticated:(NSString *)authToken;
@end

@interface MTInstagramViewController : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView *loginWebView;
    IBOutlet UIActivityIndicatorView* loginIndicator;
}
@property(strong,nonatomic)NSString *typeOfAuthentication;
@property (nonatomic, weak) id <InstagramAuthDelegate>delegate;
@end
