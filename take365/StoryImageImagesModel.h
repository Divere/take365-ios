//
//  StoryImageImagesModel.h
//  take365
//
//  Created by Evgeniy Eliseev on 01.12.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import "Model.h"
#import "StoryImageThumbModel.h"

@interface StoryImageImagesModel : Model

@property (nonatomic) NSString *date;
@property (nonatomic) int id;
@property (nonatomic) StoryImageThumbModel *thumb;
@property (nonatomic) StoryImageThumbModel *thumbLarge;
@property (nonatomic) StoryImageThumbModel *image;
@property (nonatomic) StoryImageThumbModel *imageLarge;
@property (nonatomic) NSString *title;

@end
