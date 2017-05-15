//
//  BorderedTextView.m
//  Local
//
//  Created by Rostyslav Stepanyak on 5/15/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "BorderedTextView.h"

@interface BorderedTextView()
@property (nonatomic, strong) CALayer *bottomBorder;
@end

@implementation BorderedTextView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self addBorder];
}

- (void)addBorder {
    if (self.bottomBorder) {
        [self.bottomBorder removeFromSuperlayer];
    }
    
    self.bottomBorder = [CALayer layer];
    self.bottomBorder.backgroundColor = UIColorFromHex(0xf7f7f7).CGColor;
    self.bottomBorder.frame = CGRectMake(0, self.bounds.size.height - 1.5, CGRectGetWidth(self.frame), 1.5f);
    [self.layer addSublayer:self.bottomBorder];
}

@end
