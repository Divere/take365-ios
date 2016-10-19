//
//  PhotoCollectionViewCell.h
//  take365
//
//  Created by Evgeniy Eliseev on 01.12.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryDay.h"

@interface CalendarCollectionViewCell : UICollectionViewCell

@property (nonatomic) StoryDay *StoryDay;
@property (weak, nonatomic) IBOutlet UILabel *lblDay;
@property (weak, nonatomic) IBOutlet UIProgressView *pbUploadProgress;

@end
