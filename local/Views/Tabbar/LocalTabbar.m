//
//  LocalTabbar.m
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/27/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "LocalTabbar.h"

#define INDICATOR_VIEW_HEIGHT                       6
#define MARGIN_PERCENTAGE                           15
#define GAP_BETWEEN_LABELS_PERCENTAGE               8

@interface LocalTabbar()
@property (nonatomic, strong) UIView *indicatorView;
@end

@implementation LocalTabbar

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    [self setup];
}

- (void)setup {
    
}

- (UILabel *)labelForIndex:(NSUInteger) index {
    NSUInteger gap = GAP_BETWEEN_LABELS_PERCENTAGE * [UIScreen mainScreen].bounds.size.width;
    
    NSUInteger width = 0;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, INDICATOR_VIEW_HEIGHT, width, self.bounds.size.height - INDICATOR_VIEW_HEIGHT)];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:21];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = UIColorFromHex(0x333132);
    label.text = self.titles[index];
    return label;
}

@end
