//
//  ViewController.m
//  TGFoursquareLocationDetail-Demo
//
//  Created by Thibault Guégan on 15/12/2013.
//  Copyright (c) 2013 Thibault Guégan. All rights reserved.
//

#import "ViewController.h"
#import "MTPlace.h"
#import "MTPhoto.h"
#import "MTGetPlaceDetailRequest.h"
#import "MTGetPlaceDetailsResponse.h"
#import "MTPlaceDetails.h"
#import "MTPlaceReview.h"
#import "MTWeekdayText.h"
#import "MTOpeningHourPeriod.h"
#import "UIImageView+WebCache.h"
#import "MTProgressHUD.h"

@interface ViewController ()
@property (nonatomic, strong) MTPlaceDetails *placeDetails;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getDetails];
}

- (void)setup {
    self.locationDetail = [[TGFoursquareLocationDetail alloc] initWithFrame:self.view.bounds];
    self.locationDetail.tableView.showsVerticalScrollIndicator = NO;
    self.locationDetail.tableViewDataSource = self;
    self.locationDetail.tableViewDelegate = self;
    
    self.locationDetail.delegate = self;
    self.locationDetail.parallaxScrollFactor = 0.3; // little slower than normal.
    
    self.locationDetail.alpha = 0.0;
    [self.view addSubview:self.locationDetail];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.7 animations:^{
            [[MTProgressHUD sharedHUD] dismiss];
            self.locationDetail.alpha = 1.0;
        }];
    });

    
    [self.view bringSubviewToFront:_headerView];
    
    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame = CGRectMake(10, 22, 44, 44);
    [buttonBack setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonBack];
    
    UIButton *buttonPost = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonPost.frame = CGRectMake(self.view.bounds.size.width - 44, 18, 44, 44);
    [buttonPost setImage:[UIImage imageNamed:@"btn_post"] forState:UIControlStateNormal];
    [buttonPost addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonPost];
    
    self.locationDetail.headerView = _headerView;

}

- (void)getDetails {
    [[MTProgressHUD sharedHUD] showOnView:self.view percentage:false];
    MTGetPlaceDetailRequest *request = [MTGetPlaceDetailRequest requestWithOwner:self];
    request.placeId = self.place.placeId;
    
    __weak typeof (self) weakSelf = self;
    request.completionBlock = ^(SDRequest *request, SDResult *response)
    {
        
        if ([response isSuccess]) {
            MTGetPlaceDetailsResponse *detailsResponse = (MTGetPlaceDetailsResponse *)response;
            weakSelf.placeDetails = detailsResponse.placeDetails;
            [weakSelf setup];
        }
        else {
            
        }
    };
    [request run];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return 138.0f;
    }
    else if(indexPath.row == 1){
        return 171.0f;
    }
    else if(indexPath.row == 2){
        return 138.0f;
    }
    else
        return 100.0f; //cell for comments, in reality the height has to be adjustable
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 0){
        DetailLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailLocationCell"];
        
        if(cell == nil){
            cell = [DetailLocationCell detailLocationCell];
        }
        
        cell.lblTitle.text = self.place.name;
        cell.lblDescription.text = self.placeDetails.formattedAddress;
        cell.lblRate.text = [self.placeDetails.rating stringValue];
        return cell;
    }
    else if(indexPath.row == 1){
        AddressLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressLocationDetail"];

        if(cell == nil){
            cell = [AddressLocationCell addressLocationDetailCell];
            _map = [[MKMapView alloc] initWithFrame:CGRectMake(219, 0, [UIScreen mainScreen].bounds.size.width - 219, 171)];
            _map.userInteractionEnabled = FALSE;
            _map.delegate = self;
            MKCoordinateRegion myRegion;
            
            myRegion.center.latitude = [self.placeDetails.lat floatValue];
            myRegion.center.longitude = [self.placeDetails.lon floatValue];
            
            // this sets the zoom level, a smaller value like 0.02
            // zooms in, a larger value like 80.0 zooms out
            myRegion.span.latitudeDelta = 0.05;
            myRegion.span.longitudeDelta = 0.05;
            
            // move the map to our location
            [_map setRegion:myRegion animated:NO];
            
            //annotation
            TGAnnotation *annot = [[TGAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake([self.place.lat floatValue], [self.place.lon floatValue])];
            [_map addAnnotation:annot];
            
            if (self.placeDetails.streetName)
                cell.streetNameLabel.text = [NSString stringWithFormat:@"%@ %@", self.placeDetails.streetName, self.placeDetails.streetNumber ? self.placeDetails.streetNumber : @""];
            else {
                cell.streetNameLabel.text = @"";
            }
            
            if (self.placeDetails.neighbourhood)
                cell.neighborhoodLabel.text = self.placeDetails.neighbourhood;
            else {
                cell.neighborhoodLabel.text = @"";
            }
            cell.adminLevel2Label.text = self.placeDetails.adminLevel2;
            cell.phoneTextView.text = self.placeDetails.localPhone;
            [cell.contentView addSubview:_map];
        }

        return cell;
    }
    else if(indexPath.row == 2){
        UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell"];
        
        if(cell == nil){
            cell = [UserCell userCell];
        }
        
        NSString *url = ((MTPlaceReview *)self.placeDetails.reviews.allObjects.firstObject).authorAvatarUrl;
        
        if (url) {
            cell.userImg.alpha = 0;
            [cell.userImg setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                cell.userImg.image = image;
                
                [UIView animateWithDuration:0.7 animations:^{
                    cell.userImg.alpha = 1.0;
                }];
            }];
        }
        
        return cell;
    }
    else if(indexPath.row == 3){
        TipCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tipCell"];
        
        NSString *author = @"";
        NSString *text = @"";
        if (self.placeDetails.reviews.count > 0) {
            MTPlaceReview *review = self.placeDetails.reviews.allObjects[0];
            author = review.authorName;
            text = review.text;
        }
        
        if(cell == nil){
            cell = [TipCell tipCell];
            cell.titleLbl.text = author;
            cell.contentLbl.text = text;
        }
        return cell;
    }
    else if(indexPath.row == 4){
        TipCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tipCell"];
        
        NSString *author = @"";
        NSString *text = @"";
        if (self.placeDetails.reviews.count > 1) {
            MTPlaceReview *review = self.placeDetails.reviews.allObjects[1];
            author = review.authorName;
            text = review.text;
        }
        
        if(cell == nil){
            cell = [TipCell tipCell];
            cell.titleLbl.text = author;
            cell.contentLbl.text = text;
        }
        return cell;
    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reusable"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reusable"];
        }
        
        cell.textLabel.text = @"Default cell";
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.contentView.backgroundColor = [UIColor whiteColor];
}

