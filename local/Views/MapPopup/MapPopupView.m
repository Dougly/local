//
//  TitleView.m
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/28/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MapPopupView.h"
#import "MTPlace.h"
#import "UIImageView+WebCache.h"
#import "MTPhoto.h"
#import "MTGetPlaceDetailRequest.h"
#import "MTGetPlaceDetailsResponse.h"
#import "MTPlaceDetails.h"
#import "MTPhoto.h"

#define POPUP_HEIGHT                 200
#define MIN_POP_UP_WIDTH             160
#define ARROW_WIDTH                  30
#define ARROW_HEIGHT                 30

@interface MapPopupView()
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressAndRatingLabel;
@property (nonatomic, strong) MTPlaceDetails *placeDetails;

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation MapPopupView


- (void)setPlace:(MTPlace *)place {
    _place = place;
    [self getDetails];
}

- (void)getDetails {
    [self switchToLoadingView];
    
    MTGetPlaceDetailRequest *request = [MTGetPlaceDetailRequest requestWithOwner:self];
    request.placeId = self.place.placeId;
    
    __weak typeof (self) weakSelf = self;
    self.spinner.hidden = false;
    [self.spinner startAnimating];
    
    request.completionBlock = ^(SDRequest *request, SDResult *response)
    {
        if ([response isSuccess]) {
            MTGetPlaceDetailsResponse *detailsResponse = (MTGetPlaceDetailsResponse *)response;
            weakSelf.placeDetails = detailsResponse.placeDetails;
            [weakSelf downloadImage];
        }
    };
    [request run];
}

- (void)downloadImage {
    MTPhoto *largestPhoto = [self.placeDetails getLargestPhoto];
    
    if (!largestPhoto) {
        if (self.place.photos.allObjects > 0)
            largestPhoto = self.place.photos.allObjects.firstObject;
    }
    
    NSString *pricing = @"";
    
    for (int i=0; i<self.place.pricingLevel.integerValue; i++) {
        pricing = [pricing stringByAppendingString:@"$"];
    }
    
    if (pricing.length > 0) {
        pricing = [@"  •  " stringByAppendingString:pricing];
    }
    
    NSString *type =@"Unknown type";
    NSArray *types = [self.place.types componentsSeparatedByString:DELIMITER];
    
    if (types > 0) {
        type = types.firstObject;
    }
    
    NSString *address = [self getAddressDirty];
    
    self.addressAndRatingLabel.text = [NSString stringWithFormat:@"%@  •  %.1f %@  •  %@", address, self.place.rating.floatValue, pricing, type];
    self.titleLabel.text = self.place.name;
    
    int maxWidth = [[UIScreen mainScreen] scale] * [UIScreen mainScreen].bounds.size.width;
    int maxHeight = [[UIScreen mainScreen] scale] * POPUP_HEIGHT;
    
    NSString *strinUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=%d&maxheight=%d&photoreference=%@&key=%@", maxWidth, maxHeight, largestPhoto.reference, kGoogleMapAPIKey];
    __weak typeof (self) weakSelf = self;
    [self.imageView setImageWithURL:[NSURL URLWithString:strinUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        [weakSelf switchToImageView];
        
        weakSelf.imageView.image = image;
        weakSelf.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        CGFloat screenScale = [[UIScreen mainScreen] scale];
        
        int viewWidth = MAX(MIN_POP_UP_WIDTH, (image.size.width / screenScale));
        int viewHeight = MIN(POPUP_HEIGHT, (image.size.height/ screenScale));
        
        if (viewWidth == 0 || viewHeight == 0) {
            viewWidth = maxWidth / [[UIScreen mainScreen] scale] / 2;
            viewHeight = maxHeight / [[UIScreen mainScreen] scale] / 2;
        }
        
        self.frame = CGRectMake(0, 0, viewWidth, viewHeight);
        self.center = CGPointMake(self.pinViewFrame.size.width / 2, -viewHeight / 2);
        
        weakSelf.imageView.layer.cornerRadius = 20;
        weakSelf.imageView.clipsToBounds = YES;
        [weakSelf setupWith:viewWidth height:viewHeight];
    }];
}

