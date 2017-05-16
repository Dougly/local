#import "_MTOpeningHourPeriod.h"

@interface MTOpeningHourPeriod : _MTOpeningHourPeriod
- (void)parseNode:(NSDictionary *)node;
- (NSString *)openPmTime;
- (NSString *)closePmTime;
@end
