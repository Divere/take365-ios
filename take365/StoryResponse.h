//
//  StoryResponse.h
//  take365
//
//  Created by Evgeniy Eliseev on 01.12.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import "Model.h"
#import "StoryResult.h"

@interface StoryResponse : Model

@property (nonatomic) StoryResult *result;
@property (nonatomic) NSArray *errors;

@end
