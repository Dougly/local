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
#import "ViewController.h"
#import "MTSettings.h"
#import <QuartzCore/QuartzCore.h>
#import "MTPhoto.h"
#import "UIImageView+WebCache.h"
#import "CMTabbarView.h"


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
    
    /*in km*/
    NSUInteger radius = [[MTSettings sharedSettings] getDistance];
    [manager query:coordinate radius:(radius * 1000) completion:^(BOOL success, NSArray *places, NSError *error) {
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
        
        MKImageAnnotationView *pinView = [[MKImageAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
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
    else {
        
        int width = [UIScreen mainScreen].bounds.size.width;
        int height = 150;

        UIView *vvv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        vvv.backgroundColor = [UIColor whiteColor];
        vvv.center = CGPointMake(view.bounds.size.width / 2, -height / 2);
        [view addSubview:vvv];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:vvv.bounds];
        __weak UIImageView *weakImageView = imageView;
        MTPhoto *photo = [((MTPlace *)annotation).photos.allObjects firstObject];
        
        NSString *strinUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=840&maxheight=320&photoreference=%@&key=%@", photo.reference, kGoogleMapAPIKey];
        [imageView setImageWithURL:[NSURL URLWithString:strinUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            weakImageView.image = image;
            weakImageView.contentMode = UIViewContentModeScaleAspectFit;
            
        }];
        [vvv addSubview:weakImageView];
        UIBezierPath *path = [self bubblePathWithRoundedCornerRadius:[UIScreen mainScreen].bounds.size.width height:150];
        
        CAShapeLayer *mask = [CAShapeLayer layer];
        mask.path = path.CGPath;
        
        vvv.layer.mask = mask;
        vvv.clipsToBounds = YES;
    }
}


- (UIBezierPath *)bubblePathWithRoundedCornerRadius:(int)width height:(int)height
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    int arrowWidth = 30;
    int arrowHeight = 30;
    

    
    [path moveToPoint:CGPointMake(100, height - arrowHeight/2)];
    [path addLineToPoint:CGPointMake(100 + arrowWidth/2, height)];
    [path addLineToPoint:CGPointMake(100 + arrowWidth, height - arrowHeight/2)];
    [path addLineToPoint:CGPointMake(width, height - arrowHeight/2)];
    [path addLineToPoint:CGPointMake(width, 0)];
    [path addLineToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(0, height - arrowHeight/2)];
    
    [path closePath];
    
    return path;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *viewController = [main instantiateViewControllerWithIdentifier:@"ViewController"];
    
    viewController.title = @"Details";
    viewController.place = (MTPlace *)view.annotation;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Overlays

- (void)drawCircleAroundCoordinate:(CLLocationCoordinate2D)coordinate {
    /*in km*/
    NSUInteger radius = [[MTSettings sharedSettings] getDistance];
    
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:coordinate radius:(radius*1000 + 700)];
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
