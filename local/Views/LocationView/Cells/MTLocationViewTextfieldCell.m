//
//  MTSwitchCell.m
//  Proz
//
//  Created by RostyslavStepanyak on 3/17/16.
//  Copyright © 2016 Tilf AB. All rights reserved.
//

#import "MTLocationViewTextfieldCell.h"
#import "Local-swift.h"


@interface MTLocationViewTextfieldCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet AutoCompleteTextField *autoCompleteTextField;
@end

@implementation MTLocationViewTextfieldCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setContainerView:(UIView *)containerView {
    _containerView = containerView;
    
    self.autoCompleteTextField.containerview = self.containerView;
    self.autoCompleteTextField.onSelect = ^(PredictionPlace * _Nonnull place) {
        [self.autoCompleteTextField resignFirstResponder];
        [self.delegate placeSelected:place.placeId];
    };
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}



@end
