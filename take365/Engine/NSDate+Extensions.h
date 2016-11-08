//
//  NSDate+Extensions.h
//  take365
//
//  Created by Evgeniy Eliseev on 08/11/2016.
//  Copyright © 2016 take365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extensions)

- (NSString*)toyyyyMMString;
- (NSString *)toyyyyMMddString;
- (NSDate*)setZeroTime;
+ (NSDate*)getToday;

@end
