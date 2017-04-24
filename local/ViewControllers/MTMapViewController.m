//
// This file is subject to the terms and conditions defined in
// file 'LICENSE.md', which is part of this source code package.
//

#import "MTMapViewController.h"
#import "QTree.h"
#import "QCluster.h"
#import "ClusterAnnotationView.h"
#import "MKImageAnnotationView.h"
#import "MTGooglePlacesManager.h"
#import "MTProgressHUD.h"
#import "MTLocationManager.h"
#import "MTPlace.h"
#import "MTAlertBuilder.h"

inline static CLLocationCoordinate2D referenceLocation()
{
  return CLLocationCoordinate2DMake(40.730610, -73.935242);
}

@interface MTMapViewController()<MKMapViewDelegate, UIGestureRecognizerDelegate>

@property(nonatomic, weak) IBOutlet MKMapView* mapView;
@property (nonatomic, strong) QTree *qTree;
@end

@implementation MTMapViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    [self getLocation];
}

- (void)getLocation {
    [[MTProgressHUD sharedHUD] showOnView:self.view
                               percentage:false];
    
    [[MTLocationManager sharedManager] getLocation:^(BOOL success, NSString *erroMessage, CLLocationCoordinate2D coordinate) {
        [[MTProgressHUD sharedHUD] dismiss];
        if (success) {
            [self getPlacesAtLocation:coordinate];
            
            [self drawCircleAroundCoordinate:coordinate];
            [self setZoomLevelWithCenter:coordinate];
            [self addGesture];
        }
        else {
            [MTAlertBuilder showAlertIn:self
                                message:erroMessage
                               delegate:nil];
        }
        
    }];
}

- (void)setZoomLevelWithCenter:(CLLocationCoordinate2D)coordinate {
    MKCoordinateRegion region;
    region.center.latitude = coordinate.latitude;
    region.center.longitude = coordinate.longitude;
    region.span.latitudeDelta = 0.4;
    region.span.longitudeDelta = 0.4;
    region = [self.mapView regionThatFits:region];
    [self.mapView setRegion:region animated:TRUE];
}

- (void)getPlacesAtLocation:(CLLocationCoordinate2D)coordinate {
    MTGooglePlacesManager *manager = [MTGooglePlacesManager sharedManager];
    
    self.qTree = nil;
    [manager query:coordinate radius:3000 completion:^(BOOL success, NSArray *places, NSError *error) {
        if (success)
            [self reloadAnnotations];
    }];
}

- (NSArray*)getTappedAnnotations:(UITouch*)touch
{
    NSMutableArray* tappedAnnotations = [NSMutableArray array];
    for(id<MKAnnotation> annotation in self.mapView.annotations) {
        MKAnnotationView* view = [self.mapView viewForAnnotation:annotation];
        CGPoint location = [touch locationInView:view];
        if(CGRectContainsPoint(view.bounds, location)) {
            [tappedAnnotations addObject:view];
        }
    }
    return tappedAnnotations;
}

- (void)reloadAnnotations {
    if( !self.isViewLoaded ) {
        return;
    }

    self.qTree = [MTGooglePlacesManager sharedManager].qTree;
    
    const MKCoordinateRegion mapRegion = self.mapView.region;
    BOOL useClustering = true;
    const CLLocationDegrees minNonClusteredSpan = useClustering ? MIN(mapRegion.span.latitudeDelta, mapRegion.span.longitudeDelta) / 5
                                                              : 0;
    NSArray* objects = [self.qTree getObjectsInRegion:mapRegion minNonClusteredSpan:minNonClusteredSpan];

    NSMutableArray* annotationsToRemove = [self.mapView.annotations mutableCopy];
    [annotationsToRemove removeObject:self.mapView.userLocation];
    [annotationsToRemove removeObjectsInArray:objects];
    [self.mapView removeAnnotations:annotationsToRemove];

    NSMutableArray* annotationsToAdd = [objects mutableCopy];
    [annotationsToAdd removeObjectsInArray:self.mapView.annotations];

    [self.mapView addAnnotations:annotationsToAdd];
}

#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView*)mapView regionDidChangeAnimated:(BOOL)animated{
    [self reloadAnnotations];
}

- (MKAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
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
        MKImageAnnotationView *pinView = (MKImageAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if (pinView == nil) {
            pinView = [[MKImageAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        }
        else {
            [pinView updateWithAnnotation:annotation];
        }
      
        return pinView;
    }
    else {
        return nil;
    }
}

- (void)mapView:(MKMapView*)mapView didSelectAnnotationView:(MKAnnotationView*)view {
    id<MKAnnotation> annotation = view.annotation;
    if([annotation isKindOfClass:[QCluster class]]) {
        QCluster* cluster = (QCluster*)annotation;
        [mapView setRegion:MKCoordinateRegionMake(cluster.coordinate, MKCoordinateSpanMake(2.5 * cluster.radius, 2.5 * cluster.radius))
              animated:YES];
    }
}

#pragma mark - Overlays

- (void)drawCircleAroundCoordinate:(CLLocationCoordinate2D)coordinate {
    // Do anything else with the coordinate as you see fit in your application
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:coordinate radius:4200];
    [self.mapView addOverlay:circle];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleRenderer *circle = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        circle.strokeColor = kTotsAmourBrandColorHEX;
        circle.lineWidth = 1.0;
        return circle;
    }
    else {
        return nil;
    }
}

#pragma mark - Map tap gesture

- (void)addGesture {
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGesture.delegate = self;
    [self.mapView addGestureRecognizer:tapGesture];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return [self getTappedAnnotations:touch].count == 0;
}

- (void)handleTap:(UITapGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        /*Get the coordinate*/
        [self.mapView removeOverlays:self.mapView.overlays];
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:[gestureRecognizer locationInView:self.mapView] toCoordinateFromView:self.mapView];
        
        [self getPlacesAtLocation:coordinate];
        [self drawCircleAroundCoordinate:coordinate];
        [self setZoomLevelWithCenter:coordinate];
    }
}

@end
