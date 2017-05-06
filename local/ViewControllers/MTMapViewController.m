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
#import "MTSettignsViewController.h"
#import "LocationView.h"
#import "ListView.h"
#import "MTPageContainerViewController.h"
#import "MTGetPlaceDetailRequest.h"
#import "MTGetPlaceDetailsResponse.h"
#import "MTPlaceDetails.h"
#import "FilterListener.h"
#import "MTDataModel.h"

@interface MTMapViewController()<MKMapViewDelegate, UIGestureRecognizerDelegate, TitleViewDelegate, LocationViewDelegate, ListViewDelegate, MTLocationViewTextfieldCellDelegate, PopupClickDelegate>

@property(nonatomic, weak) IBOutlet MKMapView* mapView;
@property (nonatomic, strong) QTree *qTree;
@property (nonatomic, strong) MapPopupView *currentPopupView;
@property (nonatomic, strong) TitleView *titleView;
@property (nonatomic, strong) LocationView *locationView;
@property (nonatomic, strong) ListView *listView;
@property (nonatomic, strong) FilterListener *filterListener;

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
}

- (void)addTitleView {
    self.titleView = [[[NSBundle mainBundle] loadNibNamed:@"TitleView" owner:self options:nil] objectAtIndex:0];
    self.titleView.delegate = self;
    self.navigationItem.titleView = self.titleView;
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
    [manager query:coordinate radius:(1 * 1900) completion:^(BOOL success, NSArray *places, NSError *error) {
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
        
        [self.currentPopupView removeFromSuperview];
        self.currentPopupView = [[[NSBundle mainBundle] loadNibNamed:@"MapPopupView" owner:self options:nil] objectAtIndex:0];
        self.currentPopupView.delegate = self;
        self.currentPopupView.pinViewFrame = view.frame;
        self.currentPopupView.place = (MTPlace *)annotation;
        
        [view addSubview:self.currentPopupView];
    }
}

#pragma mark - Overlays

- (void)drawCircleAroundCoordinate:(CLLocationCoordinate2D)coordinate {
    /*in km*/
    /*NSUInteger radius = [[MTSettings sharedSettings] getDistance];
    
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:coordinate radius:(radius*1000 + 700)];
    [self.mapView addOverlay:circle];*/
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

#pragma mark - Temporary

- (IBAction)settingsButtonClicked:(id)sender {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MTSettignsViewController *viewController = [main instantiateViewControllerWithIdentifier:@"MTSettignsViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
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
    
    [self.currentPopupView removeFromSuperview];
    self.currentPopupView = nil;
    self.popupBeingSelelected = NO;
    self.mapView.selectedAnnotations = @[];
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
        [weakSelf.currentPopupView removeFromSuperview];
        weakSelf.currentPopupView = nil;
        [weakSelf updatePlaces:[MTLocationManager sharedManager].lastUsedLocation];
    };
}

#pragma mark - popup click delegate

- (void)popClickedForPlace:(MTPlace *)place {
    [self.currentPopupView removeFromSuperview];
    self.currentPopupView = nil;
    
    [self didSelectItemForPlace:place];
}

- (void)popupTouchBegan {
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
