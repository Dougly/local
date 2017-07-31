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
#import "CMTabbarView.h"
#import "TitleView.h"
#import "MapPopupView.h"
#import "LocationView.h"
#import "ListView.h"
#import "MTPageContainerViewController.h"
#import "MTGetPlaceDetailRequest.h"
#import "MTGetPlaceDetailsResponse.h"
#import "MTPlaceDetails.h"
#import "FilterListener.h"
#import "MTDataModel.h"
#import "Local-Swift.h"

#define MIN_CLUSTERING_SPAN                       0.02

@interface MTMapViewController()<MKMapViewDelegate, UIGestureRecognizerDelegate, TitleViewDelegate, LocationViewDelegate, ListViewDelegate, MTLocationViewTextfieldCellDelegate, PopupClickDelegate>

@property(nonatomic, weak) IBOutlet MKMapView* mapView;
@property (nonatomic, strong) QTree *qTree;
@property (nonatomic, strong) MapPopupView *currentPopupView;
@property (nonatomic, strong) TitleView *titleView;
@property (nonatomic, strong) LocationView *locationView;
@property (nonatomic, strong) ListView *listView;
@property (nonatomic, strong) FilterListener *filterListener;

@property (nonatomic, weak) IBOutlet UIButton *redoSearchButton;
@property (nonatomic) BOOL popupBeingSelelected;
@end

@implementation MTMapViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.navigationController.navigationBar.tintColor = UIColorFromHex(0x939598);
    
    [[MTDataModel sharedDatabaseStorage] clearPlaces];
    [self showListAnimated:NO];
    
    [self getLocation];
    [self addTitleView];
    [self setupFilterListener];
    [self addGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self addBorderForRedoSeacrhButton];
}

- (void)addBorderForRedoSeacrhButton {
    self.redoSearchButton.layer.borderColor = UIColorFromHex(0xee0000).CGColor;
    self.redoSearchButton.layer.borderWidth = 0.5f;
}

- (void)addTitleView {
    self.titleView = [[[NSBundle mainBundle] loadNibNamed:@"TitleView" owner:self options:nil] objectAtIndex:0];
    self.titleView.delegate = self;
    self.navigationItem.titleView = self.titleView;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Log Out"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(logOut)];
    [self.navigationItem setLeftBarButtonItem:item animated:YES];
}

- (void)logOut {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.auth signOut];
}

- (void)getLocation {
    [[MTProgressHUD sharedHUD] showOnView:self.view
                               percentage:false];
    
    __weak typeof(self) weakSelf = self;
    [[MTLocationManager sharedManager] getLocation:^(BOOL success, NSString *erroMessage, CLLocationCoordinate2D coordinate) {
        [[MTProgressHUD sharedHUD] dismiss];
        if (success) {
            [weakSelf getPlacesAtLocation:coordinate];
            [weakSelf drawCircleAroundCoordinate:coordinate];
            [weakSelf setZoomLevelWithCenter:coordinate];
        }
        else {
            [MTAlertBuilder showAlertIn:weakSelf
                                message:erroMessage
                               delegate:nil];
        }
        
    }];
}

- (void)setZoomLevelWithCenter:(CLLocationCoordinate2D)coordinate {
    MKCoordinateRegion region;
    region.center.latitude = coordinate.latitude;
    region.center.longitude = coordinate.longitude;
    region.span.latitudeDelta = 0.06;
    region.span.longitudeDelta = 0.06;
    region = [self.mapView regionThatFits:region];
    [self.mapView setRegion:region animated:TRUE];
}

