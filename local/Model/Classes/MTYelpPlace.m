#import "MTYelpPlace.h"

@interface MTYelpPlace ()

// Private interface goes here.

@end

@implementation MTYelpPlace

- (void)parseNode:(NSDictionary *)node {
    self.name = node[@"name"];
    self.rating = node[@"rating"];
}

- (NSString *)ratingString {
    NSString *filledStar = @"";
    NSString *emptyStar = @"";
    
    int roundedRating = roundf(self.rating.floatValue);
    
    NSString *ratingString = @"";
    //5 is total number of stars
    for (int i=0; i<5; i++) {
        if (i < roundedRating)
            ratingString = [ratingString stringByAppendingString:filledStar];
        else
            ratingString = [ratingString stringByAppendingString:emptyStar];
    }
    
    return ratingString;
}

@end
