//
//  AuthorModel.h
//  take365
//
//  Created by Evgeniy Eliseev on 01.12.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import "Model.h"
#import "StoryImageThumbModel.h"

@interface AuthorModel : Model

@property (nonatomic) int id;
@property (nonatomic) NSString *url;
@property (nonatomic) NSString *username;
@property (nonatomic) StoryImageThumbModel *userpic;
@property (nonatomic) StoryImageThumbModel *userpicLarge;

@end
