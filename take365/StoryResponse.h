//
//  StoryResponse.h
//  take365
//
//  Created by Evgeniy Eliseev on 01.12.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import "JSONModel.h"
#import "StoryResult.h"

@interface StoryResponse : JSONModel

@property (nonatomic) StoryResult<Optional> *result;
@property (nonatomic) NSArray<Optional> *errors;

@end
