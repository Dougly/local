#import "MTDeliveryDetails.h"

@interface MTDeliveryDetails ()

// Private interface goes here.

@end

@implementation MTDeliveryDetails

- (void)parseNode:(NSDictionary *)node {
    self.orderId = node[@"order_id"];
    self.type = node[@"sand_type"];
    self.weight = node[@"weight"];
    self.po = node[@"po"];
    self.mileage = node[@"mileage"];
    self.mt = node[@"mt"];
    self.status = node[@"status"];
}

@end
