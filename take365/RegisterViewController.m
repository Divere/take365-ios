//
//  RegisterViewController.m
//  take365
//
//  Created by Evgeniy Eliseev on 11.02.16.
//  Copyright © 2016 take365. All rights reserved.
//

#import "RegisterViewController.h"
#import "AppDelegate.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = YES;
    
    self.title = @"Регистрация";
    self.navigationController.title = @"Регистрация";
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    [_tfLogin becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 3:
            tableView.allowsSelection = NO;
            [self.TakeApi registerWithUsername:_tfLogin.text Email:_tfEmail.text Password:_tfPassword.text AndResultBlock:^(RegisterResult *result, NSString *error) {
                if(error == NULL){
                    [self.TakeApi loginWithUsername:_tfLogin.text AndPassword:_tfPassword.text AndResultBlock:^(LoginResult *result, NSString *error) {
                        if(error == NULL){
                            [[NSUserDefaults standardUserDefaults] setObject:result.token forKey:@"accessToken"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            [self performSegueWithIdentifier:@"SEGUE_LOGIN_COMPLETED" sender:self];
                        }else{
                            UIAlertView *uav = [[UIAlertView new] initWithTitle:@"Ошибка входа" message:error delegate:nil cancelButtonTitle:@"Закрыть" otherButtonTitles:nil, nil];
                            [uav show];
                        }
                    }];
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        tableView.allowsSelection = YES;
                    });
                    
                    UIAlertView *uav = [[UIAlertView new] initWithTitle:@"Ошибка регистрации" message:error delegate:nil cancelButtonTitle:@"Закрыть" otherButtonTitles:nil, nil];
                    [uav show];
                }
            }];
            break;
    }
}

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
