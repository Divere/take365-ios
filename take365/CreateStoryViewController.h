//
//  CreateStoryViewController.h
//  take365
//
//  Created by Evgeniy Eliseev on 23.01.16.
//  Copyright © 2016 take365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiTableViewController.h"

@interface CreateStoryViewController : ApiTableViewController

@property (weak, nonatomic) IBOutlet UITextField *tfTitle;
@property (weak, nonatomic) IBOutlet UITextField *tfDescription;
@property (weak, nonatomic) IBOutlet UISegmentedControl *scPrivacyLevel;

@end
