//
//  AddressLocationCell.h
//  TGFoursquareLocationDetail-Demo
//
//  Created by Thibault Guégan on 17/12/2013.
//  Copyright (c) 2013 Thibault Guégan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface AddressLocationCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UITextView *phoneTextView;
@property (nonatomic, weak) IBOutlet UILabel *streetNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *neighborhoodLabel;
@property (nonatomic, weak) IBOutlet UILabel *adminLevel2Label;
+ (AddressLocationCell*) addressLocationDetailCell;

@end
