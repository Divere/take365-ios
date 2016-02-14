//
//  PhotoCollectionViewCell.h
//  take365
//
//  Created by Evgeniy Eliseev on 01.12.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryImageImagesModel.h"

@interface PhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic) StoryImageImagesModel *Image;

@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto;
@property (nonatomic) BOOL isSelected;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *aiLoading;
@property (weak, nonatomic) IBOutlet UILabel *lblDay;

@end