//
//  MTSwitchCell.m
//  Proz
//
//  Created by RostyslavStepanyak on 3/17/16.
//  Copyright © 2016 Tilf AB. All rights reserved.
//

#import "MTLocationViewTextfieldCell.h"
#import "Local-Bridging-Header.h"


@interface MTLocationViewTextfieldCell()<UITextFieldDelegate>
//@property (weak, nonatomic) IBOutlet AutoCompleteTextField *autoCompleteTextField;
@end

@implementation MTLocationViewTextfieldCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}



@end
