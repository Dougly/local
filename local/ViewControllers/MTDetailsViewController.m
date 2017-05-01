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

typedef void(^DetailsLargsetPhotoCompletion)(MTPhoto *largestPhoto, MTPlaceDetails *details);


@interface MTDetailsViewController()
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentHeight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *scrollViewBottomMargin;
@property (nonatomic) CGFloat initialScrollBottomMargin;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;


@property (nonatomic, weak) IBOutlet UIImageView *mainImageView;
@property (nonatomic, strong) MTPlaceDetails *placeDetails;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *detailsLabel;
@property (nonatomic, weak) IBOutlet UILabel *ratingLabel;

@property (nonatomic, weak) IBOutlet UITextView *addressTextView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *addressTextViewHeight;
@property (nonatomic, weak) IBOutlet UITextView *reviewTextView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *reviewTextViewHeight;
@property (nonatomic, weak) IBOutlet UIView *ratingView;

@end

@implementation MTDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    _initialScrollBottomMargin = self.scrollViewBottomMargin.constant;
    _contentHeight.constant = 500;
}


- (void)onKeyboardHide:(NSNotification *)notification {
    self.scrollViewBottomMargin.constant = _initialScrollBottomMargin;
    [UIView animateWithDuration:1.4
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
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
    int maxWidth = [[UIScreen mainScreen] scale] * [UIScreen mainScreen].bounds.size.width  *2;
    int maxHeight = [[UIScreen mainScreen] scale] * self.mainImageView.bounds.size.height  *2;
    
    __weak typeof(self) weakSelf = self;
    
    weakSelf.mainImageView.image = nil;
    [self getYelpRating];
    [self getDetails:self.place completion:^(MTPhoto *largestPhoto, MTPlaceDetails *details) {
        weakSelf.placeDetails = details;
        [weakSelf showDetails];
        
        NSString *strinUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=%d&maxheight=%d&photoreference=%@&key=%@", maxWidth, maxHeight, largestPhoto.reference, kGoogleMapAPIKey];
        
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
    
    if (self.placeDetails.formattedAddress)
        self.addressTextView.text = [self.addressTextView.text stringByAppendingString:self.placeDetails.formattedAddress];
    
    self.addressTextView.text = [self.addressTextView.text stringByAppendingString:@"\n"];
    
    if (self.placeDetails.localPhone)
        self.addressTextView.text =  [self.addressTextView.text stringByAppendingString:self.placeDetails.localPhone];
    
    self.addressTextView.text = [self.addressTextView.text stringByAppendingString:@"\n"];
    
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSUInteger weekday = [comps weekday];
    
    NSArray *openPeriods = self.placeDetails.openingHoursPeriods.allObjects;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"periodNumber == %d", weekday];
    NSArray *filteredPeriods = [openPeriods filteredArrayUsingPredicate:predicate];
    
    if (filteredPeriods.count > 0) {
        MTOpeningHourPeriod *period = filteredPeriods.firstObject;
        
        NSMutableString *openText = [NSMutableString stringWithString:period.openTime];
        [openText insertString:@":" atIndex:2];
        
        NSMutableString *closeText = [NSMutableString stringWithString:period.closeTime];
        [closeText insertString:@":" atIndex:2];
        
        NSString *closeMeridien = @"PM";
        
        if (period.closeDay.integerValue > period.openTime.integerValue) {
            closeMeridien = @"AM";
        }
        
        NSString *periodText = [NSString stringWithFormat:@"Open today: %@AM - %@%@", openText, closeText, closeMeridien];
        
        self.addressTextView.text = [self.addressTextView.text stringByAppendingString:periodText];
    }
    self.addressTextView.text = [self.addressTextView.text stringByAppendingString:@"\n"];
    
    if (self.placeDetails.website)
        self.addressTextView.text =  [self.addressTextView.text stringByAppendingString:self.placeDetails.website];
    
    CGSize sizeThatFitsTextView = [self.addressTextView sizeThatFits:CGSizeMake(self.addressTextView.frame.size.width, MAXFLOAT)];
    self.addressTextViewHeight.constant = sizeThatFitsTextView.height;
    
    NSArray *reviews = self.placeDetails.reviews.allObjects;
    
    if (reviews.count > 0) {
        MTPlaceReview *review = reviews.firstObject;
        self.reviewTextView.text = review.text;
    
        CGSize sizeThatFitsTextView = [self.reviewTextView sizeThatFits:CGSizeMake(self.reviewTextView.frame.size.width, MAXFLOAT)];
        
        self.reviewTextViewHeight.constant = sizeThatFitsTextView.height;
        self.contentHeight.constant = self.reviewTextView.frame.origin.y + sizeThatFitsTextView.height - BOTTOM_NAVIGATION_BAR_HEIGHT;
    }
    
    [self showUI];
}

- (void)getDetails:(MTPlace *)place completion:(DetailsLargsetPhotoCompletion)completion {
    
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

- (void)getYelpRating {
    self.ratingLabel.alpha = 0.0;
    [[MTYelpManager sharedManager] getYelpPlaceMatchingGooglePlace:self.place completion:^(BOOL success, MTYelpPlace *yelpPlace, NSError *error) {
        if (yelpPlace) {
            self.ratingLabel.text = [NSString stringWithFormat:@"%.1f %@   Yelp", yelpPlace.rating.floatValue, [yelpPlace ratingString]];
        }
        else {
            self.ratingLabel.text = [NSString stringWithFormat:@"%.1f %@   Google", self.place.rating.floatValue, [self.place ratingString]];
        }
        
        [UIView animateWithDuration:0.4 animations:^{
            self.ratingLabel.alpha = 1.0;
        }];
    }];
}

- (void)hideUI {
    self.titleLabel.alpha = 0.0;
    self.detailsLabel.alpha = 0.0;
    self.ratingView.alpha = 0.0;
    
    self.addressTextView.alpha = 0.0;
    self.reviewTextView.alpha = 0.0;
}

- (void)showUI {
    [UIView animateWithDuration:0.5 animations:^{
        self.titleLabel.alpha = 1.0;
        self.detailsLabel.alpha = 1.0;
        self.ratingView.alpha = 1.0;
        
        self.addressTextView.alpha = 1.0;
        self.reviewTextView.alpha = 1.0;
    }];
}


@end
