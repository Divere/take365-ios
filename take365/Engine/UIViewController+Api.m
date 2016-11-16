//
//  Take365ViewController.m
//  take365
//
//  Created by Evgeniy Eliseev on 17/11/2016.
//  Copyright © 2016 take365. All rights reserved.
//

#import "UIViewController+Api.h"

@implementation UIViewController (Api)

- (ApiManager*)getTake365Api {
    ApiManager *takeApi = [AppDelegate getInstance].api;
    
    takeApi.EventInvalidAuthToken = ^(){
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
    
    takeApi.EventApiErrorOccured = ^(NSString *message) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Продолжить" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [alert dismissViewControllerAnimated:YES completion:NULL];
        }];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    };
    
    return takeApi;
}

-(void)showProgressDialogWithMessage:(NSString *)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Продолжить" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [alert dismissViewControllerAnimated:YES completion:NULL];
    }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
