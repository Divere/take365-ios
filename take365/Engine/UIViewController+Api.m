//
//  Take365ViewController.m
//  take365
//
//  Created by Evgeniy Eliseev on 17/11/2016.
//  Copyright © 2016 take365. All rights reserved.
//

#import "UIViewController+Api.h"
#import <objc/runtime.h>

static void * alertControllerPropertyKey = &alertControllerPropertyKey;
static void * takeApiPropertyKey = &takeApiPropertyKey;
static Take365Service *takeApi;

@implementation UIViewController (Api)

-(void)setTakeApi:(Take365Service *)TakeApi {
    takeApi = TakeApi;
}

-(Take365Service*)TakeApi {
    return takeApi;
}

-(void)setAlertController:(UIAlertController *)alertController {
    objc_setAssociatedObject(self, alertControllerPropertyKey, alertController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIAlertController*)alertController {
    return objc_getAssociatedObject(self, alertControllerPropertyKey);
}

- (Take365Service*)getTake365Api {
    if(takeApi == NULL) {
        takeApi = [Take365Service new];
    }
    
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
        
        if(self.alertController != NULL && [self.alertController isBeingPresented]) {
            [self.alertController dismissViewControllerAnimated:NO completion:^{
                [self showMessageDialogWithMessage:message];
            }];
            return;
        }
        
        [self showMessageDialogWithMessage:message];
    };
    
    return takeApi;
}

-(void)showMessageDialogWithMessage:(NSString*) message {
    self.alertController = [UIAlertController alertControllerWithTitle:@""
                                                               message:message
                                                        preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Продолжить" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self.alertController dismissViewControllerAnimated:YES completion:NULL];
    }];
    
    [self.alertController addAction:defaultAction];
    [self presentViewController:self.alertController animated:YES completion:nil];
}

-(void)showProgressDialogWithMessage:(NSString *)message {
    self.alertController = [UIAlertController alertControllerWithTitle:@""
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:self.alertController animated:YES completion:nil];
}

-(void)hideProgressDialogWithCompletion: (void (^ __nullable)(void))completion {
    if(self.alertController && [self.alertController isBeingPresented]) {
        [self.alertController dismissViewControllerAnimated:NULL completion:completion];
    }
}

@end
