#import "_MTPlace.h"
#import "QTreeInsertable.h"
@import MapKit;


@interface MTPlace : _MTPlace
@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
- (void)parseNode:(NSDictionary *)node;
@end
