//
//  MTAlertBuilder.h
//  Automatize
//
//  Created by Rostyslav.Stepanyak on 3/19/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AlertDelegate <NSObject>
- (void)alertOkButtonClicked;
- (void)alertReloginButtonClicked;
@end

@interface MTAlertBuilder : NSObject
+ (void)showAlertIn:(UIViewController *)controller
            message:(NSString *)message
           delegate:(id<AlertDelegate>)delegate;

+ (void)showLoginExpiredAlert:(UIViewController<AlertDelegate> *)controller;
@end
