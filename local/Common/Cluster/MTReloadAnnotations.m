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
#import "ClusterAnnotationView.h"
#import "MKImageAnnotationView.h"
#import "MTPlace.h"
@implementation MTReloadAnnotations


// TODO: Replace this library with swift map clustering library
+ (void)reloadAnnotations:(BOOL)isViewLoaded :(MKMapView *)mapView :(QTree *)qTree :(MapPopupView*)currentPopupView {
    
    if( !isViewLoaded ) {
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

+ (MKAnnotationView*)getAnnotationView:(MKMapView*)mapView :(id<MKAnnotation>)annotation {
    
    if( [annotation isKindOfClass:[QCluster class]] ) {
        ClusterAnnotationView* annotationView = (ClusterAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:[ClusterAnnotationView reuseId]];
        if (!annotationView ) {
            annotationView = [[ClusterAnnotationView alloc] initWithCluster:(QCluster*)annotation];
        }
        annotationView.cluster = (QCluster*)annotation;
        return annotationView;
    }
    else if ([annotation isKindOfClass:[MTPlace class]]){
        static NSString *defaultPinID = @"com.local.food";
        
        MKImageAnnotationView *pinView = [[MKImageAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        return pinView;
    }
    else {
        return nil;
    }
}



@end
