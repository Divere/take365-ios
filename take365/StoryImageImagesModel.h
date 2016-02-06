//
//  StoryImageImagesModel.h
//  take365
//
//  Created by Evgeniy Eliseev on 01.12.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import "JSONModel.h"
#import "StoryImageThumbModel.h"

@interface StoryImageImagesModel : JSONModel

@property (nonatomic) NSString *date;
@property (nonatomic) int id;
@property (nonatomic) StoryImageThumbModel *thumb;
@property (nonatomic) StoryImageThumbModel *thumbLarge;
@property (nonatomic) NSString<Optional> *title;

@end
