//
//  MTSignupViewController.m
//  Automatize
//
//  Created by Rostyslav.Stepanyak on 4/14/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MTDetailsViewController.h"
#import "MTPlace.h"
#import "MTPlaceDetails.h"
#import "MTPhoto.h"
#import "MTWeekdayText.h"
#import "UIImageView+WebCache.h"
#import "MTGetPlaceDetailRequest.h"
#import "MTGetPlaceDetailsResponse.h"
#import "MTOpeningHourPeriod.h"
#import "MTPlaceReview.h"
#import "MTProgressHUD.h"
#import "MTYelpManager.h"
#import "MTYelpPlace.h"
#import "TGAnnotation.h"

typedef void(^DetailsLargsetPhotoCompletion)(MTPhoto *largestPhoto, MTPlaceDetails *details);


@interface MTDetailsViewController()
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentHeight;
@property (nonatomic) CGFloat initialScrollBottomMargin;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;


@property (nonatomic, weak) IBOutlet UIImageView *mainImageView;
@property (nonatomic, strong) MTPlaceDetails *placeDetails;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *detailsLabel;
@property (nonatomic, weak) IBOutlet UILabel *ratingNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *ratingLabel;

@property (nonatomic, weak) IBOutlet UILabel *ratingIconLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *ratingIconLabelWidth;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *ratingIconAndLabelPadding;

@property (nonatomic, weak) IBOutlet UILabel *ratingSourceLabel;

@property (nonatomic, weak) IBOutlet UITextView *addressTextView;
@property (nonatomic, weak) IBOutlet UITextView *reviewTextView;
@property (nonatomic, weak) IBOutlet UIView *ratingView;

@property (nonatomic, weak) IBOutlet UILabel *hoursLabel;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) UIView *mapViewOverlay;
@end

@implementation MTDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self addBordersForRatingView];
}

- (void)addBordersForRatingView {
    CALayer *upperBorder = [CALayer layer];
    upperBorder.backgroundColor = UIColorFromHex(0xf7f7f7).CGColor;
    upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(self.ratingView.frame), 1.5f);
    [self.ratingView.layer addSublayer:upperBorder];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.backgroundColor = UIColorFromHex(0xf7f7f7).CGColor;
    bottomBorder.frame = CGRectMake(0, self.ratingView.bounds.size.height - 1.5, CGRectGetWidth(self.ratingView.frame), 1.5f);
    [self.ratingView.layer addSublayer:bottomBorder];
}

- (void)addBorderForReviewView {
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.backgroundColor = UIColorFromHex(0xf7f7f7).CGColor;
    bottomBorder.frame = CGRectMake(0, self.reviewTextView.bounds.size.height - 1.5, CGRectGetWidth(self.reviewTextView.frame), 1.5f);
    [self.reviewTextView.layer addSublayer:bottomBorder];
}

- (void)addBorderForAddressView {
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.backgroundColor = UIColorFromHex(0xf7f7f7).CGColor;
    bottomBorder.frame = CGRectMake(0, self.addressTextView.bounds.size.height - 1.5, CGRectGetWidth(self.addressTextView.frame), 1.5f);
    [self.addressTextView.layer addSublayer:bottomBorder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)setup {
    [[MTProgressHUD sharedHUD] dismiss];
    [[MTProgressHUD sharedHUD] showOnView:self.view percentage:NO];
    [self hideUI];
    
    __weak typeof(self) weakSelf = self;
    
    weakSelf.mainImageView.image = nil;
    [self getYelpRating];
    [self getDetails:self.place completion:^(MTPhoto *largestPhoto, MTPlaceDetails *details) {
        weakSelf.placeDetails = details;
        [weakSelf showDetails];
        
        NSString *strinUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?&maxheight=%d&photoreference=%@&key=%@", 1600, largestPhoto.reference, kGoogleMapAPIKey];
        
        [weakSelf.mainImageView setImageWithURL:[NSURL URLWithString:strinUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            weakSelf.mainImageView.alpha = 0.0;
            
            weakSelf.mainImageView.image = image;
            weakSelf.mainImageView.contentMode = UIViewContentModeScaleToFill;
            
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.mainImageView.alpha = 1.0;
            }];
            
            [[MTProgressHUD sharedHUD] dismiss];
        }];
    }];
}

