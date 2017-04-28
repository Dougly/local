//
//  MKImageAnnotationView.h
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/23/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKImageAnnotationView : MKAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;
- (void)updateWithAnnotation:(id<MKAnnotation>)annotation;
@end
