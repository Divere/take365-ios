//
//  InitialViewController.m
//  take365
//
//  Created by Evgeniy Eliseev on 22/11/2016.
//  Copyright © 2016 take365. All rights reserved.
//

#import "InitialViewController.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    if(accessToken != NULL){
        self.TakeApi.EventInvalidAuthToken = ^() {
            [self performSegueWithIdentifier:@"AUTOLOGIN_FAILED" sender:self];
        };
        self.TakeApi.AccessToken = accessToken;
        [self.TakeApi loginWithAccessTokenAndResultBlock:^(LoginResult *result, NSString *error) {
            if(!error){
                [self performSegueWithIdentifier:@"AUTOLOGIN_COMPLETED" sender:self];
            }
        }];
    } else {
        [self performSegueWithIdentifier:@"AUTOLOGIN_FAILED" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
