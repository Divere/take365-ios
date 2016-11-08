//
//  StoryItemCollectionViewCell.h
//  take365
//
//  Created by Evgeniy Eliseev on 08/11/2016.
//  Copyright © 2016 take365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryDay.h"

@interface StoryItemCollectionViewCell : UICollectionViewCell

@property (nonatomic) StoryDay *StoryDay;
@property (weak, nonatomic) IBOutlet UIProgressView *pbUploadProgress;

- (void)changeSelectedColor:(BOOL)selected;

@end
