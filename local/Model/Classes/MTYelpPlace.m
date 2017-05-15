#import "MTYelpPlace.h"

@interface MTYelpPlace ()

// Private interface goes here.

@end

@implementation MTYelpPlace

- (void)parseNode:(NSDictionary *)node {
    self.name = node[@"name"];
    self.rating = node[@"rating"];
    
    NSString *categoryText = @"";
    for (NSDictionary *categoryDict in node[@"categories"]) {
        categoryText = [categoryText stringByAppendingString:[NSString stringWithFormat:@"%@. ", categoryDict[@"title"]]];
    }
    
    self.categories = categoryText;
}

- (NSAttributedString *)ratingString {
    NSDictionary *filledStarAttributes = @{
                                           NSForegroundColorAttributeName: UIColorFromHex(0xff0000),
                                           NSFontAttributeName: [UIFont fontWithName:@"FontAwesome" size:14.0f]
                                           };
    
    NSDictionary *emptyStarAttributes = @{
                                           NSForegroundColorAttributeName: kLocalColor,
                                           NSFontAttributeName: [UIFont fontWithName:@"FontAwesome" size:14.0f]
                                           };
    NSAttributedString *filledStar = [[NSAttributedString alloc] initWithString:@"" attributes:filledStarAttributes];
    NSAttributedString *emptyStar = [[NSAttributedString alloc] initWithString:@"" attributes:emptyStarAttributes];
    
    int roundedRating = roundf(self.rating.floatValue);
    
    NSMutableAttributedString *ratingString = [[NSMutableAttributedString alloc] initWithString:@""];
    //5 is total number of stars
    for (int i=0; i<5; i++) {
        if (i < roundedRating)
            [ratingString appendAttributedString:filledStar];
        else
            [ratingString appendAttributedString:emptyStar];
    }
    
    return ratingString;
}

@end
