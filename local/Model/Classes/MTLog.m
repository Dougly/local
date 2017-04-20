#import "MTLog.h"

@interface MTLog ()

// Private interface goes here.

@end

@implementation MTLog

- (void)parseNode:(NSDictionary *)node
        isPresent:(BOOL)isPresent {
    self.isPresent = @(isPresent);
    self.jobId = node[@"job_id"];
    self.orderId = node[@"order_id"];
    self.status = node[@"status"];
    self.sandTicketNumber = node[@"sand_ticket_no"];
    self.loadingSiteName = node[@"loading_site_name"];
    self.loadingSiteAddress = node[@"loading_site_address"];
    self.wellSiteName = node[@"well_site_name"];
    self.wellSiteAddress = node[@"well_site_address"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if (isPresent) {
       [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        
        self.loadingSiteLatitude = node[@"loading_site_latitude"];
        self.loadingSiteLongitude = node[@"loading_site_longitude"];
        self.wellSiteLatitude = node[@"well_site_latitude"];
        self.wellSiteLongitude = node[@"well_site_longitude"];
    }
    self.loadArrivalDate = [formatter dateFromString:node[@"load_arrival"]];
    self.wellDepartDate = [formatter dateFromString:node[@"well_depart"]];
}

@end
