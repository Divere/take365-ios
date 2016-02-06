//
//  StoryModel.h
//  take365
//
//  Created by Evgeniy Eliseev on 01.12.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import "JSONModel.h"
#import "AuthorModel.h"
#import "StoryProgressModel.h"

@protocol AuthorModel
@end

@interface StoryModel : JSONModel

@property (nonatomic) NSArray<AuthorModel> *authors;
@property (nonatomic) int id;
@property (nonatomic) StoryProgressModel *progress;
@property (nonatomic) int status;
@property (nonatomic) NSString<Optional> *title;
@property (nonatomic) NSString *url;

@end
