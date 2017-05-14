//
//  MTSwitchCell.h
//  Proz
//
//  Created by RostyslavStepanyak on 3/17/16.
//  Copyright © 2016 Tilf AB. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MTFilterViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *buttonWidth;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageAndTextPadding;
@property (nonatomic, weak) IBOutlet UIButton *leftImageButton;
@property (nonatomic, weak) IBOutlet UILabel *captionLabel;
@property (nonatomic, weak) IBOutlet UIImageView *markImageView;
@end
