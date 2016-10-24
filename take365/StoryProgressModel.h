//
//  StoryProgressModel.h
//  take365
//
//  Created by Evgeniy Eliseev on 01.12.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import "JSONModel.h"

@interface StoryProgressModel : JSONModel

@property (nonatomic) NSNumber<Optional> *delayDays;
@property (nonatomic) int passedDays;
@property (nonatomic) double percentsComplete;
@property (nonatomic) int totalImages;
@property (nonatomic) int totalDays;
@property (nonatomic) NSString *totalImagesTitle;
@property (nonatomic) BOOL isOutdated;
@property (nonatomic) NSString *dateStart;
@property (nonatomic) NSString *dateEnd;

@end