- (void)setupWith:(int)width height:(int)height {
    UIBezierPath *path = [self bubblePathWithRoundedCornerRadius:width height:height];
    
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.path = path.CGPath;
    
    self.layer.mask = mask;
    self.clipsToBounds = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1.0;
    }];
    
    self.layer.cornerRadius = 20;
}

- (UIBezierPath *)bubblePathWithRoundedCornerRadius:(int)width height:(int)height
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    int arrowWidth = ARROW_WIDTH;
    int arrowHeight = ARROW_HEIGHT;
    
    int tailPosition = width/2 - arrowWidth/2;
    
    int cornerRadius = 20;
    
    [path moveToPoint:CGPointMake(tailPosition, height - arrowHeight/2)];
    [path addLineToPoint:CGPointMake(tailPosition + arrowWidth/2, height)];
    [path addLineToPoint:CGPointMake(tailPosition + arrowWidth, height - arrowHeight/2)];
    [path addLineToPoint:CGPointMake(width - cornerRadius, height - arrowHeight/2)];
    
    // Bottom right arc
    [path addArcWithCenter:CGPointMake(width - cornerRadius,
                                       height - arrowHeight/2 - cornerRadius)
                    radius:cornerRadius startAngle:M_PI / 2 endAngle:2 * M_PI
                 clockwise:NO];
    
    [path addLineToPoint:CGPointMake(width, height - arrowHeight/2 - cornerRadius)];
    
    [path addLineToPoint:CGPointMake(width, 0)];
    [path addLineToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(0, height - arrowHeight/2 - cornerRadius)];
    
    // Bottom left arc
    [path addArcWithCenter:CGPointMake(cornerRadius,
                                       height - arrowHeight/2 - cornerRadius)
                    radius:cornerRadius startAngle:M_PI endAngle:M_PI / 2
                 clockwise:NO];
    
    [path addLineToPoint:CGPointMake(cornerRadius, height - arrowHeight/2)];
    
    [path closePath];
    
    return path;
}

/*refactor this crap later*/
- (NSString *)getAddressDirty {
    NSString *address = self.place.formattedAddress;
    
    NSString *separator = @",";
    NSUInteger index = 9999;
    
    NSRange range;
    
    range = [self.place.formattedAddress rangeOfString:@","];
    if (range.location != NSNotFound) {
        
        if (range.location < index) {
            index = range.location;
            separator = @",";
        }
        
    }
    
    range = [self.place.formattedAddress rangeOfString:@"-"];
    if (range.location != NSNotFound) {
        
        if (range.location < index) {
            index = range.location;
            separator = @"-";
        }
    }
    
    range = [self.place.formattedAddress rangeOfString:@"."];
    if (range.location != NSNotFound) {
        
        if (range.location < index) {
            index = range.location;
            separator = @".";
        }
    }
    
    if (address.length > 20) {
        NSArray *addressComponents = [address componentsSeparatedByString:separator];
        
        if (addressComponents.count > 0) {
            address = addressComponents.firstObject;
            
            if (address.length < 5) {
                address = self.place.formattedAddress;
            }
        }
    }
    
    if (address.length > 16) {
        address = [address substringToIndex:16];
        address = [address stringByAppendingString:@"..."];
    }

    return address;
}

- (void)switchToLoadingView {
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, 0, 50, 50);
    self.center = CGPointMake(self.pinViewFrame.size.width / 2, -50 / 2);
    self.addressAndRatingLabel.hidden = true;
    self.titleLabel.hidden = true;
    [self.spinner startAnimating];
}

- (void)switchToImageView {
    self.alpha = 0.0;
    [self.spinner removeFromSuperview];
    self.titleLabel.hidden = false;
    self.addressAndRatingLabel.hidden = false;
    self.backgroundColor = [UIColor whiteColor];
}

@end
