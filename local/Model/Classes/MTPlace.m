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

@end