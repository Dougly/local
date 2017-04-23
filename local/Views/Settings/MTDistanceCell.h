//
//  MTSwitchCell.h
//  Proz
//
//  Created by RostyslavStepanyak on 3/17/16.
//  Copyright © 2016 Tilf AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASValueTrackingSlider.h"

@protocol MTDistanceValueProtocol <NSObject>
- (void)distanceChanged:(float)distance;
@end

@interface MTDistanceCell : UITableViewCell
@property (nonatomic, weak) id<MTDistanceValueProtocol>delegate;
@end
