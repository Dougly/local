//
//  MTSwitchCell.m
//  Proz
//
//  Created by RostyslavStepanyak on 3/17/16.
//  Copyright © 2016 Tilf AB. All rights reserved.
//

#import "MTFilterPriceCell.h"
#import "MTSettings.h"

@interface MTFilterPriceCell()
@property (nonatomic, weak) IBOutlet UIButton *oneDollarButton;
@property (nonatomic, weak) IBOutlet UIButton *twoDollarButton;
@property (nonatomic, weak) IBOutlet UIButton *threeDollarButton;
@property (nonatomic, weak) IBOutlet UIButton *fourDollarButton;
@property (nonatomic, weak) IBOutlet UIButton *allButton;
@end

@implementation MTFilterPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}

- (void)setup {
    
}

#pragma mark - button click handlers

- (IBAction)oneDollarButtonClicked:(id)sender {
    
}

- (IBAction)twoDollarButtonClicked:(id)sender {
    
}

- (IBAction)threeDollarButtonClicked:(id)sender {
    
}

- (IBAction)fourDollarButtonClicked:(id)sender {
    
}

- (IBAction)allButtonClicked:(id)sender {
    
}

@end
