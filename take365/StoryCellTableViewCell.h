//
//  StoryCellTableViewCell.h
//  take365
//
//  Created by Evgeniy Eliseev on 01.12.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblStoryName;
@property (weak, nonatomic) IBOutlet UILabel *lblCompleted;

@end
