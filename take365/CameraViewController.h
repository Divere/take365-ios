//
//  SecondViewController.h
//  take365
//
//  Created by Evgeniy Eliseev on 26.10.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiViewController.h"

@interface CameraViewController : ApiViewController

@property IBOutlet UIStackView *svDate;
@property IBOutlet UILabel *lblMonth;
@property IBOutlet UILabel *lblDay;
@property IBOutlet UILabel *lblYear;
@property (weak, nonatomic) IBOutlet UIImageView *uivPhotoView;
@property (weak, nonatomic) IBOutlet UIButton *btnMakeShot;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnMakeShotWidthConstraint;


@end
