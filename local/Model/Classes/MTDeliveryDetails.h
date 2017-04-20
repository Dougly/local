#import "_MTDeliveryDetails.h"

typedef enum {
    DELIVERY_STATUS_ACCEPTED = 2,
    DELIVERY_STATUS_DEPARTED_FROM_LOADING_SITE = 3,
    DELIVERY_STATUS_ARRIVED_AT_LOADING_SITE = 5,
    DELIVERY_STATUS_ARRIVED_AT_WELL_SITE = 6,
} DELIVERY_STATUS;

@interface MTDeliveryDetails : _MTDeliveryDetails
- (void)parseNode:(NSDictionary *)node;
@end
