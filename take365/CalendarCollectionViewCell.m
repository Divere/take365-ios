//
//  PhotoCollectionViewCell.m
//  take365
//
//  Created by Evgeniy Eliseev on 01.12.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import "CalendarCollectionViewCell.h"

@implementation CalendarCollectionViewCell

-(void)changeSelectedColor:(BOOL)selected
{
    if(selected){
        UIView *backgroundView = [UIView new];
        backgroundView.backgroundColor = [UIColor lightGrayColor];
        self.backgroundView = backgroundView;
    }else{
        self.backgroundView = NULL;
    }
}

@end
