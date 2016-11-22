//
//  StoryModel.h
//  take365
//
//  Created by Evgeniy Eliseev on 01.12.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import "Model.h"
#import "StoryProgressModel.h"

@class AuthorModel;

@interface StoryModel : Model

@property (nonatomic) NSArray<AuthorModel*> *authors;
@property (nonatomic) int id;
@property (nonatomic) StoryProgressModel *progress;
@property (nonatomic) int status;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *url;

@end
