#import "_MTPlaceDetails.h"

@interface MTPlaceDetails : _MTPlaceDetails
- (void)parseNode:(NSDictionary *)node;
- (MTPhoto *)getLargestPhoto;
@end
