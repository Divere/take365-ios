//
//  StoryListResponse.h
//  take365
//
//  Created by Evgeniy Eliseev on 01.12.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import "Model.h"
#import "StoryModel.h"

@protocol StoryModel
@end

@interface StoryListResponse : Model

@property (nonatomic) NSArray<StoryModel> *result;
@property (nonatomic) NSArray *errors;

@end
