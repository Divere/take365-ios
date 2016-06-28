//
//  ApiViewController.m
//  take365
//
//  Created by Evgeniy Eliseev on 28/06/16.
//  Copyright © 2016 take365. All rights reserved.
//

#import "ApiViewController.h"

@interface ApiViewController ()

@end

@implementation ApiViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _TakeApi = [AppDelegate getInstance].api;
        
        _TakeApi.EventInvalidAuthToken = ^(){
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accessToken"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            dispatch_async(dispatch_get_main_queue(), ^()
                           {
                               UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                                                    bundle:nil];
                               UIViewController *add =
                               [storyboard instantiateViewControllerWithIdentifier:@"login"];
                               
                               [self presentViewController:add
                                                  animated:YES
                                                completion:nil];
                           });
        };
    }
    
    return self;
}

@end