#pragma mark - LocationDetailViewDelegate

- (void)locationDetail:(TGFoursquareLocationDetail *)locationDetail imagePagerDidLoad:(KIImagePager *)imagePager
{
    imagePager.dataSource = self;
    imagePager.delegate = self;
    imagePager.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    imagePager.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    imagePager.slideshowTimeInterval = 0.0f;
    imagePager.slideshowShouldCallScrollToDelegate = YES;
    
    self.locationDetail.nbImages = [self.locationDetail.imagePager.dataSource.arrayWithImages count];
    self.locationDetail.currentImage = 0;
    //[imagePager updateCaptionLabelForImageAtIndex:self.locationDetail.currentImage];
}

- (void)locationDetail:(TGFoursquareLocationDetail *)locationDetail tableViewDidLoad:(UITableView *)tableView
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)locationDetail:(TGFoursquareLocationDetail *)locationDetail headerViewDidLoad:(UIView *)headerView
{
    [headerView setAlpha:0.0];
    [headerView setHidden:YES];
}

#pragma mark - MKMap View methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if (annotation == mapView.userLocation)
        return nil;
    
    static NSString *MyPinAnnotationIdentifier = @"Pin";
    MKPinAnnotationView *pinView =
    (MKPinAnnotationView *) [self.map dequeueReusableAnnotationViewWithIdentifier:MyPinAnnotationIdentifier];
    if (!pinView){
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                        reuseIdentifier:MyPinAnnotationIdentifier];
        
        annotationView.image = [UIImage imageNamed:@"pin_map_blue"];
        
        return annotationView;
        
    }else{
        
        pinView.image = [UIImage imageNamed:@"pin_map_blue"];
        
        return pinView;
    }
    
    return nil;
}

#pragma mark - KIImagePager DataSource
- (NSArray *) arrayWithImages
{
    if (self.placeDetails) {
        NSMutableArray *imageUrls = [[NSMutableArray alloc] init];
        for (MTPhoto *photo in self.placeDetails.photos) {
            NSString *stringUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=1000&maxheight=600&photoreference=%@&key=%@", photo.reference, kGoogleMapAPIKey];
            [imageUrls addObject:stringUrl];
        }
        
        return imageUrls;
    }
    
    return nil;
    
    /*
    return @[
             @"https://irs2.4sqi.net/img/general/500x500/2514_BvEN_Q6lG50xZQ9TIG0XY8eYXzF3USSMdtTmxHCmqnE.jpg",
             @"https://irs3.4sqi.net/img/general/500x500/6555164_Rkk21OJj4X54X8bkutzxbeCwLHTA8Hrre6_wUVc1DMg.jpg",
             @"https://irs2.4sqi.net/img/general/500x500/3648632_NVZOdXiRTkVtzHoGNh5c5SqsF2NxYDB_FMfXRCbYu6I.jpg",
             @"https://irs1.4sqi.net/img/general/500x500/23351702_KoUKj6hZLOTHIsawxi2L64O5CpJwCadeIv2daMBDE8Q.jpg"
             ];*/
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image
{
    return UIViewContentModeScaleAspectFill;
}

/* Uncommenting this will make these label visible
- (NSString *) captionForImageAtIndex:(NSUInteger)index
{
    return @[
             @"First screenshot",
             @"Another screenshot",
             @"And another one",
             @"Last one! ;-)"
             ][index];
}
*/
#pragma mark - KIImagePager Delegate
- (void) imagePager:(KIImagePager *)imagePager didScrollToIndex:(NSUInteger)index
{
    NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
}

- (void) imagePager:(KIImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index
{
    NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
}

#pragma mark - Button actions

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)post
{
    NSLog(@"Post action");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
