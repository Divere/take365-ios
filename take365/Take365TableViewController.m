//
//  Take365TableViewController.m
//  take365
//
//  Created by Evgeniy Eliseev on 17/11/2016.
//  Copyright © 2016 take365. All rights reserved.
//

#import "Take365TableViewController.h"

@implementation Take365TableViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _TakeApi = [self getTake365Api];
    }
    
    return self;
}

@end
