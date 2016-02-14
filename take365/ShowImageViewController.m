//
//  ShowImageViewController.m
//  take365
//
//  Created by Evgeniy Eliseev on 28.01.16.
//  Copyright © 2016 take365. All rights reserved.
//

#import "ShowImageViewController.h"

@interface ShowImageViewController ()

@end

@implementation ShowImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDateFormatter *df = [NSDateFormatter new];
    [df setLocale: [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [df dateFromString:_Image.date];
    
    [df setDateFormat:@"LLLL"];
    NSString *month = [df stringFromDate:date];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSInteger year = [components year];
    NSInteger day = [components day];
    
    _lblMonth.text = month;
    _lblYear.text = [@(year) stringValue];
    _lblDay.text = [@(day) stringValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_Image.thumbLarge.url]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_aiLoading stopAnimating];
            _uiImage.image = image;
        });
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
