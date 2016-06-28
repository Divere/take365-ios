//
//  CreateStoryViewController.m
//  take365
//
//  Created by Evgeniy Eliseev on 23.01.16.
//  Copyright © 2016 take365. All rights reserved.
//

#import "CreateStoryViewController.h"
#import "AppDelegate.h"

@interface CreateStoryViewController ()

@end

@implementation CreateStoryViewController
{
    UIColor *greenColor;
    StoryModel *createdStory;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_tfTitle becomeFirstResponder];
    greenColor = [_scPrivacyLevel.tintColor copy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
        case 1:
            return 35;
         default:
            return 1;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.TakeApi createStoryWithTitle:_tfTitle.text PrivateLevel:(StoryPrivateLevel)_scPrivacyLevel.selectedSegmentIndex Description:_tfDescription.text AndResultBlock:^(StoryModel *result, NSString *error) {
        if(error == NULL){
            createdStory = result;
            [self performSegueWithIdentifier:@"SEGUE_SHOW_NEW_STORY" sender:self];
            [self.TakeApi getStoryListWithResultBlock:NULL];
        }
    }];
}

- (IBAction)privacyValueChanged:(id)sender {
    UISegmentedControl *sc = sender;
    switch (sc.selectedSegmentIndex) {
        case 0:
            sc.tintColor = [UIColor redColor];
            break;
        case 1:
            sc.tintColor = greenColor;
            break;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"SEGUE_SHOW_NEW_STORY"]){
        [segue.destinationViewController setValue:createdStory forKey:@"Story"];
    }
}

@end
