//
//  MTReloadAnnotations.h
//  Local
//
//  Created by Douglas Galante on 8/1/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "QTree.h"
#import "MapPopupView.h"
@class MKMapView;

@interface MTReloadAnnotations : NSObject ;

+(void)reloadAnnotations:(BOOL)isViewLoaded :(MKMapView*)mapView :(QTree*)qTree :(MapPopupView*)currentPopupView;
+ (NSArray*)getTappedAnnotations:(UITouch*)touch :(MKMapView*)mapView;

@end
