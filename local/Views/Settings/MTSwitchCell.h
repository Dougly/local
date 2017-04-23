//
//  MTSwitchCell.h
//  Proz
//
//  Created by RostyslavStepanyak on 3/17/16.
//  Copyright © 2016 Tilf AB. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MTSwitchCellType) {
    MTSwitchCellOnlyOpenNow = 0,
    MTSwitchCellOnlyCheap
};

@protocol MTSwitchCellProtocol <NSObject>
- (void)switchStateChanged:(Boolean)state forCellType:(MTSwitchCellType)cellType;
@end

@interface MTSwitchCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *captionLabel;
@property (nonatomic, weak) IBOutlet UISwitch *cellSwitch;
@property (nonatomic) MTSwitchCellType cellType;
@property (nonatomic, weak) id<MTSwitchCellProtocol>delegate;
@end
