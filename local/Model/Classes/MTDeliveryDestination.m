#import "MTDeliveryDestination.h"

@interface MTDeliveryDestination ()

// Private interface goes here.

@end

@implementation MTDeliveryDestination

- (void)parseNode:(NSDictionary *)node {
    self.name = node[@"name"];
    self.city = node[@"city"];
    self.address = node[@"address"];
    self.contactNumber = node[@"contact_no"] ;
    self.specialInstruction = node[@"well_site_special_instruction"];
    self.latitude = node[@"latitude"];
    self.longitude = node[@"longitude"];
}

@end
