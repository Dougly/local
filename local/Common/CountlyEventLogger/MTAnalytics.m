//
//  MTAnalytics.m
//  Local
//
//  Created by Rostyslav Stepanyak on 5/17/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MTAnalytics.h"
#import "Countly.h"

NSString *const evClickFilterItem = @"click_filteritem";
NSString *const evClickMapAnnotation = @"click_mapannotation";
NSString *const evClickMapCluster = @"click_mapcluster";
NSString *const evClickMapPopup = @"click_mappopup";
NSString *const evClickListItem = @"click_list_item";
NSString *const evClickAutoCompletePlace = @"click_autocomplete_place";


NSString *const evScreenMapView = @"screen_mapview";
NSString *const evScreenListView = @"screen_listview";
NSString *const evScreenFilterView = @"screen_filterview";
NSString *const evScreenLocationView = @"screen_locationview";
NSString *const evScreenProfile = @"screen_profile";

@implementation MTAnalytics

+ (instancetype)sharedAnalytics {
    static MTAnalytics *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (void)logClickEvent:(NSString *)eventName info:(NSString *)info {
    [[Countly sharedInstance] recordEvent:eventName segmentation:@{@"data" : info}];
}

- (void)logStartScreen:(NSString *)eventName {
    [[Countly sharedInstance] startEvent:eventName];
}

- (void)logEndScreen:(NSString *)eventName {
    [[Countly sharedInstance] endEvent:eventName];
}

@end
