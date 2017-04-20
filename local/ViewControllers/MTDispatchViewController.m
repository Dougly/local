//
//  MTHomeViewController.m
//  joueclub
//
//  Created by Ross on 10/18/15.
//  Copyright © 2015 Tilf AB. All rights reserved.
//

#import "MTDispatchViewController.h"

@interface MTDispatchViewController()

@end

@implementation MTDispatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

/*- (void)hideEmptySeparators {
    self.tableView.tableFooterView = [UIView new];
}*/

#pragma mark - table view data source
/*
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MTDispatchCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"MTDispatchCell"
                                     forIndexPath:indexPath];
    
    cell.titleLabel.text = @"Loading facility name";
    cell.contentLabel.text = self.delivery.origin.name;
    
        return cell;
}*/

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
}
*/
#pragma mark - table view delegate

/*
- (void)showTableAnimated {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView transitionWithView:self.tableView
                          duration:0.7f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.tableView.alpha = 1.0;
                            self.statusLabel.alpha = 1.0;
                            self.segment.alpha = 1.0;
                        } completion:nil];
    });
}
*/

/*
- (void)getDeliveryDetails {
     [[MTProgressHUD sharedHUD] showOnView:self.view
     percentage:false];
     MTGetDeliveryDetailsRequest *getDeliveryRequest = [[MTGetDeliveryDetailsRequest alloc] init];
    
    __weak typeof (self) weakSelf = self;
     getDeliveryRequest.completionBlock = ^(SDRequest *request, SDResult *response)
     {
     [[MTProgressHUD sharedHUD] dismiss];
     
         if ([response isSuccess]) {
             weakSelf.delivery = [[MTDataModel sharedDatabaseStorage] getDeliveryDetails];
             weakSelf.statusLabel.text = [self getLabelForStatus:[self.delivery.details.status integerValue]];
             
             [self showTableAnimated];
             [weakSelf.tableView reloadData];
         }
         else {
             weakSelf.delivery = [[MTDataModel sharedDatabaseStorage] getDeliveryDetails];
             if (weakSelf.delivery) {
                 [weakSelf showTableAnimated];
                 [weakSelf.tableView reloadData];
             }
             if (response.code != MT_HTTP_EXPIRED) {
                 NSString *message = (response.message) ? response.message : sServerNotAccessible;
                 [MTAlertBuilder showAlertIn:self
                                     message:message
                                    delegate:nil];
             }
             else {
                 [MTAlertBuilder showLoginExpiredAlert:self];
             }
         }
     };
     
     [getDeliveryRequest run];
}*/


@end
