//
//  NSDate+Extensions.m
//  take365
//
//  Created by Evgeniy Eliseev on 08/11/2016.
//  Copyright © 2016 take365. All rights reserved.
//

#import "NSDate+Extensions.h"

@implementation NSDate (Extensions)

- (NSDate *)setZeroTime {
    NSDate *date = self;
    NSUInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:currentCalendar.calendarIdentifier];
    calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDateComponents* components = [calendar components:flags fromDate:date];
    
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.day = 1;
    
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:[calendar dateFromComponents:components] options:0];
}

+ (NSDate *)getToday {
    NSDate *date = [NSDate new];
    NSUInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:currentCalendar.calendarIdentifier];
    calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDateComponents* components = [calendar components:flags fromDate:date];
    
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.day = 1;
    
    return [calendar dateFromComponents:components];
}

@end
