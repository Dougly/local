#import "MTUser.h"

@interface MTUser ()

// Private interface goes here.

@end

@implementation MTUser

- (void)parseNode:(NSDictionary *)node {
    self.accessToken = node[@"data"][@"accessToken"] ;
}

@end
