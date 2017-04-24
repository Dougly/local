#import "MTPlaceReview.h"

@interface MTPlaceReview ()

// Private interface goes here.

@end

@implementation MTPlaceReview

- (void)parseNode:(NSDictionary *)node {
    self.type = [node[@"aspects"] firstObject][@"type"];
    self.rating = node[@"rating"];
    self.authorName = node[@"author_name"];
    self.authorAvatarUrl = node[@"profile_photo_url"];
    self.relativeTimeDescription = node[@"relative_time_description"];
    self.text = node[@"text"];
    self.language = node[@"languae"];
    self.time = node[@"time"];
}

@end
