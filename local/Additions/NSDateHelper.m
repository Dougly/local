//
//  NSDateHelper.m
//
//  Created by Steven Koposov on 05/6/16.
//  Copyright (c) 2016 Steven Koposov . All rights reserved.
//

#import "NSCalendarHelper.h"
#import "NSDateHelper.h"

@implementation NSDateHelper

+ (NSDate *)nsdateStartOfToDay {
    NSCalendar *cal = [[NSCalendar alloc]
                       initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components =
    [cal components:(NSCalendarUnitHour | NSCalendarUnitMinute |
                     NSCalendarUnitSecond)
           fromDate:[[NSDate alloc] init]];
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateByAddingComponents:components
                                         toDate:[[NSDate alloc] init]
                                        options:0];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    
    return
    [today dateByAddingTimeInterval:[timeZone secondsFromGMTForDate:today]];
}

+ (NSDate *)nsdateStartOfThisMonth {
    NSCalendar *cal = [[NSCalendar alloc]
                       initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components =
    [cal components:(NSCalendarUnitHour | NSCalendarUnitMinute |
                     NSCalendarUnitSecond)
           fromDate:[[NSDate alloc] init]];
    NSDate *startingDate;
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    NSDate *today = [cal dateByAddingComponents:components
                                         toDate:[[NSDate alloc] init]
                                        options:0];
    NSInteger thisMonth =
    [cal components:NSCalendarUnitMonth fromDate:today].month;
    // Find the starting date of the month and how many days in that month
    [components setYear:2014];
    [components setMonth:thisMonth];
    [components setDay:1];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    startingDate = [cal dateFromComponents:components];
    startingDate = [startingDate
                    dateByAddingTimeInterval:[timeZone secondsFromGMTForDate:startingDate]];
    
    return startingDate;
}

+ (NSDate *)dateFromString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    return [dateFormatter dateFromString:dateString];
}

+ (NSString *)timeRemainingUntilDate:(NSDate *)date {
    if (date == nil) {
        return @"";
    }
    NSTimeInterval interval = [date timeIntervalSinceNow];
    NSString *timeRemaining = nil;
    
    if (interval > 0) {
        
        div_t d = div(interval, 86400);
        int day = d.quot;
        
        NSString *nbday = nil;
        if (day > 1)
            nbday = @"days";
        else if (day == 1)
            nbday = @"day";
        else
            nbday = @"";
        timeRemaining =
        [NSString stringWithFormat:@"%@ %@", day ? @(day) : @"", nbday];
    } else
        timeRemaining = @"Expire";
    
    return timeRemaining;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    [dateFormatter stringFromDate:date];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateFromStringWithTimeZone:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    return [dateFormatter dateFromString:dateString];
}

+ (NSDate *)dateFromStringWithTimeZoneForSecondsFromGMT:(NSString *)dateString
                                             withFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDate *date = [dateFormatter dateFromString:dateString];
    dateFormatter.timeZone = [NSTimeZone
                              timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    NSString *localDateString = [dateFormatter stringFromDate:date];
    return [dateFormatter dateFromString:localDateString];
}

+ (NSDate *)dateFromStringWithoutTimeZone:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    if (!date) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        date = [dateFormatter dateFromString:dateString];
    }
    if (!date) {
        NSDateFormatter *dtFormatter = [[NSDateFormatter alloc] init];
        [dtFormatter setLocale:[NSLocale systemLocale]];
        [dtFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        date = [dtFormatter dateFromString:dateString];
    }
    
    if (!date) {
        NSDateFormatter *dtFormatter = [[NSDateFormatter alloc] init];
        [dtFormatter setLocale:[NSLocale systemLocale]];
        [dtFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        date = [dtFormatter dateFromString:dateString];
    }
    
    return date;
}

+ (NSDate *)dateFromStringLocaleZone:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    if (!date) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        date = [dateFormatter dateFromString:dateString];
    }
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    return date;
}

+ (NSDate *)mdDateFromString:(NSString *)string format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter dateFromString:string];
}

+ (NSDate *)mdDateWithYear:(NSInteger)year
                     month:(NSInteger)month
                       day:(NSInteger)day {
    NSCalendar *calendar = [NSCalendarHelper mdSharedCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year;
    components.month = month;
    components.day = day;
    return [calendar dateFromComponents:components];
}

+ (BOOL)prefers24Hour {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
    NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
    BOOL is24h =
    (amRange.location == NSNotFound && pmRange.location == NSNotFound);
    //[formatter release];
    return is24h;
}

@end
