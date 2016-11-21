//
//  Take365ViewController.h
//  take365
//
//  Created by Evgeniy Eliseev on 17/11/2016.
//  Copyright © 2016 take365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface UIViewController (Api)

@property (nonatomic) UIAlertController* alertController;
@property (nonatomic) Take365Service *TakeApi;

- (Take365Service*)getTake365Api;
- (void)showProgressDialogWithMessage:(NSString*)message;
-(void)hideProgressDialogWithCompletion: (void (^ __nullable)(void))completion;

@end
