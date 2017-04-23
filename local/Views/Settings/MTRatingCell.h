//
//  MTSwitchCell.h
//  Proz
//
//  Created by RostyslavStepanyak on 3/17/16.
//  Copyright © 2016 Tilf AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"

@protocol MTRatingCellProtocol <NSObject>
- (void)ratingChanged:(float)rating;
@end

@interface MTRatingCell : UITableViewCell
@property (nonatomic, weak) id<MTRatingCellProtocol>delegate;
@end
