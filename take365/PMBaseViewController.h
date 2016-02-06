//
//  SDEViewController.h
//  SDE SmartHome
//
//  Created by Evgeniy Eliseev on 10.12.14.
//  Copyright (c) 2014 Evgeniy Eliseev. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface PMBaseViewController : UIViewController<UITextFieldDelegate>

@end
