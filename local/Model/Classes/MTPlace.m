#import "MTPlace.h"

@implementation MTPlace
@synthesize title;
@synthesize coordinate;

- (void)parseNode:(NSDictionary *)node {
    self.name = node[@"name"];
    self.formattedAddress = node[@"formatted_address"];
    self.uniqueId = node[@"id"];
    self.placeId = node[@"place_id"];
    self.icon = node[@"icon"];
    self.reference = node[@"reference"];
    self.scope = node[@"scope"];
    self.pricingLevel = node[@"price_level"];
    self.rating = node[@"rating"];
    self.isOpenNow = node[@"opening_hours"][@"open_now"];
    self.lat = node[@"geometry"][@"location"][@"lat"];
    self.lon = node[@"geometry"][@"location"][@"lng"];
    self.vincinity = node[@"vincinity"];
    NSArray *types = node[@"types"];
    NSString *typesString = @"";
    for (NSString *type in types) {
        typesString = [typesString stringByAppendingString:[NSString stringWithFormat:@"%@%@", type, DELIMITER]];
    }
    
    if (typesString.length > 0) {
        typesString = [typesString substringToIndex:typesString.length - 1];
    }
    
    self.types = typesString;
    
    self.title = self.name;
    self.coordinate = CLLocationCoordinate2DMake(self.lat.floatValue, self.lon.floatValue);
}

/*refactor this crap later*/

- (NSString *)getDetailsString {
    NSString *pricing = @"";
    
    for (int i=0; i<self.pricingLevel.integerValue; i++) {
        pricing = [pricing stringByAppendingString:@"$"];
    }
    
    if (pricing.length > 0) {
        pricing = [@"  •  " stringByAppendingString:pricing];
    }
    
    NSString *type =@"Unknown type";
    NSArray *types = [self.types componentsSeparatedByString:DELIMITER];
    
    if (types > 0) {
        type = types.firstObject;
    }
    
    NSString *address = [self getAddressDirty];
    
    NSString *resultString = [NSString stringWithFormat:@"%@  •  %.1f %@  •  %@", address, self.rating.floatValue, pricing, type];
    
    return resultString;
}


- (NSString *)getAddressDirty {
    NSString *address = self.formattedAddress;
    
    NSString *separator = @",";
    NSUInteger index = 9999;
    
    NSRange range;
    
    range = [self.formattedAddress rangeOfString:@","];
    if (range.location != NSNotFound) {
        
        if (range.location < index) {
            index = range.location;
            separator = @",";
        }
        
    }
    
    range = [self.formattedAddress rangeOfString:@"-"];
    if (range.location != NSNotFound) {
        
        if (range.location < index) {
            index = range.location;
            separator = @"-";
        }
    }
    
    range = [self.formattedAddress rangeOfString:@"."];
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
                address = self.formattedAddress;
            }
        }
    }
    
    if (address.length > 16) {
        address = [address substringToIndex:16];
        address = [address stringByAppendingString:@"..."];
    }
    
    return address;
}

- (NSString *)nameQuery {
    NSArray *elements = [self.name componentsSeparatedByString:@" "];
    
    if (elements.count > 0) {
       return [self.name stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    }
    
    return self.name;
}

- (NSAttributedString *)ratingString {
    NSDictionary *filledStarAttributes = @{
                                           NSForegroundColorAttributeName: UIColorFromHex(0xff0000),
                                           NSFontAttributeName: [UIFont fontWithName:@"FontAwesome" size:14.0f]
                                           };
    
    NSDictionary *emptyStarAttributes = @{
                                          NSForegroundColorAttributeName: kLocalColor,
                                          NSFontAttributeName: [UIFont fontWithName:@"FontAwesome" size:14.0f]
                                          };
    NSAttributedString *filledStar = [[NSAttributedString alloc] initWithString:@"" attributes:filledStarAttributes];
    NSAttributedString *emptyStar = [[NSAttributedString alloc] initWithString:@"" attributes:emptyStarAttributes];
    
    int roundedRating = roundf(self.rating.floatValue);
    
    NSMutableAttributedString *ratingString = [[NSMutableAttributedString alloc] initWithString:@""];
    //5 is total number of stars
    for (int i=0; i<5; i++) {
        if (i < roundedRating)
            [ratingString appendAttributedString:filledStar];
        else
            [ratingString appendAttributedString:emptyStar];
    }
    
    return ratingString;
}

@end
