//
//  NSIndexPath+Extensions.m
//  take365
//
//  Created by Evgeniy Eliseev on 23/11/2016.
//  Copyright © 2016 take365. All rights reserved.
//

#import "NSIndexPath+Extensions.h"
#import <objc/runtime.h>

@implementation NSIndexPath (Extensions)

-(NSString *)toKeyString {
    return [NSString stringWithFormat:@"%ld-%ld", (long)[self valueForKey:@"section"], (long)[self valueForKey:@"row"]];
}

@end
