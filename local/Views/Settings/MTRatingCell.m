//
//  MTSwitchCell.m
//  Proz
//
//  Created by RostyslavStepanyak on 3/17/16.
//  Copyright © 2016 Tilf AB. All rights reserved.
//

#import "MTRatingCell.h"
#import "MTSettings.h"

@interface MTRatingCell()<EDStarRatingProtocol>
@property (nonatomic, weak) IBOutlet EDStarRating *starRating;
@end

@implementation MTRatingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupRating];
}

-(void)starsSelectionChanged:(EDStarRating*)control rating:(float)rating {
    [self.delegate ratingChanged:rating];
}

- (void)setupRating {
    // Setup control using iOS7 tint Color
    _starRating.backgroundColor  = [UIColor whiteColor];
    _starRating.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _starRating.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _starRating.maxRating = 5.0;
    _starRating.delegate = self;
    //_starRating.horizontalMargin = 15.0;
    _starRating.displayMode=EDStarRatingDisplayHalf;
    [self  layoutSubviews];
    _starRating.tintColor = kTotsAmourBrandColorHEX;
    _starRating.editable=YES;
    _starRating.rating = [[MTSettings sharedSettings] getRating];
}

@end
