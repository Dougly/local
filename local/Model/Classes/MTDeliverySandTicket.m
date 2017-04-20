#import "MTDeliverySandTicket.h"

@interface MTDeliverySandTicket ()

// Private interface goes here.

@end

@implementation MTDeliverySandTicket

- (void)parseNode:(NSDictionary *)node {
    self.url = node[@"sand_ticket"];
}

@end
