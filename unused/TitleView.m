//
//  TitleView.m
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/28/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "TitleView.h"
#import "Local-Swift.h"

#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)

typedef NS_ENUM(NSInteger, DropDownState) {
    DropDownStateHidden = 0,
    DropDownStateRevealed = 1,
};

@interface TitleView()
@property (nonatomic, weak) IBOutlet UIButton *coverButton;
@property (nonatomic, weak) IBOutlet UILabel *mainLabel;
@property (nonatomic, weak) IBOutlet UILabel *dropDownLabel;
@property (nonatomic) DropDownState state;
@end

@implementation TitleView

- (IBAction)menuCLicked:(id)sender {
    [self.delegate titleViewClicked:self.state == DropDownStateHidden];
    
    if (self.state == DropDownStateHidden) {
        [self reveal];
    }
    
    if (self.state == DropDownStateRevealed) {
        [self collapse];
    }
}

- (void)reveal {
    self.coverButton.userInteractionEnabled = false;
    [UIView animateWithDuration:0.5 animations:^{
        self.dropDownLabel.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180));
    } completion:^(BOOL finished) {
        self.coverButton.userInteractionEnabled = true;
        self.state = DropDownStateRevealed;
    }];
}

- (void)collapse {
    self.coverButton.userInteractionEnabled = false;
    [UIView animateWithDuration:0.5 animations:^{
        self.dropDownLabel.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(360));
    } completion:^(BOOL finished) {
        self.coverButton.userInteractionEnabled = true;
        self.state = DropDownStateHidden;
    }];
}

@end
