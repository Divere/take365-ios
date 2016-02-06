//
//  LoginViewController.h
//  take365
//
//  Created by Evgeniy Eliseev on 27.10.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMBaseViewController.h"

@interface LoginViewController : PMBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *tfLogin;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;

@end