- (void)getPlacesAtLocation:(CLLocationCoordinate2D)coordinate {
    MTGooglePlacesManager *manager = [MTGooglePlacesManager sharedManager];
   
    
    self.qTree = nil;
    [manager query:coordinate radius:kRadiusSearch completion:^(BOOL success, NSArray *places, NSError *error) {
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
    
    const CLLocationDegrees minNonClusteredSpan = useClustering ? MIN(mapRegion.span.latitudeDelta, mapRegion.span.longitudeDelta) / 10
                                                              : 0;
    NSArray* objects = [self.qTree getObjectsInRegion:mapRegion minNonClusteredSpan:minNonClusteredSpan];

    NSMutableArray* annotationsToRemove = [self.mapView.annotations mutableCopy];
    [annotationsToRemove removeObject:self.mapView.userLocation];
    [annotationsToRemove removeObjectsInArray:objects];
    
    //Prevent the popup view from being clustered if it's visible
    if (self.currentPopupView) {
        [annotationsToRemove removeObject:self.currentPopupView.place];
    }
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
    NSLog(@"didSelectAnnotationView");
    
    if (self.popupBeingSelelected) {
        return;
    }
    
    id<MKAnnotation> annotation = view.annotation;
    if([annotation isKindOfClass:[QCluster class]]) {
        
        QCluster* cluster = (QCluster*)annotation;
        [mapView setRegion:MKCoordinateRegionMake(cluster.coordinate, MKCoordinateSpanMake(2.5 * cluster.radius, 2.5 * cluster.radius))
              animated:YES];
    }
    else {
        
        CLLocationCoordinate2D pinCenter = CLLocationCoordinate2DMake(view.annotation.coordinate.latitude, view.annotation.coordinate.longitude);
        [self.mapView setCenterCoordinate:pinCenter animated:YES];
        
        [self removePopup];
        self.currentPopupView = [[[NSBundle mainBundle] loadNibNamed:@"MapPopupView" owner:self options:nil] objectAtIndex:0];
        self.currentPopupView.delegate = self;
        self.currentPopupView.pinViewFrame = view.frame;
        self.currentPopupView.place = (MTPlace *)annotation;
        
        [view addSubview:self.currentPopupView];
    }
}

- (void)removePopup {
    [self.currentPopupView removeFromSuperview];
    self.currentPopupView = nil;
    self.mapView.selectedAnnotations = @[];
}

#pragma mark - Overlays

- (void)drawCircleAroundCoordinate:(CLLocationCoordinate2D)coordinate {
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:coordinate radius:kRadiusSearch + 700];
    [self.mapView addOverlay:circle];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleRenderer *circle = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        circle.strokeColor = kLocalColor;
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
    NSLog(@"handleTap");
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (!self.popupBeingSelelected) {
            [self removePopup];
            
            /*Get the coordinate*/
            /*CLLocationCoordinate2D coordinate = [self.mapView convertPoint:[gestureRecognizer locationInView:self.mapView] toCoordinateFromView:self.mapView];
            [self updatePlaces:coordinate];*/
        }
        else {
            [self didSelectItemForPlace:self.currentPopupView.place];
        }
    }
}

- (IBAction)updatePlaceInCurrentArea:(id)sender {
    [self removePopup];
    CLLocationCoordinate2D centerCoordinate = [self.mapView centerCoordinate];
    [self updatePlaces:centerCoordinate];
}

- (void)updatePlaces:(CLLocationCoordinate2D)coordinate {
    [self.mapView removeOverlays:self.mapView.overlays];
    [self getPlacesAtLocation:coordinate];
    [self drawCircleAroundCoordinate:coordinate];
    [self setZoomLevelWithCenter:coordinate];
}

#pragma mark - Title View delegagte

- (void)titleViewClicked:(BOOL)shouldReveal {
    if (shouldReveal) {
        [self showLocationView];
    }
    else {
        [self hideLocationView];
    }
}

- (void)showLocationView {
    
    self.locationView = [[[NSBundle mainBundle] loadNibNamed:@"LocationView" owner:self options:nil] objectAtIndex:0];
    self.locationView.delegate = self;
    self.locationView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 0);
    [self.view addSubview:self.locationView];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.locationView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    }];
}

