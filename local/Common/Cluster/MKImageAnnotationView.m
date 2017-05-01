//
//  MKImageAnnotationView.m
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/23/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MKImageAnnotationView.h"
#import "MapPopupView.h"
#import "MTPlace.h"

@implementation MKImageAnnotationView
- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    [self updateWithAnnotation:annotation];
    return self;
}

- (void)updateWithAnnotation:(id<MKAnnotation>)annotation {
    self.canShowCallout = NO;
    
    UIImage *pinImage = [UIImage imageNamed:@"ic_pin"];
    self.image = pinImage;
    self.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView != nil) {
        [self.superview bringSubviewToFront:self];
    }

    return hitView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    if(!isInside)
    {
        for (UIView *view in self.subviews)
        {
            isInside = CGRectContainsPoint(view.frame, point);
            if (isInside) {
                break;
            }
        }
    }
    return isInside;
}

@end
