#import "MTYelpUser.h"

@interface MTYelpUser ()

// Private interface goes here.

@end

@implementation MTYelpUser

- (void)parseNode:(NSDictionary *)node {
    self.bearer = node[@"access_token"];
}

@end
