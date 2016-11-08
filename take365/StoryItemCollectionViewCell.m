//
//  StoryItemCollectionViewCell.m
//  take365
//
//  Created by Evgeniy Eliseev on 08/11/2016.
//  Copyright © 2016 take365. All rights reserved.
//

#import "StoryItemCollectionViewCell.h"

@implementation StoryItemCollectionViewCell

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
