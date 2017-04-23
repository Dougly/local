//
//  PZSwitchCell.m
//  Proz
//
//  Created by RostyslavStepanyak on 3/17/16.
//  Copyright © 2016 Tilf AB. All rights reserved.
//

#import "PZSwitchCell.h"

@implementation PZSwitchCell

- (IBAction)stateChanged:(id)sender {
    [self.delegate switchStateChanged:((UISwitch*)sender).isOn forCellType:self.cellType];
}
@end
