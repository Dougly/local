#import "MTPreviousVehicle.h"

@interface MTPreviousVehicle ()

// Private interface goes here.

@end

@implementation MTPreviousVehicle

- (void)parseNode:(NSDictionary *)node {
    self.truckNumber = node[@"data"][@"truck_no"];
    self.trailerNumber = node[@"data"][@"trailer_number"];
}

@end
