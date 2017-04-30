#import "MTOpeningHourPeriod.h"

@interface MTOpeningHourPeriod ()

// Private interface goes here.

@end

@implementation MTOpeningHourPeriod

- (void)parseNode:(NSDictionary *)node periodNumber:(NSUInteger)periodNumber{
    self.closeDay = node[@"close"][@"day"];
    self.closeTime = node[@"close"][@"time"];
    
    self.openDay = node[@"open"][@"day"];
    self.openTime = node[@"open"][@"time"];
    
    self.periodNumber = @(periodNumber);
}

@end
