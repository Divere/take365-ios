//
//  LoginViewController.m
//  take365
//
//  Created by Evgeniy Eliseev on 27.10.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnLoginClicked:(id)sender {
    [self dismissKeyboard];
    [self showProgressDialogWithMessage:@"Входим..."];
    [self.TakeApi loginWithUsername:_tfLogin.text AndPassword:_tfPassword.text AndResultBlock:^(LoginResult *result, NSString *error) {
        if(error == NULL){
            [self hideProgressDialogWithCompletion:^{
                [[NSUserDefaults standardUserDefaults] setObject:result.token forKey:@"accessToken"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self performSegueWithIdentifier:@"SEGUE_LOGIN_COMPLETED" sender:self];
            }];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
