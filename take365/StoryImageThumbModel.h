//
//  StoryImageThumbModel.h
//  take365
//
//  Created by Evgeniy Eliseev on 01.12.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import "JSONModel.h"

@interface StoryImageThumbModel : JSONModel

@property (nonatomic) int height;
@property (nonatomic) NSString *url;
@property (nonatomic) int width;

@end
