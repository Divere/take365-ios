//
//  ApiTableViewController.m
//  take365
//
//  Created by Evgeniy Eliseev on 28/06/16.
//  Copyright © 2016 take365. All rights reserved.
//

#import "ApiTableViewController.h"

@interface ApiTableViewController ()

@end

@implementation ApiTableViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _TakeApi = [AppDelegate getInstance].api;
        
        _TakeApi.EventInvalidAuthToken = ^(){
            NSLog(@"Auth failed, relog");
            
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                                 bundle:nil];
            UIViewController *add =
            [storyboard instantiateViewControllerWithIdentifier:@"begin"];
            
            [self presentViewController:add
                               animated:YES
                             completion:nil];
        };
    }
    return self;
}

@end
