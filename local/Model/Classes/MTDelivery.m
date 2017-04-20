#import "MTDelivery.h"

@interface MTDelivery ()

// Private interface goes here.

@end

@implementation MTDelivery

- (void)parseNode:(NSDictionary *)node {
    NSArray *pickupObjects = node[@"data"][@"pickUpBw"];
    NSDictionary *pickupTimeDict = pickupObjects.firstObject;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy' 'HH:mm:ss"];
    self.pickupTime = [formatter dateFromString:pickupTimeDict[@"expected_pickup_time"]];
    
    NSArray *deliveryTimeObjects = node[@"data"][@"deliveryTime"];
    NSDictionary *deliveryTimeDict = deliveryTimeObjects.firstObject;
    
    self.expectedDeliveryTime = [formatter dateFromString:deliveryTimeDict[@"unload_appt"]];
}

@end
