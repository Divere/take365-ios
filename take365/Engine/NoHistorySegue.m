//
//  NoHistorySegue.m
//  take365
//
//  Created by Evgeniy Eliseev on 18.02.16.
//  Copyright © 2016 take365. All rights reserved.
//

#import "NoHistorySegue.h"

@implementation NoHistorySegue

-(void)perform {
    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];
    UINavigationController *navigationController = sourceViewController.navigationController;
    // Pop to root view controller (not animated) before pushing
    [navigationController popToRootViewControllerAnimated:NO];
    [navigationController pushViewController:destinationController animated:YES];
}

@end
