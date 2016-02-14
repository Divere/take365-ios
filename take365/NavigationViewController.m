//
//  NavigationViewController.m
//  take365
//
//  Created by Evgeniy Eliseev on 28.01.16.
//  Copyright © 2016 take365. All rights reserved.
//

#import "NavigationViewController.h"
#import "SelectStoryViewController.h"
#import "StoryViewController.h"

static NavigationViewController *instance;

@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    instance = self;
    // Do any additional setup after loading the view.
}

-(BOOL)shouldAutorotate{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(NavigationViewController *)getInstance{
    return instance;
}

-(void)navigateToStory:(StoryModel *)story{
    [self setSelectedIndex:0];
    UINavigationController *nav = self.viewControllers[0];
    SelectStoryViewController *ssvc = nav.viewControllers[0];
    ssvc.SelectedStory = story;
    [ssvc performSegueWithIdentifier:@"SEGUE_SHOW_STORY" sender:nav];
}

#pragma mark - Navigation

//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}

@end
