//
//  MKImageAnnotationView.m
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/23/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MKImageAnnotationView.h"
#import "MTPlace.h"
#import "MTPhoto.h"

#import "UIImageView+WebCache.h"

@implementation MKImageAnnotationView
- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    [self updateWithAnnotation:annotation];
    return self;
}

- (void)updateWithAnnotation:(id<MKAnnotation>)annotation {
    self.canShowCallout = YES;
    
    MTPhoto *photo = [((MTPlace *)annotation).photos.allObjects firstObject];
    
    NSString *strinUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=120&maxheight=120&photoreference=%@&key=%@", photo.reference, kGoogleMapAPIKey];
    NSURL *url = [NSURL URLWithString:strinUrl];
    
    UIImage *pinImage = [UIImage imageNamed:@"ic_pin"];
    self.image = pinImage;
    
    
    __weak typeof(self) weakSelf = self;
    
    NSUInteger photoWidth = 32;
    NSUInteger photoHeight = 32;
    
    NSUInteger pinWidth = pinImage.size.width;
    NSUInteger pinHeight = pinImage.size.height;
    
    [self.imageView removeFromSuperview];
    self.imageView.image = nil;
    
    self.imageView = [[UIImageView alloc] init];
    [self.imageView setImageWithURL:url
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                              CGRect  viewRect = CGRectMake((pinWidth - photoWidth) /2, (pinHeight - photoHeight)/2 - photoHeight/4, photoWidth, photoHeight);
                              UIImageView* imageView = [[UIImageView alloc] initWithFrame:viewRect];
                              dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                  UIImage *cropped = [weakSelf imageByCroppingImage:image toSize:CGSizeMake(pinWidth, pinHeight)];
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      imageView.image = cropped;
                                  });
                              });
                              imageView.contentMode = UIViewContentModeScaleAspectFit;
                              imageView.layer.cornerRadius = photoWidth / 2;
                              imageView.layer.masksToBounds = YES;
                              [weakSelf addSubview:imageView];
                          }];

}

- (UIImage *)imageByCroppingImage:(UIImage *)image toSize:(CGSize)size
{
    double newCropWidth, newCropHeight;
    
    //=== To crop more efficently =====//
    if(image.size.width < image.size.height){
        if (image.size.width < size.width) {
            newCropWidth = size.width;
        }
        else {
            newCropWidth = image.size.width;
        }
        newCropHeight = (newCropWidth * size.height)/size.width;
    } else {
        if (image.size.height < size.height) {
            newCropHeight = size.height;
        }
        else {
            newCropHeight = image.size.height;
        }
        newCropWidth = (newCropHeight * size.width)/size.height;
    }
    //==============================//
    
    double x = image.size.width/2.0 - newCropWidth/2.0;
    double y = image.size.height/2.0 - newCropHeight/2.0;
    
    CGRect cropRect = CGRectMake(x, y, newCropWidth, newCropHeight);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

@end
