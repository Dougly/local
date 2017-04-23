//
// This file is subject to the terms and conditions defined in
// file 'LICENSE.md', which is part of this source code package.
//

#import "MTMapViewController.h"
#import "QTree.h"
#import "DummyAnnotation.h"
#import "QCluster.h"
#import "ClusterAnnotationView.h"
#import "MKImageAnnotationView.h"

inline static CLLocationCoordinate2D referenceLocation()
{
  return CLLocationCoordinate2DMake(40.730610, -73.935242);
}

@interface MTMapViewController()<MKMapViewDelegate, UIGestureRecognizerDelegate>

@property(nonatomic, weak) IBOutlet MKMapView* mapView;
@property(nonatomic, weak) IBOutlet UISegmentedControl* segmentedControl;
@property(nonatomic, strong) QTree* qTree;

@end

@implementation MTMapViewController

-(void)awakeFromNib
{
  [super awakeFromNib];
  self.qTree = [QTree new];
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^
  {
      [self getRestaurantListForLocation:referenceLocation()];
      dispatch_async(dispatch_get_main_queue(), ^
      {
        [self reloadAnnotations];
      });
  });
  
  self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)addGesture {
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGesture.delegate = self;
    [self.mapView addGestureRecognizer:tapGesture];
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return [self getTappedAnnotations:touch].count == 0;
}

- (void)handleTap:(UITapGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.mapView removeOverlays:self.mapView.overlays];
   
        
        if ([gestureRecognizer.view isKindOfClass:[QCluster class]]) {
            
        }
        else {
            CLLocationCoordinate2D coordinate = [self.mapView convertPoint:[gestureRecognizer locationInView:self.mapView] toCoordinateFromView:self.mapView];
            
            [self.mapView setCenterCoordinate:coordinate animated:YES];
            
            // Do anything else with the coordinate as you see fit in your application
            MKCircle *circle = [MKCircle circleWithCenterCoordinate:coordinate radius:5000];
            [self.mapView addOverlay:circle];
        }
    }
}

- (void)query:(NSString *)pageToken coordinate:(CLLocationCoordinate2D)coordinate {
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%lf,%lf&types=cafe|restaurant|pub&key=%@&radius=6000&sensor=false", coordinate.latitude, coordinate.longitude, kGoogleMapAPIKey];
    
    if (pageToken) {
        NSString *tokenPart = [NSString stringWithFormat:@"&pagetoken=%@", pageToken];
        urlString = [urlString stringByAppendingString:tokenPart];
    }
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    __weak typeof(self) weakSelf = self;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (!connectionError) {
            [weakSelf parse:data
                 coordinate:coordinate];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadAnnotations];
        });
    }];
}

- (void)getRestaurantListForLocation:(CLLocationCoordinate2D)coordinate{
    [self query:nil coordinate:coordinate];
}

- (void)parse:(NSData *)data coordinate:(CLLocationCoordinate2D)coordinate{
    if (data) {
        
        NSError *errorJson=nil;
        NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJson];
        
        BOOL isPackContainingNewObjects = YES;
        NSArray *list = [responseDict objectForKey:@"results"];
        if (list){
            
            NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:list.count];
            for (NSDictionary *dict in list){
                
                /*
                 Restaurant *res = [[Restaurant alloc]init];
                 res.name = [dict objectForKey:@"name"];
                 res.ID = [dict objectForKey:@"id"];
                 res.icon = [dict objectForKey:@"icon"];
                 res.palceId = [dict objectForKey:@"place_id"];
                 res.rating = [dict objectForKey:@"rating"];
                 res.reference = [dict objectForKey:@"reference"];
                 res.vicinity = [dict objectForKey:@"vicinity"];
                 */
                DummyAnnotation* object = [DummyAnnotation new];
                object.uniqueId = [dict objectForKey:@"id"];
                NSArray *photoArray = [dict objectForKey:@"photos"];
                if (photoArray.count > 0){
                    object.imageUrl = [[photoArray firstObject] objectForKey:@"photo_reference"];
                }
                
                NSDictionary *locationDict = [dict objectForKey:@"geometry"];
                
                double latitude = [[[locationDict objectForKey:@"location"] objectForKey:@"lat"] doubleValue];
                double longitude = [[[locationDict objectForKey:@"location"] objectForKey:@"lng"] doubleValue];
                
                
                object.title = [dict objectForKey:@"name"];
                object.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
                
                if ([self.qTree removeObject:object]) {
                    [self.qTree insertObject:object];
                    isPackContainingNewObjects = false;
                    NSLog(@"Insert duplicate place");
                }
                else {
                    [self.qTree insertObject:object];
                    NSLog(@"Insert unique place");
                }
            }
        }
        
        NSString *token = responseDict[@"next_page_token"];
        if (token && isPackContainingNewObjects)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self query:token
             coordinate:coordinate];
        });
    }
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    MKCoordinateRegion region;
    region.center.latitude = referenceLocation().latitude;
    region.center.longitude = referenceLocation().longitude;
    region.span.latitudeDelta = 0.7;
    region.span.longitudeDelta = 0.7;
    region = [self.mapView regionThatFits:region];
    [self.mapView setRegion:region animated:TRUE];
    
    [self addGesture];
}

- (void)reloadAnnotations {
    if( !self.isViewLoaded ) {
        return;
    }

    const MKCoordinateRegion mapRegion = self.mapView.region;
    BOOL useClustering = (self.segmentedControl.selectedSegmentIndex == 0);
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

- (IBAction)segmentChanged:(id)sender {
    [self reloadAnnotations];
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
  else if ([annotation isKindOfClass:[DummyAnnotation class]]){
        static NSString *defaultPinID = @"com.local.food";
        MKImageAnnotationView *pinView = (MKImageAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if (pinView == nil)
            pinView = [[MKImageAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:defaultPinID];
      
      
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

@end
