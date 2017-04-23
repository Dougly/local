//
//  MKImageAnnotationView.h
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/23/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKImageAnnotationView : MKAnnotationView
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) UIImageView *imageView;

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;
@end
