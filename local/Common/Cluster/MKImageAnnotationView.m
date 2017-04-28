//
//  MKImageAnnotationView.m
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/23/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MKImageAnnotationView.h"

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

@end
