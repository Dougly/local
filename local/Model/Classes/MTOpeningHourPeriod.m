#import "MTOpeningHourPeriod.h"

@interface MTOpeningHourPeriod ()

// Private interface goes here.

@end

@implementation MTOpeningHourPeriod

- (void)parseNode:(NSDictionary *)node {
    self.closeDay = node[@"close"][@"day"];
    self.closeTime = node[@"close"][@"time"];
    
    self.openDay = node[@"open"][@"day"];
    self.openTime = node[@"open"][@"time"];
    
    self.periodNumber = node[@"open"][@"day"];
}

@end
