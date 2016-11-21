//
//  SelectStoryViewController.m
//  take365
//
//  Created by Evgeniy Eliseev on 01.12.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import "StoriesListViewController.h"
#import "StoryCellTableViewCell.h"
#import "AppDelegate.h"

@import KCFloatingActionButton;

@interface StoriesListViewController () <KCFloatingActionButtonDelegate>
{
    NSArray<StoryModel> *stories;
}
@end

@implementation StoriesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.title = @"Мои истории";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" + " style:UIBarButtonItemStyleDone target:self action:@selector(newStory)];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(newStory)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Profile"] style:UIBarButtonItemStylePlain target:self action:@selector(openProfileSettings)];
    
    KCFloatingActionButton *fab = [[KCFloatingActionButton alloc] init];
    fab.buttonColor = [UIColor redColor];
    fab.plusColor = [UIColor whiteColor];
    fab.fabDelegate = self;
    [self.view addSubview:fab];
    
    if(self.TakeApi.Stories != NULL){
        stories = self.TakeApi.Stories;
    }
}


-(void)emptyKCFABSelected:(KCFloatingActionButton *)fab {
    [self newStory];
}

-(void)viewDidAppear:(BOOL)animated{
    [self.TakeApi getStoryListWithResultBlock:^(NSArray<StoryModel> *result, NSString *error) {
        if(error == nil){
            stories = result;
            [self.tableView reloadData];
        }
    }];
}

-(void)openProfileSettings {
    [self performSegueWithIdentifier:@"SEGUE_PROFILE" sender:self];
}

-(void)newStory{
    [self performSegueWithIdentifier:@"SEGUE_CREATE_STORY" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(stories.count < 1){
        return 1;
    }
    return stories.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(stories != NULL && stories.count < 1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateNewStoryCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = [UIView new];
        cell.selectedBackgroundView = [UIView new];
        [cell.selectedBackgroundView setOpaque:YES];
        cell.selectedBackgroundView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5f];
        return cell;
    }
    else if(stories != NULL && stories.count >= 1){
        StoryModel *model = [stories objectAtIndex:indexPath.row];
        StoryCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoryCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = [UIView new];
        cell.selectedBackgroundView = [UIView new];
        [cell.selectedBackgroundView setOpaque:YES];
        cell.selectedBackgroundView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5f];
        cell.lblStoryName.text = (model.title != NULL) ? model.title : @"Без названия";
        cell.lblCompleted.text = [[NSString alloc] initWithFormat:@"%d из %d (%.2f%@)", model.progress.totalImages, model.progress.totalDays, model.progress.percentsComplete, @"%"];
        if(model.progress.percentsComplete == 100){
            cell.lblCompleted.textColor = [UIColor greenColor];
        }
        return cell;
    }
    else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LoadingStoriesCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = [UIView new];
        cell.selectedBackgroundView = [UIView new];
        return cell;
    }
    return NULL;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([cell.reuseIdentifier isEqualToString:@"StoryCell"]){
        _SelectedStory = [stories objectAtIndex:self.tableView.indexPathForSelectedRow.row];
//        if(indexPath.row == 1){
//            _SelectedStory.id = 162;
//        }
        [self performSegueWithIdentifier:@"SEGUE_SHOW_STORY" sender:self];
    }else if([cell.reuseIdentifier isEqualToString:@"CreateNewStoryCell"]){
        [self performSegueWithIdentifier:@"SEGUE_CREATE_STORY" sender:self];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"SEGUE_SHOW_STORY"]){
        [segue.destinationViewController setValue:_SelectedStory forKey:@"Story"];
    }
}


@end
