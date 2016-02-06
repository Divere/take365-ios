//
//  MonthCollectionReusableView.h
//  take365
//
//  Created by Evgeniy Eliseev on 28.01.16.
//  Copyright © 2016 take365. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthCollectionReusableView : UICollectionReusableView

@property (nonatomic) IBOutlet UILabel *lblMonth;
@property (weak, nonatomic) IBOutlet UILabel *lblYear;

@end
