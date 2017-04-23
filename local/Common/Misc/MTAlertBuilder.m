//
//  MTAlertBuilder.m
//  Automatize
//
//  Created by Rostyslav.Stepanyak on 3/19/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MTAlertBuilder.h"

@implementation MTAlertBuilder

+ (void)showAlertIn:(UIViewController *)controller
            message:(NSString *)message
           delegate:(id<AlertDelegate>)delegate {
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@""
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* okButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    [delegate alertOkButtonClicked];
                                }];
    
    [alert addAction:okButton];
    [controller presentViewController:alert animated:YES completion:nil];
}

+ (void)showLoginExpiredAlert:(UIViewController<AlertDelegate> *)controller {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@""
                                 message:@"Your login expired. Please log in again"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   [controller alertReloginButtonClicked];
                               }];
    
    [alert addAction:okButton];
    [controller presentViewController:alert animated:YES completion:nil];
}
@end
