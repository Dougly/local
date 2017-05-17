//
//  MTAnalytics.h
//  Local
//
//  Created by Rostyslav Stepanyak on 5/17/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const evClickFilterItem;
extern NSString *const evClickMapAnnotation;
extern NSString *const evClickMapCluster;
extern NSString *const evClickMapPopup;
extern NSString *const evClickListItem;
extern NSString *const evClickAutoCompletePlace;

extern NSString *const evScreenMapView;
extern NSString *const evScreenListView;
extern NSString *const evScreenFilterView;
extern NSString *const evScreenLocationView;
extern NSString *const evScreenProfile;

@interface MTAnalytics : NSObject

+ (instancetype)sharedAnalytics;

- (void)logClickEvent:(NSString *)eventName info:(NSString *)info;

- (void)logStartScreen:(NSString *)screenName;
- (void)logEndScreen:(NSString *)screenName;

@end
