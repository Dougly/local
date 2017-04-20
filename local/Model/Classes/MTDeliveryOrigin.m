#import "MTDeliveryOrigin.h"

@interface MTDeliveryOrigin ()

// Private interface goes here.

@end

@implementation MTDeliveryOrigin

- (void)parseNode:(NSDictionary *)node {
    self.name = node[@"name"];
    self.city = node[@"city"];
    self.address = node[@"address"];
    self.contactNumber = node[@"contact_no"];
    self.loadingInstruction = node[@"loading_site_special_instruction"];
    self.latitude = node[@"latitude"];
    self.longitude = node[@"longitude"];
}

@end
