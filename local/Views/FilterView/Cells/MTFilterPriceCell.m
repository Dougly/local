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

@property (nonatomic, strong) IBOutletCollection(UIButton)NSArray *buttons;
@property (nonatomic, strong) UIColor *activeColor;
@end

@implementation MTFilterPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}

- (void)setup {
    self.activeColor = UIColorFromHex(0xff0000);
    
    MTPriceLevel priceLevel = [[MTSettings sharedSettings] getPricingLevel];
    
    switch (priceLevel) {
        case MTPriceLevelInexpensive:
            [self.oneDollarButton setTitleColor:self.activeColor forState:UIControlStateNormal];
            break;
        case MTPriceLevelModerate:
            [self.twoDollarButton setTitleColor:self.activeColor forState:UIControlStateNormal];
            break;
        case MTPriceLevelExpensive:
            [self.threeDollarButton setTitleColor:self.activeColor forState:UIControlStateNormal];
            break;
        case MTPriceLevelVeryExpensive:
            [self.fourDollarButton setTitleColor:self.activeColor forState:UIControlStateNormal];
            break;
        case MTPriceLevelAll:
            [self.allButton setTitleColor:self.activeColor forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

#pragma mark - button click handlers

- (IBAction)oneDollarButtonClicked:(id)sender {
    [[MTSettings sharedSettings] setPricingLevel:MTPriceLevelInexpensive];
    [self resetAllButtonsTextColor];
    [self.oneDollarButton setTitleColor:self.activeColor forState:UIControlStateNormal];
}

- (IBAction)twoDollarButtonClicked:(id)sender {
    [[MTSettings sharedSettings] setPricingLevel:MTPriceLevelModerate];
    [self resetAllButtonsTextColor];
    [self.twoDollarButton setTitleColor:self.activeColor forState:UIControlStateNormal];
}

- (IBAction)threeDollarButtonClicked:(id)sender {
    [[MTSettings sharedSettings] setPricingLevel:MTPriceLevelExpensive];
    [self resetAllButtonsTextColor];
    [self.threeDollarButton setTitleColor:self.activeColor forState:UIControlStateNormal];
}

- (IBAction)fourDollarButtonClicked:(id)sender {
    [[MTSettings sharedSettings] setPricingLevel:MTPriceLevelVeryExpensive];
    [self resetAllButtonsTextColor];
    [self.fourDollarButton setTitleColor:self.activeColor forState:UIControlStateNormal];
}

- (IBAction)allButtonClicked:(id)sender {
    [[MTSettings sharedSettings] setPricingLevel:MTPriceLevelAll];
    [self resetAllButtonsTextColor];
    [self.allButton setTitleColor:self.activeColor forState:UIControlStateNormal];
}

#pragma mark - buttons text color

- (void)resetAllButtonsTextColor {
    for (UIButton *button in self.buttons) {
        [button setTitleColor:kLocalColor forState:UIControlStateNormal];
    }
}

@end