- (void)showDetails {
    self.detailsLabel.text = [self.place getDetailsString];
    self.titleLabel.text = self.place.name;
    
    NSArray *reviews = self.placeDetails.reviews.allObjects;
    
    if (reviews.count > 0) {
        MTPlaceReview *review = reviews.firstObject;
        self.reviewTextView.text = review.text;
    }
    
    CGSize sizeThatFitsReviewTextView = [self.reviewTextView sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width - 24, MAXFLOAT)];
    
    self.addressTextView.text = @"";
    if (self.placeDetails.formattedAddress) {
        self.addressTextView.text = [self.addressTextView.text stringByAppendingString:self.placeDetails.formattedAddress];
            self.addressTextView.text = [self.addressTextView.text stringByAppendingString:@"\n"];
    }
    
    if (self.placeDetails.localPhone) {
        self.addressTextView.text =  [self.addressTextView.text stringByAppendingString:self.placeDetails.localPhone];
        self.addressTextView.text = [self.addressTextView.text stringByAppendingString:@"\n"];
    }
    
    if (self.placeDetails.website) {
        self.addressTextView.text =  [self.addressTextView.text stringByAppendingString:self.placeDetails.website];
    }
    
    CGSize sizeThatFitsAddressTextView = [self.addressTextView sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width - 24, MAXFLOAT)];
    
    NSLog(@"AddressHeight: %f", sizeThatFitsAddressTextView.height);

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"HEIGHTOFCONTENT: %f", self.reviewTextView.frame.origin.y + sizeThatFitsReviewTextView.height + sizeThatFitsAddressTextView.height + self.mapView.bounds.size.height);
        self.contentHeight.constant = self.reviewTextView.frame.origin.y + sizeThatFitsReviewTextView.height + sizeThatFitsAddressTextView.height + self.mapView.bounds.size.height - BOTTOM_NAVIGATION_BAR_HEIGHT - 20;
        [self addBorderForReviewView];
        [self addBorderForAddressView];
    });
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSUInteger weekday = [comps weekday];
    
    NSArray *openPeriods = self.placeDetails.openingHoursPeriods.allObjects;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"periodNumber == %d", weekday];
    NSArray *filteredPeriods = [openPeriods filteredArrayUsingPredicate:predicate];
    
    if (filteredPeriods.count > 0) {
        MTOpeningHourPeriod *period = filteredPeriods.firstObject;
        
        NSString *openText = [NSMutableString stringWithString:period.openTime];
        openText = [openText substringToIndex:2];
        
        NSString *closeText = [NSMutableString stringWithString:period.closeTime];
        closeText = [closeText substringToIndex:2];
        
        NSString *closeMeridien = @"PM";
        
        if (period.closeDay.integerValue > period.openTime.integerValue) {
            closeMeridien = @"AM";
        }
        
        NSString *periodText = [NSString stringWithFormat:@"%@AM-%@%@", openText, closeText, closeMeridien];
        
        self.hoursLabel.text = periodText;
    }
    
   [self setupMap];
   [self showUI];
}

- (void)getDetails:(MTPlace *)place completion:(DetailsLargsetPhotoCompletion)completion {
    MTPlaceDetails *placeDetails = [[MTDataModel sharedDatabaseStorage] getPlaceDetialsForId:place.placeId];
    
    if (placeDetails) {
        completion([placeDetails getLargestPhoto], placeDetails);
    }
    else {
        MTGetPlaceDetailRequest *request = [MTGetPlaceDetailRequest requestWithOwner:self];
        request.placeId = place.placeId;
        
        request.completionBlock = ^(SDRequest *request, SDResult *response)
        {
            if ([response isSuccess]) {
                MTGetPlaceDetailsResponse *detailsResponse = (MTGetPlaceDetailsResponse *)response;
                MTPlaceDetails *placeDetails = detailsResponse.placeDetails;
                MTPhoto *largestPhoto = [placeDetails getLargestPhoto];
                completion(largestPhoto, placeDetails);
            }
            else {
                completion(nil, nil);
            }
        };
        [request run];
    }
}

