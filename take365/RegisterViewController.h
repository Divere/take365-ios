//
//  RegisterViewController.h
//  take365
//
//  Created by Evgeniy Eliseev on 11.02.16.
//  Copyright © 2016 take365. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *tfLogin;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;

@end
