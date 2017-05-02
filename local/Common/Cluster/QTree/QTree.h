//
// This file is subject to the terms and conditions defined in
// file 'LICENSE.md', which is part of this source code package.
//

@import CoreLocation;
@import MapKit;

#import "QTreeInsertable.h"

@interface QTree : NSObject
@property(nonatomic, readonly) NSUInteger count;
- (void)cleanup;
- (void)insertObject:(id<QTreeInsertable>)insertableObject;
- (BOOL)removeObject:(id<QTreeInsertable>)insertableObject;
- (NSArray *)getObjectsInRegion:(MKCoordinateRegion)region
            minNonClusteredSpan:(CLLocationDegrees)span
                   fillClusters:(BOOL)fillClusters;
- (NSArray *)getObjectsInRegion:(MKCoordinateRegion)region
            minNonClusteredSpan:(CLLocationDegrees)span;
// Returned array is sorted from the least to the most distant
- (NSArray *)neighboursForLocation:(CLLocationCoordinate2D)location
                        limitCount:(NSUInteger)limit;

@end
