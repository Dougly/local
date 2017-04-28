//
//  TitleView.h
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/28/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MTPlace;

@interface MapPopupView : UIView
@property (nonatomic, strong) MTPlace *place;
@property (nonatomic) CGRect pinViewFrame;
@end
