//
//  ApiViewController.m
//  take365
//
//  Created by Evgeniy Eliseev on 28/06/16.
//  Copyright © 2016 take365. All rights reserved.
//

#import "Take365ViewController.h"

@interface Take365ViewController ()

@end

@implementation Take365ViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _TakeApi = [self getTake365Api];
    }
    
    return self;
}

@end
