#import "MTPlace.h"

@implementation MTPlace
@dynamic title;
@dynamic coordinate;

- (void)parseNode:(NSDictionary *)node {
    self.name = node[@"name"];
    self.uniqueId = node[@"id"];
    self.placeId = node[@"place_id"];
    self.icon = node[@"icon"];
    self.reference = node[@"reference"];
    self.scope = node[@"scope"];
    self.pricingLevel = node[@"price_level"];
    self.rating = node[@"rating"];
    self.isOpenNow = node[@"opening_hours"][@"open_now"];
    
    NSArray *types = node[@"types"];
    NSString *typesString = @"";
    for (NSString *type in types) {
        typesString = [typesString stringByAppendingString:[NSString stringWithFormat:@"|%@", type]];
    }
    
    if (typesString.length > 0) {
        typesString = [typesString substringFromIndex:typesString.length - 1];
    }
    
    self.types = typesString;
    
    self.title = self.name;
    self.coordinate = CLLocationCoordinate2DMake(self.lat.floatValue, self.lon.floatValue);
}

@end
