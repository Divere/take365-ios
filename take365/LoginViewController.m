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
{
    ApiManager *api;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    api = [self getTake365Api];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    if(accessToken != NULL){
        api.AccessToken = accessToken;
        [api loginWithAccessTokenAndResultBlock:^(LoginResult *result, NSString *error) {
            if(!error){
                 [self performSegueWithIdentifier:@"SEGUE_LOGIN_COMPLETED" sender:self];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnLoginClicked:(id)sender {
    [self showProgressDialogWithMessage:@"Входим..."];
    [[self getTake365Api] loginWithUsername:_tfLogin.text AndPassword:_tfPassword.text AndResultBlock:^(LoginResult *result, NSString *error) {
        if(error == NULL){
            [[NSUserDefaults standardUserDefaults] setObject:result.token forKey:@"accessToken"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self performSegueWithIdentifier:@"SEGUE_LOGIN_COMPLETED" sender:self];
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
