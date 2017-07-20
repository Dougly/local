//
//  LoginViewController.m
//  InstagramUnsignedAuthentication
//
//  Created by user on 11/13/14.
//  Copyright (c) 2014 Neuron. All rights reserved.
//

#import "MTInstagramViewController.h"
#import "MTAppManager.h"
#import "MTProgressHUD.h"

#define INSTAGRAM_AUTHURL                               @"https://api.instagram.com/oauth/authorize/"
#define INSTAGRAM_APIURl                                @"https://api.instagram.com/v1/users/"

#define INSTAGRAM_CLIENT_ID                             @"bc167b730df44ff385ee696688c9f9f1"
#define INSTAGRAM_CLIENTSERCRET                         @"e9ec2c09d53948ab934a7562095ea540"

#define INSTAGRAM_REDIRECT_URI                          @"http://www.osvnyc.com"
#define INSTAGRAM_ACCESS_TOKEN                          @"access_token"
#define INSTAGRAM_SCOPE                                 @"likes+comments+relationships"


@implementation MTInstagramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
    [self prefersStatusBarHidden];
    
    NSString* authURL = nil;
    
    if ([self.typeOfAuthentication isEqualToString:@"UNSIGNED"])
    {
         authURL = [NSString stringWithFormat: @"%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True",
         INSTAGRAM_AUTHURL,
         INSTAGRAM_CLIENT_ID,
         INSTAGRAM_REDIRECT_URI,
         INSTAGRAM_SCOPE];

    }
    else
    {
         authURL = [NSString stringWithFormat: @"%@?client_id=%@&redirect_uri=%@&response_type=code&scope=%@&DEBUG=True",
                             INSTAGRAM_AUTHURL,
                             INSTAGRAM_CLIENT_ID,
                             INSTAGRAM_REDIRECT_URI,
                             INSTAGRAM_SCOPE];
    }
    
    [loginWebView loadRequest:[NSURLRequest requestWithURL: [NSURL URLWithString: authURL]]];
    [loginWebView setDelegate:self];
}


#pragma mark -
#pragma mark delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    return [self checkRequestForCallbackURL: request];
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    [[MTProgressHUD sharedHUD] showOnView:self.view percentage:false];
    [loginIndicator startAnimating];
    [loginWebView.layer removeAllAnimations];
    loginWebView.userInteractionEnabled = NO;
    [UIView animateWithDuration: 0.1 animations:^{
      //  loginWebView.alpha = 0.2;
    }];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [[MTProgressHUD sharedHUD] dismiss];
    [loginIndicator stopAnimating];
    [loginWebView.layer removeAllAnimations];
    loginWebView.userInteractionEnabled = YES;
    [UIView animateWithDuration: 0.1 animations:^{
        //loginWebView.alpha = 1.0;
    }];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self webViewDidFinishLoad: webView];
}

#pragma mark -
#pragma mark auth logic


- (BOOL)checkRequestForCallbackURL:(NSURLRequest*) request
{
    NSString* urlString = [[request URL] absoluteString];
    
    if ([self.typeOfAuthentication isEqualToString:@"UNSIGNED"])
    {
        // check, if auth was succesfull (check for redirect URL)
          if([urlString hasPrefix: INSTAGRAM_REDIRECT_URI])
         {
             // extract and handle access token
             NSRange range = [urlString rangeOfString: @"#access_token="];
             [self handleAuth: [urlString substringFromIndex: range.location+range.length]];
             return NO;
         }
    }
    else
    {
        if([urlString hasPrefix: INSTAGRAM_REDIRECT_URI])
        {
            // extract and handle access token
            NSRange range = [urlString rangeOfString: @"code="];
            [self makePostRequest:[urlString substringFromIndex: range.location+range.length]];
            return NO;
        }
    }
    
    return YES;
}

-(void)makePostRequest:(NSString *)code {
    NSString *post = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",INSTAGRAM_CLIENT_ID,INSTAGRAM_CLIENTSERCRET,INSTAGRAM_REDIRECT_URI,code];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *authRequest = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:@"https://api.instagram.com/oauth/access_token"]];
    [authRequest setHTTPMethod:@"POST"];
    [authRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [authRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [authRequest setHTTPBody:postData];
    
    __weak typeof(self) weakSelf = self;
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:authRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
        
        [weakSelf handleAuth:[dict valueForKey:@"access_token"]];
    }] resume];
}

- (void)handleAuth:(NSString*)authToken {
    [self.delegate onAuthenticated:authToken];
}

@end
