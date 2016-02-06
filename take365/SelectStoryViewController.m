//
//  SelectStoryViewController.m
//  take365
//
//  Created by Evgeniy Eliseev on 01.12.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import "SelectStoryViewController.h"
#import "StoryCellTableViewCell.h"
#import "AppDelegate.h"

@interface SelectStoryViewController ()
{
    NSArray<StoryModel> *stories;
}
@end

@implementation SelectStoryViewController
{
    ApiManager *api;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.title = @"Мои истории";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" + " style:UIBarButtonItemStyleDone target:self action:@selector(newStory)];
    
    api = [AppDelegate getInstance].api;
    if(api.Stories != NULL){
        stories = api.Stories;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [api getStoryListWithResultBlock:^(NSArray<StoryModel> *result, NSString *error) {
        if(error == nil){
            stories = result;
            [_tableView reloadData];
        }
    }];
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
        cell.lblCompleted.text = [[NSString alloc] initWithFormat:@"%.2f%@", model.progress.percentsComplete,@"%"];
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
        _SelectedStory = [stories objectAtIndex:_tableView.indexPathForSelectedRow.row];
        if(indexPath.row == 1){
            _SelectedStory.id = 162;
        }
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
