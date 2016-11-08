//
//  PhotoCollectionViewCell.h
//  take365
//
//  Created by Evgeniy Eliseev on 01.12.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryItemCollectionViewCell.h"

@interface CalendarCollectionViewCell : StoryItemCollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblDay;

- (void)changeSelectedColor:(BOOL)selected;

@end
