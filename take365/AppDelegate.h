//
//  AppDelegate.h
//  take365
//
//  Created by Evgeniy Eliseev on 26.10.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONModelLib.h"
#import "Take365Service.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+(AppDelegate*)getInstance;

@end