- (void)hideLocationView {
    
    [self.titleView collapse];
    [UIView animateWithDuration:0.5 animations:^{
        self.locationView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 0);
    } completion:^(BOOL finished) {
        [self.locationView removeFromSuperview];
    }];
}

#pragma mark - right navigation item

- (void)showListNavigationItem {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_list_item"] style:UIBarButtonItemStylePlain target:self action:@selector(showListByClickingNavigationItem)];
    
    [item setTitleTextAttributes:@{
                                   NSForegroundColorAttributeName: UIColorFromHex(0x939598),
                                   NSFontAttributeName: [UIFont fontWithName:@"FontAwesome" size:16.0f]
                                   } forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)showMapNavigationItem {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_map_item"] style:UIBarButtonItemStylePlain target:self action:@selector(showMap)];
    [item setTitleTextAttributes:@{
                                   NSForegroundColorAttributeName: UIColorFromHex(0x939598),
                                   NSFontAttributeName: [UIFont fontWithName:@"FontAwesome" size:16.0f]
                                   } forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark - Switching between list and map

- (void)showListByClickingNavigationItem {
    [self showListAnimated:YES];
}

- (void)showListAnimated:(BOOL)animated {
    self.listView = [[[NSBundle mainBundle] loadNibNamed:@"ListView" owner:self options:nil] objectAtIndex:0];
    self.listView.delegate = self;
    self.listView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:self.listView];
    
    if (animated) {
        self.listView.alpha = 0.0;
        [UIView animateWithDuration:0.5 animations:^{
            self.listView.alpha = 1.0;
        }];
    }
    

    [self showMapNavigationItem];
}

- (void)showMap {
    [UIView animateWithDuration:0.4 animations:^{
        self.listView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.listView removeFromSuperview];
    }];
    
    [self showListNavigationItem];
}

#pragma mark - ListView delegate

- (void)didSelectItemForPlace:(MTPlace *)place {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MTPageContainerViewController *pageController = [main instantiateViewControllerWithIdentifier:@"MTPageContainerViewController"];
    
    pageController.title = place.name;
    pageController.place = place;
    
    [self.navigationController pushViewController:pageController animated:YES];
    
    [self removePopup];
    self.popupBeingSelelected = NO;
}

#pragma mark - MTLocationViewTextfieldCellDelegate

- (void)placeSelected:(NSString *)placeId {
    MTGetPlaceDetailRequest *request = [MTGetPlaceDetailRequest requestWithOwner:self];
    request.placeId = placeId;
    
    __weak typeof(self) weakSelf = self;
    request.completionBlock = ^(SDRequest *request, SDResult *response)
    {
        if ([response isSuccess]) {
            MTGetPlaceDetailsResponse *detailsResponse = (MTGetPlaceDetailsResponse *)response;
            MTPlaceDetails *placeDetails = detailsResponse.placeDetails;
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(placeDetails.lat.floatValue, placeDetails.lon.floatValue);
            [weakSelf updatePlaces:coordinate];
        }
    };
    [request run];
}

- (void)currentPlaceSelected {
    [self updatePlaces:[MTLocationManager sharedManager].lastLocation];
}

- (void)setupFilterListener {
    __weak typeof(self) weakSelf = self;
    self.filterListener.onKeyWordUpdatedHandler = ^{
        [weakSelf removePopup];
        [weakSelf updatePlaces:[MTLocationManager sharedManager].lastUsedLocation];
    };
}

#pragma mark - popup click delegate

- (void)popClickedForPlace:(MTPlace *)place {
    [self didSelectItemForPlace:place];
}

- (void)popupTouchBegan {
    NSLog(@"PopupTouchBegan");
    self.popupBeingSelelected = YES;
}

#pragma mark - access overrides

- (FilterListener *)filterListener {
    if (!_filterListener) {
        _filterListener = [FilterListener new];
    }
    
    return _filterListener;
}

@end
