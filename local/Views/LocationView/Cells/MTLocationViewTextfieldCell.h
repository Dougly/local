//
//  MTSwitchCell.h
//  Proz
//
//  Created by RostyslavStepanyak on 3/17/16.
//  Copyright © 2016 Tilf AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTLocationViewTextfieldCell : UITableViewCell<UITextViewDelegate>
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) id <MTLocationViewTextfieldCellDelegate>delegate;
@end
