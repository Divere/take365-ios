//
//  NSString+Extensions.m
//  take365
//
//  Created by Evgeniy Eliseev on 09/11/2016.
//  Copyright © 2016 take365. All rights reserved.
//

#import "NSString+Extensions.h"

@implementation NSString (Extensions)

- (NSDate*)dateFromyyyyMMString {
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy-MM"];
    return [df dateFromString:self];
}

-(NSDate *)dateFromyyyyMMddString {
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy-MM-dd"];
    return [df dateFromString:self];
}

@end
