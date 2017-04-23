//
//  MTSwitchCell.m
//  Proz
//
//  Created by RostyslavStepanyak on 3/17/16.
//  Copyright © 2016 Tilf AB. All rights reserved.
//

#import "MTDistanceCell.h"
#import "MTSettings.h"

@interface MTDistanceCell()<MTDistanceValueProtocol>
@property (nonatomic, weak) IBOutlet ASValueTrackingSlider *slider;
@property (nonatomic, weak) IBOutlet UILabel *letfLabel;
@end

@implementation MTDistanceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSlider];
}

- (IBAction)valueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    
    [self updateDistanceLabel:slider.value];
    [self distanceChanged:slider.value];
}
- (void)distanceChanged:(float)distance{
    [self.delegate distanceChanged:distance];
}

- (void)setupSlider {
    self.slider.maximumValue = 5;
    self.slider.minimumValue = 1;
    [self.slider setMaxFractionDigitsDisplayed:0];
    self.slider.popUpViewColor = kTotsAmourBrandColorHEX;
    self.slider.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22];
    self.slider.textColor = [UIColor whiteColor];
    self.slider.popUpViewWidthPaddingFactor = 1.7;
    self.slider.popUpViewCornerRadius = 6;
    self.slider.value = [[MTSettings sharedSettings] getDistance];
    [self updateDistanceLabel:[[MTSettings sharedSettings] getDistance]];
}

- (void)updateDistanceLabel:(float)distance {
    self.letfLabel.text = [NSString stringWithFormat:@"%ld km", (NSUInteger)distance];
}

@end