- (void)getYelpRating {
    self.ratingLabel.alpha = 0.0;
    [[MTYelpManager sharedManager] getYelpPlaceMatchingGooglePlace:self.place completion:^(BOOL success, MTYelpPlace *yelpPlace, NSError *error) {
        if (yelpPlace) {
            self.ratingNumberLabel.text = [NSString stringWithFormat:@"%.1f", yelpPlace.rating.floatValue];
            self.ratingLabel.attributedText = [yelpPlace ratingString];
            self.ratingIconLabel.text = @"";
            self.ratingSourceLabel.text = @"YELP";
        }
        else {
            self.ratingNumberLabel.text = [NSString stringWithFormat:@"%.1f", self.place.rating.floatValue];
            self.ratingLabel.attributedText = [self.place ratingString];
            self.ratingIconLabelWidth.constant = 0;
            self.ratingIconAndLabelPadding.constant = 4;
            self.ratingSourceLabel.text = @"Google";
        }
        
        [UIView animateWithDuration:0.4 animations:^{
            self.ratingLabel.alpha = 1.0;
        }];
    }];
}

- (void)hideUI {
    self.contentView.alpha = 0.0;
}

- (void)showUI {
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.alpha = 1.0;
    } completion:^(BOOL finished) {
        //[weakSelf postProcessTextViewLinksStyle:weakSelf.addressTextView];
        self.reviewTextView.tintColor = [UIColor redColor];
        self.reviewTextView.linkTextAttributes = @{NSForegroundColorAttributeName : [UIColor redColor]};

        self.addressTextView.tintColor = [UIColor redColor];
        self.addressTextView.linkTextAttributes = @{NSForegroundColorAttributeName : [UIColor redColor]};
    }];
}

- (void)setupMap {
    __weak typeof(self) weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.mapView.userInteractionEnabled = FALSE;
        weakSelf.mapView.delegate = weakSelf;
        MKCoordinateRegion myRegion;
        
        myRegion.center.latitude = [weakSelf.placeDetails.lat floatValue];
        myRegion.center.longitude = [weakSelf.placeDetails.lon floatValue];
        
        // this sets the zoom level, a smaller value like 0.02
        // zooms in, a larger value like 80.0 zooms out
        myRegion.span.latitudeDelta = 0.002;
        myRegion.span.longitudeDelta = 0.002;
        
        // move the map to our location
        [weakSelf.mapView setRegion:myRegion animated:NO];
        
        if (self.mapViewOverlay) {
            [self.mapViewOverlay removeFromSuperview];
        }
        
        self.mapViewOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mapView.bounds.size.width, self.mapView.bounds.size.height)];
        
        self.mapViewOverlay.backgroundColor = [UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:0.7];
        [self.mapView addSubview:self.mapViewOverlay];
        
        //annotation
        TGAnnotation *annot = [[TGAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake([self.place.lat floatValue], [self.place.lon floatValue])];
        [weakSelf.mapView addAnnotation:annot];
    });
}

#pragma mark - MKMap View methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if (annotation == mapView.userLocation)
        return nil;
    
    static NSString *MyPinAnnotationIdentifier = @"Pin";
    MKPinAnnotationView *pinView =
    (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:MyPinAnnotationIdentifier];
    if (!pinView){
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                        reuseIdentifier:MyPinAnnotationIdentifier];
        
        annotationView.image = [UIImage imageNamed:@"ic_pin"];
        
        return annotationView;
        
    }else{
        
        pinView.image = [UIImage imageNamed:@"ic_pin"];
        
        return pinView;
    }
    
    return nil;
}

@end
