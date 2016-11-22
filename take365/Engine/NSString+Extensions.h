//
//  NSString+Extensions.h
//  take365
//
//  Created by Evgeniy Eliseev on 09/11/2016.
//  Copyright © 2016 take365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extensions)

- (NSDate*)dateFromyyyyMMString;
- (NSDate*)dateFromyyyyMMddString;

@end
