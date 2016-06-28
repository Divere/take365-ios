//
//  SecondViewController.h
//  take365
//
//  Created by Evgeniy Eliseev on 26.10.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UIViewController

@property IBOutlet UIView *topBarView;
@property IBOutlet UIView *bottmBarView;
@property IBOutlet UIStackView *svDate;
@property IBOutlet UILabel *lblMonth;
@property IBOutlet UILabel *lblDay;
@property IBOutlet UILabel *lblYear;
@property (weak, nonatomic) IBOutlet UIButton *btnMakeShot;

@end