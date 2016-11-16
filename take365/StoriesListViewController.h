//
//  SelectStoryViewController.h
//  take365
//
//  Created by Evgeniy Eliseev on 01.12.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryModel.h"
#import "Take365ViewController.h"

@interface StoriesListViewController : Take365ViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) StoryModel *SelectedStory;

@end
