//
//  PZSwitchCell.h
//  Proz
//
//  Created by RostyslavStepanyak on 3/17/16.
//  Copyright © 2016 Tilf AB. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PZSwitchCellType) {
    PZSwitchCellShowPostsInNativeLanguagePairs = 0,
    PZSwitchCellICanQuote
};

@protocol PZSwitchCellProtocol <NSObject>
- (void)switchStateChanged:(Boolean)state forCellType:(PZSwitchCellType)cellType;
@end

@interface PZSwitchCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *captionLabel;
@property (nonatomic, weak) IBOutlet UISwitch *cellSwitch;
@property (nonatomic) PZSwitchCellType cellType;
@property (nonatomic, weak) id<PZSwitchCellProtocol>delegate;
@end
