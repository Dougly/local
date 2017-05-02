//
//  NSDateHelper.h
//
//  Created by Steven Koposov on 05/6/16.
//  Copyright (c) 2016 Steven Koposov . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "time.h"

NS_ASSUME_NONNULL_BEGIN
@interface NSDateHelper : NSObject
+ (nullable NSDate *)mdDateFromString:(NSString *)string format:(NSString *)format;
+ (nullable NSDate *)mdDateWithYear:(NSInteger)year
                              month:(NSInteger)month
                                day:(NSInteger)day;
+ (BOOL)prefers24Hour;

+ (NSDate *)nsdateStartOfToDay;
+ (NSDate *)nsdateStartOfThisMonth;
+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSString *)timeRemainingUntilDate:(NSDate *)date;
+ (NSDate *)dateFromStringWithTimeZone:(NSString *)dateString;
+ (NSDate *)dateFromStringWithoutTimeZone:(NSString *)dateString;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format;
+ (NSDate *)dateFromStringWithTimeZoneForSecondsFromGMT:(NSString *)dateString
                                             withFormat:(NSString *)format;
+ (NSDate *)dateFromStringLocaleZone:(NSString *)dateString;

@end
NS_ASSUME_NONNULL_END