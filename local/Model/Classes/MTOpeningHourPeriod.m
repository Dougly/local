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

- (NSString *)openPmTime {
    NSMutableString *openText = [NSMutableString stringWithString:self.openTime];
    [openText insertString:@":" atIndex:2];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    NSDate *openTimeDate = [dateFormatter dateFromString:openText];
    
    dateFormatter.dateFormat = @"hha";
    NSString *openTimePMString = [dateFormatter stringFromDate:openTimeDate];
    
    return openTimePMString;
}

- (NSString *)closePmTime {
    NSMutableString *closeText = [NSMutableString stringWithString:self.closeTime];
    [closeText insertString:@":" atIndex:2];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    NSDate *closeTimeDate = [dateFormatter dateFromString:closeText];
    
    dateFormatter.dateFormat = @"hha";
    NSString *closeTimePMString = [dateFormatter stringFromDate:closeTimeDate];
    
    return closeTimePMString;
}

@end
