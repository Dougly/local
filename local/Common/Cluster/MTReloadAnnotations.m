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

@implementation MTReloadAnnotations

+(void)reloadAnnotations:(BOOL)isViewLoaded :(MKMapView *)mapView :(QTree *)qTree {
    
    if( isViewLoaded ) {
        return;
    }
    
    const MKCoordinateRegion mapRegion = mapView.region;
    BOOL useClustering = YES;
    const CLLocationDegrees minNonClusteredSpan = useClustering ? MIN(mapRegion.span.latitudeDelta, mapRegion.span.longitudeDelta) / 5
    : 0;
    NSArray* objects = [qTree getObjectsInRegion:mapRegion minNonClusteredSpan:minNonClusteredSpan];
    
    NSMutableArray* annotationsToRemove = [mapView.annotations mutableCopy];
    [annotationsToRemove removeObject:mapView.userLocation];
    [annotationsToRemove removeObjectsInArray:objects];
    [mapView removeAnnotations:annotationsToRemove];
    
    NSMutableArray* annotationsToAdd = [objects mutableCopy];
    [annotationsToAdd removeObjectsInArray:mapView.annotations];
    
    [mapView addAnnotations:annotationsToAdd];
}

@end
