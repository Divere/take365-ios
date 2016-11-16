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

- (ApiManager*)getTake365Api;

- (void)showProgressDialogWithMessage:(NSString*)message;

@end
