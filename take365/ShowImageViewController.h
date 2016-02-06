//
//  ShowImageViewController.h
//  take365
//
//  Created by Evgeniy Eliseev on 28.01.16.
//  Copyright © 2016 take365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryImageImagesModel.h"


@interface ShowImageViewController : UIViewController

@property (nonatomic) StoryImageImagesModel *Image;

@property (weak, nonatomic) IBOutlet UILabel *lblMonth;
@property (weak, nonatomic) IBOutlet UILabel *lblDay;
@property (weak, nonatomic) IBOutlet UILabel *lblYear;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *aiLoading;
@property (weak, nonatomic) IBOutlet UIImageView *uiImage;

@end
