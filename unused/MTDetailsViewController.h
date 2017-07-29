//
//  MTSignupViewController.h
//  Automatize
//
//  Created by Rostyslav.Stepanyak on 4/14/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MTPlace;
@class MTPlaceDetails;

@interface MTDetailsViewController : UIViewController
@property (nonatomic) NSUInteger pageIndex;
@property (nonatomic, strong) MTPlace *place;
@property (nonatomic, strong, readonly) MTPlaceDetails *placeDetails;
@end
