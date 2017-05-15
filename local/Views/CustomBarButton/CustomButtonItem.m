//
//  CustomButtonItem.m
//  Local
//
//  Created by Rostyslav Stepanyak on 5/15/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "CustomButtonItem.h"

@implementation CustomButtonItem

- (id)initAsBackButtonWithText:(NSString *)text target:(id)target selector:(SEL)selector {
    self = [super init];
    
    NSString *barButtonBackStr = text;
    
    NSMutableAttributedString *attributedBarButtonBackStr = [[NSMutableAttributedString alloc] initWithString:barButtonBackStr];
    [attributedBarButtonBackStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"FontAwesome" size:13.0f] range:NSMakeRange(0, 1)];
    [attributedBarButtonBackStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"FontAwesome" size:13.0f] range:NSMakeRange(1, barButtonBackStr.length-1)];
    
    [attributedBarButtonBackStr addAttribute:NSForegroundColorAttributeName value:kLocalColor range:NSMakeRange(0, barButtonBackStr.length)];
    
    UIButton *button = [UIButton new];
    [button setAttributedTitle:attributedBarButtonBackStr forState:UIControlStateNormal];
    [button sizeToFit];
    
    [self setCustomView:button];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

- (id)initAsShareButtonWithText:(NSString *)text target:(id)target selector:(SEL)selector {
    self = [super init];
    
    NSString *barButtonBackStr = text;
    
    NSMutableAttributedString *attributedBarButtonBackStr = [[NSMutableAttributedString alloc] initWithString:barButtonBackStr];
    [attributedBarButtonBackStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"FontAwesome" size:13.0f] range:NSMakeRange(0, barButtonBackStr.length - 1)];
    [attributedBarButtonBackStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"FontAwesome" size:12.0f] range:NSMakeRange(barButtonBackStr.length - 1, 1)];
    
    [attributedBarButtonBackStr addAttribute:NSForegroundColorAttributeName value:kLocalColor range:NSMakeRange(0, barButtonBackStr.length)];
    
    UIButton *button = [UIButton new];
    [button setAttributedTitle:attributedBarButtonBackStr forState:UIControlStateNormal];
    [button sizeToFit];
    
    [self setCustomView:button];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

@end
