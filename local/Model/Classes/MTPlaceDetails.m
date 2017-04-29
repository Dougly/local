#import "MTPlaceDetails.h"
#import "MTPhoto.h"

@interface MTPlaceDetails ()

// Private interface goes here.

@end

@implementation MTPlaceDetails

- (void)parseNode:(NSDictionary *)node {
    self.name = node[@"name"];
    self.rating = node[@"rating"];
    self.isOpenNow = node[@"opening_hours"][@"open_now"];
    self.lat = node[@"geometry"][@"location"][@"lat"];
    self.lon = node[@"geometry"][@"location"][@"lng"];
    self.vincinity = node[@"vincinity"];
    self.website = node[@"website"];
    self.formattedAddress = node[@"formatted_address"];
    self.localPhone = node[@"formatted_phone_number"];
    self.internationalPhone = node[@"international_phone_number"];
    
    for (NSDictionary *addressComponent in node[@"address_components"]) {
        NSArray *types = addressComponent[@"types"];
        
        if ([types containsObject:@"street_number"]) {
            self.streetNumber = addressComponent[@"long_name"];
        }
        
        if ([types containsObject:@"route"]) {
            self.streetName = addressComponent[@"long_name"];
        }
        
        if ([types containsObject:@"neighborhood"]) {
            self.neighbourhood = addressComponent[@"long_name"];
        }
        
        if ([types containsObject:@"sublocality"]) {
            self.sublocality = addressComponent[@"long_name"];
        }
        
        if ([types containsObject:@"administrative_area_level_2"]) {
            self.adminLevel2 = addressComponent[@"long_name"];
        }
    }
}

- (MTPhoto *)getLargestPhoto {
    NSUInteger maxPhotoWidth = 0;
    MTPhoto *largestPhoto = nil;
    for (MTPhoto *photo in self.photos) {
        if (photo.width.integerValue > maxPhotoWidth) {
            largestPhoto = photo;
            maxPhotoWidth = photo.width.integerValue;
        }
    }
    return largestPhoto;
}

@end
