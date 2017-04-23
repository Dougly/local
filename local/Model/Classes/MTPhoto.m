#import "MTPhoto.h"

@interface MTPhoto ()

// Private interface goes here.

@end

@implementation MTPhoto

- (void)parseNode:(NSDictionary *)node {
    self.width = node[@"width"];
    self.height = node[@"height"];
    self.reference = node[@"reference"];
    self.htmlAttributes = node[@"html_attributions"];
}


@end
