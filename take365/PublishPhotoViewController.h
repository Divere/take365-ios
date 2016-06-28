//
//  PublishPhotoViewController.h
//  take365
//
//  Created by Evgeniy Eliseev on 27.01.16.
//  Copyright © 2016 take365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMBaseViewController.h"

@interface PublishPhotoViewController : PMBaseViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblYear;
@property (weak, nonatomic) IBOutlet UILabel *lblMonth;
@property (weak, nonatomic) IBOutlet UILabel *lblDay;

@property (weak, nonatomic) IBOutlet UIImageView *uivBackground;
@property (weak, nonatomic) IBOutlet UIPickerView *pvStoryPicker;
@property (weak, nonatomic) IBOutlet UIImageView *uivImage;
@property (weak, nonatomic) IBOutlet UIProgressView *pvUploadProgress;
@property (weak, nonatomic) IBOutlet UIButton *btnPublish;

@property (nonatomic) UIImage *Image;

@end
