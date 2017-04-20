#import "MTProfile.h"

@interface MTProfile ()

// Private interface goes here.

@end

@implementation MTProfile

- (void)parseNode:(NSDictionary *)node {
    self.name = node[@"name"];
    self.email = node[@"email"];
    self.contactNumber = node[@"contact_no"];
    self.carrierName = node[@"carrier_name"];
    self.truckNumber = node[@"truck_no"];
    self.trailerNumer = node[@"trailer_no"];
    self.licenseUrl = node[@"license_no"];
    
    NSString *certs = @"";
    for (NSDictionary *certificateDict in node[@"certificate"]) {
        certs = [certs stringByAppendingString: [NSString stringWithFormat:@"%@,", certificateDict[@"certificate"]]];
    }
    
    if ([certs length] > 0) {
        certs = [certs substringToIndex:[certs length] - 1];
    } 
    self.certificates = certs;
}

@end
