//
//  NavigationViewController.h
//  take365
//
//  Created by Evgeniy Eliseev on 28.01.16.
//  Copyright © 2016 take365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryModel.h"

@interface NavigationViewController : UITabBarController

+(NavigationViewController*)getInstance;
-(void)navigateToStory:(StoryModel*)story;

@end
