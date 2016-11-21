//
//  StoryViewController.h
//  take365
//
//  Created by Evgeniy Eliseev on 01.12.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Take365ViewController.h"

@interface StoryViewController : Take365ViewController

@property (nonatomic) StoryModel *Story;

@property (weak, nonatomic) IBOutlet UICollectionView *uivPhotos;

@end
