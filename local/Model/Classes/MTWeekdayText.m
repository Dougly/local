#import "MTWeekdayText.h"

@interface MTWeekdayText ()

// Private interface goes here.

@end

@implementation MTWeekdayText

- (void)parseNode:(NSString *)text day:(NSUInteger)dayNumber {
    self.name = text;
    self.day = @(dayNumber);
}


@end
