//
//  MTReloadAnnotations.m
//  Local
//
//  Created by Douglas Galante on 8/1/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTReloadAnnotations.h"
#import "QTree.h"
#import "QCluster.h"
#import "MTGooglePlacesManager.h"
#import "MapPopupView.h"

@implementation MTReloadAnnotations

+ (void)reloadAnnotations:(BOOL)isViewLoaded :(MKMapView *)mapView :(QTree *)qTree :(MapPopupView*)currentPopupView {
    
    if( !isViewLoaded ) {
        NSLog(@"view isnt loaded??????");
        return;
    }
    
    qTree = [MTGooglePlacesManager sharedManager].qTree;
    
    const MKCoordinateRegion mapRegion = mapView.region;
    BOOL useClustering = true;
    
    const CLLocationDegrees minNonClusteredSpan = useClustering ? MIN(mapRegion.span.latitudeDelta, mapRegion.span.longitudeDelta) / 10
    : 0;
    NSArray* objects = [qTree getObjectsInRegion:mapRegion minNonClusteredSpan:minNonClusteredSpan];
    
    NSMutableArray* annotationsToRemove = [mapView.annotations mutableCopy];
    [annotationsToRemove removeObject:mapView.userLocation];
    [annotationsToRemove removeObjectsInArray:objects];
    
    //Prevent the popup view from being clustered if it's visible
    if (currentPopupView) {
        [annotationsToRemove removeObject:currentPopupView.place];
    }
    [mapView removeAnnotations:annotationsToRemove];
    
    NSMutableArray* annotationsToAdd = [objects mutableCopy];
    [annotationsToAdd removeObjectsInArray:mapView.annotations];
    NSLog(@"🎃🎃🎃 annotations: %@", annotationsToAdd);
    [mapView addAnnotations:annotationsToAdd];
   
}

+ (NSArray*)getTappedAnnotations:(UITouch*)touch :(MKMapView*)mapView {
    
    NSMutableArray* tappedAnnotations = [NSMutableArray array];
    for(id<MKAnnotation> annotation in mapView.annotations) {
        MKAnnotationView* view = [mapView viewForAnnotation:annotation];
        CGPoint location = [touch locationInView:view];
        if(CGRectContainsPoint(view.bounds, location)) {
            [tappedAnnotations addObject:view];
        }
    }
    return tappedAnnotations;
}

@end
